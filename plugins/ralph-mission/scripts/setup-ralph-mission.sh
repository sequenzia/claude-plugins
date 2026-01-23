#!/bin/bash

# Ralph Mission Setup Script
# Creates state file for mission-driven autonomous loop

set -euo pipefail

# Parse arguments
MISSION_PATH=""
MAX_ITERATIONS=50
MAX_FAILED_ATTEMPTS=3

# Parse options and positional arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      cat << 'HELP_EOF'
Ralph Mission - Mission-driven autonomous development loop

USAGE:
  /ralph-mission <mission-path> [OPTIONS]

ARGUMENTS:
  mission-path    Path to mission-control tasks.json file (required)

OPTIONS:
  --max-iterations <n>        Maximum iterations before auto-stop (default: 50)
  --max-failed-attempts <n>   Attempts per task before marking blocked (default: 3)
  -h, --help                  Show this help message

DESCRIPTION:
  Starts a Ralph Mission loop that autonomously iterates through tasks
  from a mission-control tasks.json file. Each task is worked on until
  its status is set to "complete" in the JSON file.

  Tasks are selected by priority score:
    score = (priority × 100) + (blocks × 50) + complexity_bonus

  Priority weights: critical=4, high=3, medium=2, low=1
  Complexity bonus: XS=+15, S=+10, M=+5, L=0, XL=-5

WORKFLOW:
  For each task:
  1. Implement the task according to its description
  2. Verify all acceptance criteria are met
  3. Update status to "complete" in the tasks.json file
  4. Commit changes with: feat: TASK-XXX - <title>

  The loop detects completion by reading the JSON file.
  If a task fails max-failed-attempts times, it's marked "blocked"
  and the loop moves to the next available task.

EXAMPLES:
  /ralph-mission missions/auth-system/spec.tasks.json
  /ralph-mission missions/api/tasks.json --max-iterations 100
  /ralph-mission tasks.json --max-failed-attempts 5

MONITORING:
  /ralph-mission:status    - Show current progress
  /ralph-mission:cancel    - Stop the loop

PROGRESS:
  Learnings are logged to progress.txt in the mission directory.
HELP_EOF
      exit 0
      ;;
    --max-iterations)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --max-iterations requires a number argument" >&2
        exit 1
      fi
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: --max-iterations must be a positive integer, got: $2" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --max-failed-attempts)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --max-failed-attempts requires a number argument" >&2
        exit 1
      fi
      if ! [[ "$2" =~ ^[0-9]+$ ]] || [[ "$2" -lt 1 ]]; then
        echo "❌ Error: --max-failed-attempts must be a positive integer >= 1, got: $2" >&2
        exit 1
      fi
      MAX_FAILED_ATTEMPTS="$2"
      shift 2
      ;;
    -*)
      echo "❌ Error: Unknown option: $1" >&2
      echo "   Use --help for usage information" >&2
      exit 1
      ;;
    *)
      if [[ -z "$MISSION_PATH" ]]; then
        MISSION_PATH="$1"
      else
        echo "❌ Error: Multiple mission paths provided" >&2
        echo "   Expected: /ralph-mission <single-path> [options]" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# Validate mission path provided
if [[ -z "$MISSION_PATH" ]]; then
  echo "❌ Error: No mission path provided" >&2
  echo "" >&2
  echo "   Usage: /ralph-mission <path-to-tasks.json>" >&2
  echo "" >&2
  echo "   Examples:" >&2
  echo "     /ralph-mission missions/my-project/spec.tasks.json" >&2
  echo "     /ralph-mission tasks.json --max-iterations 100" >&2
  echo "" >&2
  echo "   For help: /ralph-mission --help" >&2
  exit 1
fi

# Validate mission file exists
if [[ ! -f "$MISSION_PATH" ]]; then
  echo "❌ Error: Mission file not found: $MISSION_PATH" >&2
  echo "" >&2
  echo "   Make sure the path is correct and the file exists." >&2
  echo "   Generate a mission file with: /mission-control:generate" >&2
  exit 1
fi

# Check jq is available
if ! command -v jq &> /dev/null; then
  echo "❌ Error: jq is required but not installed" >&2
  echo "" >&2
  echo "   Install with:" >&2
  echo "     macOS:  brew install jq" >&2
  echo "     Ubuntu: sudo apt install jq" >&2
  echo "     Other:  https://stedolan.github.io/jq/download/" >&2
  exit 1
fi

# Validate JSON structure
if ! jq -e '.mission.tasks' "$MISSION_PATH" > /dev/null 2>&1; then
  echo "❌ Error: Invalid mission file format" >&2
  echo "" >&2
  echo "   Expected mission-control tasks.json with structure:" >&2
  echo "   { \"mission\": { \"name\": \"...\", \"tasks\": [...] } }" >&2
  echo "" >&2
  echo "   File: $MISSION_PATH" >&2
  exit 1
fi

# Read mission data
MISSION_DATA=$(cat "$MISSION_PATH")
MISSION_NAME=$(echo "$MISSION_DATA" | jq -r '.mission.name')
TOTAL_TASKS=$(echo "$MISSION_DATA" | jq '.mission.tasks | length')
COMPLETED_TASKS=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "complete")] | length')
BLOCKED_TASKS=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "blocked")] | length')

