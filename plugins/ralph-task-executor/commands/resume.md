---
description: Resume a paused execution loop
argument-hint: [--skip-current] [--task-id TASK-XXX]
allowed-tools: [Read, Write, Bash, TodoWrite]
allowed-paths: [".claude/ralph-task-executor.state.json"]
model: inherit
---

# Resume Execution

Resume a paused task execution loop.

## Arguments

- `--skip-current`: Mark the current task as blocked and move to the next available task
- `--task-id TASK-XXX`: Start from a specific task instead of the paused task

## Process

### 1. Load and Validate Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no execution to resume
- If status is not "paused": Report execution is not paused

### 2. Load Task File

Read the task file to get current task data.

### 3. Handle Skip Current (if requested)

If `--skip-current` flag is present:

```
current_task_id = execution_state.current_task

# Mark current task as blocked
execution_state.blocked.append(current_task_id)
execution_state.blocked_reasons[current_task_id] = {
  "reason": "Manually skipped via --skip-current",
  "blocked_at": now(),
  "iteration_count": execution_state.current_iteration
}

# Remove from in_progress
execution_state.in_progress.remove(current_task_id)

# Cascade to dependent tasks
cascade_blocked_status(current_task_id)

# Clear current task
execution_state.current_task = null
```

### 4. Handle Task ID Override (if specified)

If `--task-id TASK-XXX` is provided:

```
target_task = find_task(TASK-XXX, task_file)

# Validate task exists and is executable
if not target_task:
  Error: "Task {TASK-XXX} not found in task file"

if target_task.status == "complete":
  Error: "Task {TASK-XXX} is already complete"

if target_task.id in execution_state.blocked:
  Warning: "Task {TASK-XXX} was previously blocked. Retrying..."
  # Remove from blocked to allow retry
  execution_state.blocked.remove(target_task.id)

# Check dependencies
unmet_deps = get_unmet_dependencies(target_task)
if unmet_deps:
  Warning: "Task has unmet dependencies: {unmet_deps}"
  Warning: "Proceeding anyway - task may fail"

# Clear any current task
if execution_state.current_task:
  # Move back to not started (will be picked up later)
  execution_state.in_progress.remove(execution_state.current_task)

# Set target as current
execution_state.current_task = target_task.id
execution_state.in_progress = [target_task.id]
```

### 5. Select Next Task (if no current)

If no current task after processing:

```
next_tasks = select_executable_tasks(task_file, execution_state)

if not next_tasks:
  # All done or all blocked
  finalize_execution()
  return

execution_state.current_task = next_tasks[0].id
execution_state.in_progress = [next_tasks[0].id]
```

### 6. Update Execution State

```json
{
  "status": "running",
  "paused_at": null,
  "pause_reason": null,
  "task_start_time": "<current-ISO-timestamp>",
  "current_iteration": 0,
  "last_activity": "<current-ISO-timestamp>"
}
```

### 7. Build Prompt and Start Ralph-Loop

Build the task prompt for the current task and invoke ralph-loop:

```
prompt = build_task_prompt(current_task, task_file, execution_state)
completion_promise = "TASK-{ID}-COMPLETE"

/ralph-loop "{prompt}" --max-iterations {max} --completion-promise "{completion_promise}"
```

## Output

```
## Execution Resumed

**Resumed at:** {timestamp}
**Paused duration:** {duration}

### Resuming Task

**Task:** {TASK-ID}: {title}
**Priority:** {priority}
**Complexity:** {complexity}

{If skipped current:}
**Note:** Previous task {TASK-ID} was skipped and marked as blocked.

{If task-id override:}
**Note:** Starting from specified task {TASK-ID} instead of paused task.

### Progress So Far

- **Completed:** {completed_count} tasks
- **Blocked:** {blocked_count} tasks
- **Remaining:** {remaining_count} tasks

Execution continuing...
```

## Error Handling

- **No execution state:** "No execution found to resume. Run /ralph-task-executor:execute to start."
- **Not paused:** "Execution is {status}, not paused. Cannot resume."
- **Task not found:** "Task {TASK-XXX} not found in task file."
- **All tasks done:** "All tasks are complete or blocked. Nothing to resume."

## Example Usage

```bash
# Resume from where paused
/ralph-task-executor:resume

# Skip problematic task and continue
/ralph-task-executor:resume --skip-current

# Jump to specific task
/ralph-task-executor:resume --task-id TASK-015
```
