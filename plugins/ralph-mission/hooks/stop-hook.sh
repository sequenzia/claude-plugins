#!/bin/bash

# Ralph Mission Stop Hook
# Prevents session exit when a ralph-mission loop is active
# Iterates through mission-control tasks until all complete

set -euo pipefail

# Read hook input from stdin (advanced stop hook API)
HOOK_INPUT=$(cat)

# Check if ralph-mission is active
RALPH_STATE_FILE=".claude/ralph-mission.local.md"

if [[ ! -f "$RALPH_STATE_FILE" ]]; then
  # No active loop - allow exit
  exit 0
fi

# Parse markdown frontmatter (YAML between ---) and extract values
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$RALPH_STATE_FILE")

# Extract state values
MISSION_PATH=$(echo "$FRONTMATTER" | grep '^mission_path:' | sed 's/mission_path: *//' | sed 's/^"\(.*\)"$/\1/')
MISSION_NAME=$(echo "$FRONTMATTER" | grep '^mission_name:' | sed 's/mission_name: *//' | sed 's/^"\(.*\)"$/\1/')
CURRENT_TASK_ID=$(echo "$FRONTMATTER" | grep '^current_task_id:' | sed 's/current_task_id: *//' | sed 's/^"\(.*\)"$/\1/')
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
MAX_FAILED_ATTEMPTS=$(echo "$FRONTMATTER" | grep '^max_failed_attempts:' | sed 's/max_failed_attempts: *//')
CURRENT_ATTEMPTS=$(echo "$FRONTMATTER" | grep '^current_attempts:' | sed 's/current_attempts: *//')

# Validate numeric fields
for field_name in ITERATION MAX_ITERATIONS MAX_FAILED_ATTEMPTS CURRENT_ATTEMPTS; do
  field_value="${!field_name}"
  if [[ ! "$field_value" =~ ^[0-9]+$ ]]; then
    echo "⚠️  Ralph Mission: State file corrupted" >&2
    echo "   File: $RALPH_STATE_FILE" >&2
    echo "   Problem: '$field_name' is not a valid number (got: '$field_value')" >&2
    echo "   Ralph Mission is stopping. Run /ralph-mission again to start fresh." >&2
    rm "$RALPH_STATE_FILE"
    exit 0
  fi
done

# Check if max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "🛑 Ralph Mission: Max iterations ($MAX_ITERATIONS) reached."
  echo "   Mission: $MISSION_NAME"
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# Validate mission file exists
if [[ ! -f "$MISSION_PATH" ]]; then
  echo "⚠️  Ralph Mission: Mission file not found" >&2
  echo "   Expected: $MISSION_PATH" >&2
  echo "   Ralph Mission is stopping." >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# Check jq is available
if ! command -v jq &> /dev/null; then
  echo "⚠️  Ralph Mission: jq is required but not installed" >&2
  echo "   Install with: brew install jq (macOS) or apt install jq (Linux)" >&2
  rm "$RALPH_STATE_FILE"
  exit 0
fi

# Read mission data
MISSION_DATA=$(cat "$MISSION_PATH")

# Get mission directory for progress file
MISSION_DIR=$(dirname "$MISSION_PATH")
PROGRESS_FILE="$MISSION_DIR/progress.txt"

# Get current task status
CURRENT_TASK_STATUS=$(echo "$MISSION_DATA" | jq -r --arg id "$CURRENT_TASK_ID" '
  .mission.tasks[] | select(.id == $id) | .status
')

# Get counts for progress tracking
TOTAL_TASKS=$(echo "$MISSION_DATA" | jq '.mission.tasks | length')
COMPLETED_TASKS=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "complete")] | length')
BLOCKED_TASKS=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "blocked")] | length')

# Calculate timestamp
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Initialize progress file if it doesn't exist
if [[ ! -f "$PROGRESS_FILE" ]]; then
  cat > "$PROGRESS_FILE" << EOF
# Ralph Mission Progress
Mission: $MISSION_NAME
Started: $TIMESTAMP
Source: $MISSION_PATH

## Session Log

EOF
fi

