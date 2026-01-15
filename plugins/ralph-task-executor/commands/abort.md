---
description: Abort execution entirely and clean up state
argument-hint: [--keep-state]
allowed-tools: [Read, Write, Bash]
model: inherit
---

# Abort Execution

Abort the current task execution entirely. Cancels any active ralph-loop and cleans up state.

## Arguments

- `--keep-state`: Keep the state file for debugging instead of archiving it

## Process

### 1. Load Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no active execution to abort

### 2. Cancel Active Ralph-Loop

If execution status is "running" and there's a current task:

```
Invoke: /cancel-ralph

This stops the active ralph-loop and returns control.
```

### 3. Update Execution State

```json
{
  "status": "aborted",
  "last_activity": "<current-ISO-timestamp>",
  "abort_reason": "User requested abort"
}
```

### 4. Archive or Keep State File

If `--keep-state` flag is NOT present:

```
# Archive state file with timestamp
timestamp = format(now(), "YYYYMMDD-HHmmss")
archive_path = ".claude/ralph-task-executor.state.{timestamp}.json"

mv .claude/ralph-task-executor.state.json {archive_path}

Report: "State archived to {archive_path}"
```

If `--keep-state` flag IS present:

```
Report: "State file kept at .claude/ralph-task-executor.state.json"
Report: "Delete manually when no longer needed"
```

### 5. Report Final Summary

## Output

```
## Execution Aborted

**Aborted at:** {timestamp}
**Started at:** {started_at}
**Duration:** {duration}

### Final Status

| Metric | Count |
|--------|-------|
| Total Tasks | {total} |
| Completed | {completed} |
| Blocked | {blocked} |
| Not Started | {remaining} |

### Completion Summary

**Completion Rate:** {percentage}%

{If pending_completions exist:}
**Warning:** {N} tasks completed but not synced to task file.
These completions were lost. Re-run execution to redo them.

{List of pending_completions}

### State File

{If archived:}
State archived to: {archive_path}
To review: Read the archived state file

{If kept:}
State kept at: .claude/ralph-task-executor.state.json
To clean up: Delete this file manually

### Next Steps

To start fresh:
  /ralph-task-executor:execute {task_file}

To sync any completed work to task file:
  /spec-task-manager:complete TASK-XXX
```

## Error Handling

- **No execution state:** "No active execution found. Nothing to abort."
- **Cancel-ralph fails:** Log warning but continue with abort
- **Archive fails:** Keep state in place and warn user

## Example Usage

```bash
# Abort and archive state
/ralph-task-executor:abort

# Abort but keep state for debugging
/ralph-task-executor:abort --keep-state
```
