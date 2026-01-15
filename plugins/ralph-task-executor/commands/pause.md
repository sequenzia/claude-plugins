---
description: Pause the current task execution loop
argument-hint: [reason]
allowed-tools: [Read, Write, Bash]
allowed-paths: [".claude/ralph-task-executor.state.json"]
model: inherit
---

# Pause Execution

Pause the current task execution loop. The current ralph-loop will be cancelled and state will be preserved for later resume.

## Arguments

- `$1` (optional): Reason for pausing (stored in state for reference)

## Process

### 1. Load Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no active execution to pause
- If status is not "running": Report execution is already paused/completed/aborted

### 2. Cancel Active Ralph-Loop

If there's a current task running via ralph-loop:

```
Invoke: /cancel-ralph

This will:
- Stop the ralph-loop iteration
- Preserve work done so far (in files/git)
- Allow clean state save
```

### 3. Update Execution State

Update state file:

```json
{
  "status": "paused",
  "paused_at": "<current-ISO-timestamp>",
  "pause_reason": "<reason or null>",
  "last_activity": "<current-ISO-timestamp>",
  // current_task, in_progress remain unchanged for resume
}
```

### 4. Report Status

## Output

```
## Execution Paused

**Paused at:** {timestamp}
**Reason:** {reason or "Not specified"}

### State at Pause

- **Current Task:** {TASK-ID}: {title}
- **Iteration:** {N}/{max}
- **Completed:** {completed_count} tasks
- **Remaining:** {remaining_count} tasks

### Resume Options

To resume from current task:
  /ralph-task-executor:resume

To skip current task and continue:
  /ralph-task-executor:resume --skip-current

To start from a specific task:
  /ralph-task-executor:resume --task-id TASK-XXX

To abort execution entirely:
  /ralph-task-executor:abort
```

## Error Handling

- **No execution state:** "No active execution found. Nothing to pause."
- **Already paused:** "Execution is already paused. Use /ralph-task-executor:resume to continue."
- **Already completed:** "Execution has already completed. Nothing to pause."
- **Cancel-ralph fails:** Log warning but still update state to paused

## Example Usage

```bash
# Pause without reason
/ralph-task-executor:pause

# Pause with reason
/ralph-task-executor:pause "Need to review task output before continuing"
```
