---
description: Synchronize pending completions to spec-task-manager task file
argument-hint: [--all | --task-id TASK-XXX]
allowed-tools: [Read, Write, Glob]
model: inherit
---

# Sync Completions

Synchronize completed tasks from execution state to the spec-task-manager task file. Used when running in manual sync mode (without `--auto-sync`).

## Arguments

- `--all`: Sync all pending completions (default behavior)
- `--task-id TASK-XXX`: Sync only a specific task

## Process

### 1. Load Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no execution state
- Check `pending_completions` array

### 2. Validate Pending Completions

If no pending completions and no specific task:
```
Report: "No pending completions to sync."
Report: "All completed tasks are already synced to task file."
```

### 3. Load Task File

Read the task file from `execution_state.task_file`.

### 4. Sync Completions

For each task to sync:

```
For task_id in tasks_to_sync:
  task = find_task(task_id, task_file)

  # Update task status
  task.status = "complete"

  # Add completion note with timestamp
  completion_note = "[COMPLETED via ralph-task-executor {timestamp}]"
  task.notes = (task.notes or "") + "\n" + completion_note

  # Update blocked_by arrays for dependent tasks
  for other_task in task_file.tasks:
    if task_id in other_task.blocked_by:
      other_task.blocked_by.remove(task_id)

  # Track synced
  synced_tasks.append(task_id)
```

### 5. Update Task File Metadata

```json
{
  "metadata": {
    "last_updated": "<current-ISO-timestamp>",
    "completion_percentage": "<recalculated>",
    "version": "<minor-bump>"
  }
}
```

### 6. Update Execution State

Remove synced tasks from pending_completions:

```
execution_state.pending_completions =
  execution_state.pending_completions.filter(t => !synced_tasks.includes(t))
execution_state.last_activity = now()
```

Save both files.

## Output

```
## Sync Complete

**Synced:** {count} task(s) to {task_file}

### Synced Tasks

| Task ID | Title | Status |
|---------|-------|--------|
| {TASK-ID} | {title} | ✓ Synced |
| {TASK-ID} | {title} | ✓ Synced |

### Updated Metrics

- **Completion:** {percentage}% ({completed}/{total})
- **Remaining:** {remaining} tasks

### Remaining Pending

{If more pending:}
{N} task(s) still pending sync:
- {TASK-ID}
- {TASK-ID}

{If none pending:}
All completions synced.

### Unblocked Tasks

The following tasks are now unblocked and ready to execute:
- {TASK-ID}: {title}
- {TASK-ID}: {title}
```

## Error Handling

- **No execution state:** "No execution state found. Nothing to sync."
- **No pending completions:** "No pending completions. Task file is up to date."
- **Task not found:** "Task {TASK-XXX} not found in task file. Skipping."
- **Task file read-only:** "Cannot write to task file. Check permissions."

## Example Usage

```bash
# Sync all pending completions
/ralph-task-executor:sync

# Sync a specific task
/ralph-task-executor:sync --task-id TASK-007

# Explicit all flag
/ralph-task-executor:sync --all
```
