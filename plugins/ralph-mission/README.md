# Ralph Mission

Mission-driven autonomous development loop for Claude Code. Iterates through tasks from a mission-control tasks.json file, implementing each one until all are complete.

## Overview

Ralph Mission combines the Ralph Wiggum Loop pattern with mission-control's task management system. Instead of repeating the same prompt, it picks the next highest-priority task and works on it autonomously.

## Installation

Ensure this plugin is in your Claude Code plugins directory and enabled in settings.

**Requires:** `jq` (JSON processor)
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt install jq
```

## Usage

### Start a Mission Loop

```bash
/ralph-mission <path-to-tasks.json> [options]
```

**Arguments:**
- `<mission-path>` - Path to mission-control tasks.json file (required)

**Options:**
- `--max-iterations N` - Maximum iterations before auto-stop (default: 50)
- `--max-failed-attempts N` - Attempts per task before marking blocked (default: 3)
- `--help` - Show help

**Examples:**
```bash
# Basic usage
/ralph-mission missions/auth-system/spec.tasks.json

# With iteration limit
/ralph-mission missions/api/tasks.json --max-iterations 100

# With custom failure threshold
/ralph-mission tasks.json --max-failed-attempts 5
```

### Monitor Progress

```bash
/ralph-mission:status
```

Shows:
- Current task and attempts
- Completion progress
- Iteration count

### Cancel Loop

```bash
/ralph-mission:cancel
```

Immediately stops the loop and shows summary.

## How It Works

### Task Selection (Priority Scoring)

Tasks are selected by priority score:
```
score = (priority_weight × 100) + (blocks_count × 50) + complexity_bonus
```

| Priority | Weight |
|----------|--------|
| critical | 4 |
| high | 3 |
| medium | 2 |
| low | 1 |

| Complexity | Bonus |
|------------|-------|
| XS | +15 |
| S | +10 |
| M | +5 |
| L | 0 |
| XL | -5 |

Only tasks with `status: "not_started"` and empty `blocked_by` are considered.

### Completion Detection

The loop detects task completion by reading the tasks.json file. When you complete a task:

1. Edit the tasks.json file
2. Find the current task by ID
3. Change `"status": "not_started"` to `"status": "complete"`
4. Commit your changes

The stop hook reads the file and detects the status change.

### Failure Handling

If a task isn't completed after `max_failed_attempts`:
1. The task is marked as `"blocked"` in the JSON file
2. The loop moves to the next available task
3. Failure is logged to progress.txt

### Progress Tracking

Learnings and session history are logged to `progress.txt` in the mission directory:

```
missions/my-project/
├── spec.tasks.json    # Task data
└── progress.txt       # Session log
```

## Workflow

```
1. Generate tasks with mission-control
   /mission-control:generate "My Project" spec.md

2. Start ralph-mission
   /ralph-mission missions/my-project/spec.tasks.json

3. For each task:
   a. Claude implements the task
   b. Verifies acceptance criteria
   c. Updates task status to "complete"
   d. Commits: feat: TASK-XXX - <title>
   e. Loop automatically continues to next task

4. Loop ends when:
   - All tasks complete
   - All remaining tasks blocked
   - Max iterations reached
   - User runs /ralph-mission:cancel
```

## Key Differences from ralph-loop

| Aspect | ralph-loop | ralph-mission |
|--------|------------|---------------|
| Task Source | Single prompt | mission-control tasks.json |
| Loop Condition | Same prompt repeatedly | Pick next task by priority |
| Completion | `<promise>` tag match | Task status in JSON |
| Progress | Iteration counter | Task completion + progress.txt |
| Commits | Optional | Required per task |

## State File

Loop state is stored in `.claude/ralph-mission.local.md`:

```yaml
---
active: true
mission_path: "missions/my-project/spec.tasks.json"
mission_name: "My Project"
current_task_id: "TASK-001"
iteration: 1
max_iterations: 50
max_failed_attempts: 3
current_attempts: 0
started_at: "2025-01-22T14:30:00Z"
---
```

## Safety Features

1. **Max iterations** - Prevents infinite loops (default: 50)
2. **Max attempts** - Moves on from stuck tasks (default: 3)
3. **Progress logging** - Tracks all activity
4. **Git commits** - Required for each task, provides rollback points
5. **Dependency blocking** - Won't start tasks with unmet dependencies

## Troubleshooting

### "jq not installed"
Install jq: `brew install jq` or `apt install jq`

### "No available tasks"
All remaining tasks may be blocked by dependencies. Check the tasks.json for `blocked_by` arrays.

### "Invalid mission file format"
Ensure the file matches mission-control schema:
```json
{
  "mission": {
    "name": "...",
    "tasks": [...]
  }
}
```

### Loop stuck on same task
Check that you're updating the task status in the JSON file, not just in memory.

## Related Plugins

- **mission-control** - Generate task lists from specifications
- **ralph-loop** - Simple prompt-based looping
- **dev-tools** - Git commit automation

## License

MIT