# Check for empty task list
if [[ $TOTAL_TASKS -eq 0 ]]; then
  echo "❌ Error: Mission has no tasks" >&2
  echo "   File: $MISSION_PATH" >&2
  exit 1
fi

# Find first ready task using priority scoring
FIRST_TASK=$(echo "$MISSION_DATA" | jq -r '
  def priority_weight:
    if . == "critical" then 4
    elif . == "high" then 3
    elif . == "medium" then 2
    elif . == "low" then 1
    else 1
    end;

  def complexity_bonus:
    if . == "XS" then 15
    elif . == "S" then 10
    elif . == "M" then 5
    elif . == "L" then 0
    elif . == "XL" then -5
    else 0
    end;

  [.mission.tasks[] | select(.status == "not_started" and (.blocked_by | length) == 0)]
  | map(. + {
      score: ((.priority | priority_weight) * 100) +
             ((.blocks // []) | length) * 50 +
             (.complexity | complexity_bonus)
    })
  | sort_by(-.score)
  | if length > 0 then .[0].id else "" end
')

if [[ -z "$FIRST_TASK" ]]; then
  echo "❌ Error: No available tasks to start" >&2
  echo "" >&2
  echo "   Mission: $MISSION_NAME" >&2
  echo "   Total: $TOTAL_TASKS tasks" >&2
  echo "   Completed: $COMPLETED_TASKS" >&2
  echo "   Blocked: $BLOCKED_TASKS" >&2
  echo "" >&2
  echo "   All remaining tasks may be blocked by dependencies." >&2
  exit 1
fi

# Get first task details for display
FIRST_TASK_DETAILS=$(echo "$MISSION_DATA" | jq --arg id "$FIRST_TASK" '.mission.tasks[] | select(.id == $id)')
FIRST_TASK_TITLE=$(echo "$FIRST_TASK_DETAILS" | jq -r '.title')
FIRST_TASK_PRIORITY=$(echo "$FIRST_TASK_DETAILS" | jq -r '.priority')
FIRST_TASK_COMPLEXITY=$(echo "$FIRST_TASK_DETAILS" | jq -r '.complexity')

# Create state file
mkdir -p .claude
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cat > .claude/ralph-mission.local.md << EOF
---
active: true
mission_path: "$MISSION_PATH"
mission_name: "$MISSION_NAME"
current_task_id: "$FIRST_TASK"
iteration: 1
max_iterations: $MAX_ITERATIONS
max_failed_attempts: $MAX_FAILED_ATTEMPTS
current_attempts: 0
started_at: "$TIMESTAMP"
---
EOF

# Calculate ready tasks count
READY_TASKS=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "not_started" and (.blocked_by | length) == 0)] | length')
REMAINING_TASKS=$((TOTAL_TASKS - COMPLETED_TASKS - BLOCKED_TASKS))

# Output activation message
cat << EOF
🔄 Ralph Mission activated!

Mission: $MISSION_NAME
Source: $MISSION_PATH

Tasks:
  ✅ Completed: $COMPLETED_TASKS
  🚫 Blocked: $BLOCKED_TASKS
  ⏳ Remaining: $REMAINING_TASKS
  🎯 Ready now: $READY_TASKS

Configuration:
  Max iterations: $MAX_ITERATIONS
  Max attempts per task: $MAX_FAILED_ATTEMPTS

Starting Task:
  ID: $FIRST_TASK
  Title: $FIRST_TASK_TITLE
  Priority: $FIRST_TASK_PRIORITY
  Complexity: $FIRST_TASK_COMPLEXITY

The stop hook is now active. When you complete a task:
1. Update its status to "complete" in the tasks.json file
2. Commit your changes
3. The loop will automatically detect completion and proceed

Progress will be logged to: $(dirname "$MISSION_PATH")/progress.txt

To monitor: /ralph-mission:status
To cancel: /ralph-mission:cancel

═══════════════════════════════════════════════════════════
EOF

# Display first task prompt
echo ""
echo "## Current Task: $FIRST_TASK"
echo "**$FIRST_TASK_TITLE**"
echo ""
echo "Priority: $FIRST_TASK_PRIORITY | Complexity: $FIRST_TASK_COMPLEXITY"
echo ""
echo "$(echo "$FIRST_TASK_DETAILS" | jq -r '.description')"
echo ""
echo "### Acceptance Criteria"
echo "$FIRST_TASK_DETAILS" | jq -r '.acceptance_criteria | map("- [ ] " + .) | join("\n")'
echo ""
echo "### Instructions"
echo ""
echo "1. Implement this task completely"
echo "2. Verify all acceptance criteria are met"
echo "3. Update task status in $MISSION_PATH:"
echo "   - Find task $FIRST_TASK"
echo "   - Set \"status\": \"complete\""
echo "4. Commit changes: \`feat: $FIRST_TASK - $FIRST_TASK_TITLE\`"
echo ""
echo "⚠️  Do NOT mark complete unless ALL criteria are genuinely met."
echo "═══════════════════════════════════════════════════════════"