# Function to find next ready task using priority scoring
find_next_task() {
  echo "$MISSION_DATA" | jq -r '
    # Priority weights
    def priority_weight:
      if . == "critical" then 4
      elif . == "high" then 3
      elif . == "medium" then 2
      elif . == "low" then 1
      else 1
      end;

    # Complexity bonus (simpler tasks get higher scores)
    def complexity_bonus:
      if . == "XS" then 15
      elif . == "S" then 10
      elif . == "M" then 5
      elif . == "L" then 0
      elif . == "XL" then -5
      else 0
      end;

    # Filter for ready tasks (not_started and not blocked)
    [.mission.tasks[] | select(.status == "not_started" and (.blocked_by | length) == 0)]

    # Calculate scores and sort
    | map(. + {
        score: ((.priority | priority_weight) * 100) +
               ((.blocks // []) | length) * 50 +
               (.complexity | complexity_bonus)
      })
    | sort_by(-.score)

    # Return first task ID or empty
    | if length > 0 then .[0].id else "" end
  '
}

# Handle current task status
if [[ "$CURRENT_TASK_STATUS" == "complete" ]]; then
  # Task completed! Log success and find next task
  CURRENT_TASK_TITLE=$(echo "$MISSION_DATA" | jq -r --arg id "$CURRENT_TASK_ID" '
    .mission.tasks[] | select(.id == $id) | .title
  ')

  # Log completion to progress file
  cat >> "$PROGRESS_FILE" << EOF
### Iteration $ITERATION - $TIMESTAMP
Task: $CURRENT_TASK_ID - $CURRENT_TASK_TITLE
Status: COMPLETED ✅

EOF

  # Find next task
  NEXT_TASK_ID=$(find_next_task)

  if [[ -z "$NEXT_TASK_ID" ]]; then
    # Check if all tasks complete or all remaining are blocked
    REMAINING=$(echo "$MISSION_DATA" | jq '[.mission.tasks[] | select(.status == "not_started" or .status == "in_progress")] | length')

    if [[ $REMAINING -eq 0 ]]; then
      # All tasks complete!
      echo "✅ Ralph Mission: ALL TASKS COMPLETE!"
      echo "   Mission: $MISSION_NAME"
      echo "   Completed: $((COMPLETED_TASKS)) tasks in $ITERATION iterations"

      # Log summary
      cat >> "$PROGRESS_FILE" << EOF
## Mission Complete! 🎉

- Total iterations: $ITERATION
- Tasks completed: $COMPLETED_TASKS
- Tasks blocked: $BLOCKED_TASKS
- Finished: $TIMESTAMP
EOF

      rm "$RALPH_STATE_FILE"
      exit 0
    else
      # All remaining tasks are blocked
      echo "⚠️  Ralph Mission: All remaining tasks are blocked"
      echo "   Mission: $MISSION_NAME"
      echo "   Remaining: $REMAINING tasks (blocked by dependencies)"

      cat >> "$PROGRESS_FILE" << EOF
## Mission Stalled

All remaining tasks are blocked by dependencies.
- Completed: $COMPLETED_TASKS
- Blocked: $BLOCKED_TASKS
- Remaining (blocked): $REMAINING
EOF

      rm "$RALPH_STATE_FILE"
      exit 0
    fi
  fi

  # Update state for next task
  CURRENT_TASK_ID="$NEXT_TASK_ID"
  CURRENT_ATTEMPTS=0

else
  # Task not complete - increment attempts
  CURRENT_ATTEMPTS=$((CURRENT_ATTEMPTS + 1))

  if [[ $CURRENT_ATTEMPTS -ge $MAX_FAILED_ATTEMPTS ]]; then
    # Max attempts reached - mark task as blocked
    CURRENT_TASK_TITLE=$(echo "$MISSION_DATA" | jq -r --arg id "$CURRENT_TASK_ID" '
      .mission.tasks[] | select(.id == $id) | .title
    ')

    # Update task status to blocked in JSON file
    UPDATED_MISSION=$(echo "$MISSION_DATA" | jq --arg id "$CURRENT_TASK_ID" '
      .mission.tasks = [.mission.tasks[] |
        if .id == $id then .status = "blocked" else . end
      ]
    ')
    echo "$UPDATED_MISSION" > "$MISSION_PATH"
    MISSION_DATA="$UPDATED_MISSION"

    # Log failure
    cat >> "$PROGRESS_FILE" << EOF
### Iteration $ITERATION - $TIMESTAMP
Task: $CURRENT_TASK_ID - $CURRENT_TASK_TITLE
Status: BLOCKED 🚫 (after $MAX_FAILED_ATTEMPTS attempts)
Reason: Failed to complete after maximum attempts

EOF

    # Find next task
    NEXT_TASK_ID=$(find_next_task)

    if [[ -z "$NEXT_TASK_ID" ]]; then
      echo "⚠️  Ralph Mission: No more available tasks"
      echo "   Last task blocked: $CURRENT_TASK_ID"
      rm "$RALPH_STATE_FILE"
      exit 0
    fi

    CURRENT_TASK_ID="$NEXT_TASK_ID"
    CURRENT_ATTEMPTS=0
  fi
fi

# Increment iteration
NEXT_ITERATION=$((ITERATION + 1))

# Get current task details for prompt
CURRENT_TASK=$(echo "$MISSION_DATA" | jq --arg id "$CURRENT_TASK_ID" '
  .mission.tasks[] | select(.id == $id)
')

TASK_TITLE=$(echo "$CURRENT_TASK" | jq -r '.title')
TASK_DESC=$(echo "$CURRENT_TASK" | jq -r '.description')
TASK_PRIORITY=$(echo "$CURRENT_TASK" | jq -r '.priority')
TASK_COMPLEXITY=$(echo "$CURRENT_TASK" | jq -r '.complexity')
TASK_CRITERIA=$(echo "$CURRENT_TASK" | jq -r '.acceptance_criteria | map("- [ ] " + .) | join("\n")')
TASK_DEPS=$(echo "$CURRENT_TASK" | jq -r '.dependencies // [] | if length > 0 then join(", ") else "None" end')
TASK_BLOCKS=$(echo "$CURRENT_TASK" | jq -r '.blocks // [] | if length > 0 then join(", ") else "None" end')
TASK_SOURCE=$(echo "$CURRENT_TASK" | jq -r '.source_requirements // [] | join(", ")')
TASK_NOTES=$(echo "$CURRENT_TASK" | jq -r '.notes // ""')

# Get previous learnings if progress file exists
LEARNINGS="First iteration - no learnings yet"
if [[ -f "$PROGRESS_FILE" ]]; then
  # Get last 20 lines of progress for context
  LEARNINGS=$(tail -50 "$PROGRESS_FILE" | head -30)
fi

# Calculate completion percentage
COMPLETION_PCT=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))

# Build the prompt
PROMPT=$(cat << EOF
## Ralph Mission - Iteration $NEXT_ITERATION | Task $((COMPLETED_TASKS + 1))/$TOTAL_TASKS

### Mission: $MISSION_NAME
**Progress:** $COMPLETED_TASKS/$TOTAL_TASKS tasks ($COMPLETION_PCT%)

---

### Current Task: $CURRENT_TASK_ID
**$TASK_TITLE**
**Priority:** $TASK_PRIORITY | **Complexity:** $TASK_COMPLEXITY

$TASK_DESC

### Acceptance Criteria
$TASK_CRITERIA

### Context
**Depends on:** $TASK_DEPS
**Blocks:** $TASK_BLOCKS
**Source:** $TASK_SOURCE
$(if [[ -n "$TASK_NOTES" ]]; then echo -e "\n**Notes:** $TASK_NOTES"; fi)

### Previous Learnings
\`\`\`
$LEARNINGS
\`\`\`

---

## Instructions

1. **Implement** this task completely
2. **Verify** all acceptance criteria are met
3. **Run tests** if applicable
4. **Update task status** in $MISSION_PATH:
   - Edit the file
   - Find task $CURRENT_TASK_ID
   - Set "status": "complete"
5. **Commit** your changes with message: \`feat: $CURRENT_TASK_ID - $TASK_TITLE\`

## Completion

When this task is FULLY complete:
- All acceptance criteria verified
- Status updated to "complete" in tasks.json
- Changes committed to git

The loop will automatically detect completion and proceed to the next task.

⚠️ Do NOT update status to "complete" unless ALL criteria are met.
   The loop continues until genuine completion.
EOF
)

# Update state file
cat > "$RALPH_STATE_FILE" << EOF
---
active: true
mission_path: "$MISSION_PATH"
mission_name: "$MISSION_NAME"
current_task_id: "$CURRENT_TASK_ID"
iteration: $NEXT_ITERATION
max_iterations: $MAX_ITERATIONS
max_failed_attempts: $MAX_FAILED_ATTEMPTS
current_attempts: $CURRENT_ATTEMPTS
started_at: "$(echo "$FRONTMATTER" | grep '^started_at:' | sed 's/started_at: *//' | sed 's/^"\(.*\)"$/\1/')"
---
EOF

# Build system message
SYSTEM_MSG="🔄 Ralph Mission iteration $NEXT_ITERATION | Task: $CURRENT_TASK_ID ($TASK_TITLE) | Attempt: $((CURRENT_ATTEMPTS + 1))/$MAX_FAILED_ATTEMPTS | Progress: $COMPLETED_TASKS/$TOTAL_TASKS complete"

# Output JSON to block the stop and feed prompt back
jq -n \
  --arg prompt "$PROMPT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
