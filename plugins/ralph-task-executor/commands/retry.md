---
description: Retry a blocked task with increased iterations or modified prompt
argument-hint: <task-id> [--max-iterations N] [--additional-context "..."]
allowed-tools: [Read, Write, Bash, TodoWrite]
model: inherit
---

# Retry Blocked Task

Retry a task that was previously blocked (failed to complete within max iterations). Allows increasing iterations or providing additional context to help the task succeed.

## Arguments

- `$1` (required): Task ID to retry (e.g., TASK-007)
- `--max-iterations N`: Override max iterations for this retry (default: use config value)
- `--additional-context "..."`: Additional hints or context to append to the prompt

## Process

### 1. Load Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no execution state
- Validate execution is paused or running

### 2. Validate Task

```
task_id = $1 (required)

# Check task exists
task = find_task(task_id, task_file)
if not task:
  Error: "Task {task_id} not found in task file"

# Check task was blocked
if task_id not in execution_state.blocked:
  Warning: "Task {task_id} is not blocked"

  if task.status == "complete":
    Error: "Task is already complete. Nothing to retry."

  if task.status == "not_started":
    Info: "Task hasn't been attempted yet. Use /resume --task-id instead."
```

### 3. Check Dependencies

Verify dependencies are still met (they may have changed):

```
unmet_hard_deps = []
for dep_id in task.dependencies.hard:
  dep_task = find_task(dep_id, task_file)
  if dep_task.status != "complete":
    unmet_hard_deps.append(dep_id)

if unmet_hard_deps:
  Warning: "Task has unmet hard dependencies: {unmet_hard_deps}"
  Warning: "Retry may fail due to missing prerequisite work"
```

### 4. Prepare Retry

Remove task from blocked list:

```
execution_state.blocked.remove(task_id)
del execution_state.blocked_reasons[task_id]

# Also unblock transitively blocked tasks
for other_id in execution_state.blocked:
  reason = execution_state.blocked_reasons.get(other_id)
  if reason and f"Depends on {task_id}" in reason.get("reason", ""):
    # Keep them blocked until this task succeeds
    pass
```

### 5. Build Enhanced Prompt

Build the task prompt with enhancements:

```
base_prompt = build_task_prompt(task, task_file, execution_state)

# Add retry context
retry_context = """
## Retry Information

This task was previously attempted but did not complete.

**Previous attempt:**
- Iterations: {previous_iteration_count}
- Reason: {previous_reason}

Please review what may have gone wrong and try a different approach if needed.
"""

# Add additional context if provided
if additional_context:
  retry_context += f"""
## Additional Guidance

{additional_context}
"""

# Combine
enhanced_prompt = base_prompt + "\n\n" + retry_context
```

### 6. Update Execution State

```json
{
  "current_task": "{task_id}",
  "current_iteration": 0,
  "task_start_time": "<current-ISO-timestamp>",
  "in_progress": ["{task_id}"],
  "last_activity": "<current-ISO-timestamp>"
}
```

### 7. Start Ralph-Loop

```
max_iters = --max-iterations value or execution_state.config.max_iterations
completion_promise = "TASK-{task_id}-COMPLETE"

/ralph-loop "{enhanced_prompt}" --max-iterations {max_iters} --completion-promise "{completion_promise}"
```

## Output

```
## Retrying Task

**Task:** {TASK-ID}: {title}
**Previous Attempts:** {count}
**Previous Reason:** {reason}

### Retry Configuration

- **Max Iterations:** {N} {(increased from {old})}
- **Additional Context:** {Yes|No}

### Previous Attempt Details

{excerpt from blocked_reasons.details}

### Dependencies

{If all met:}
All hard dependencies are satisfied.

{If unmet:}
**Warning:** The following dependencies are not complete:
- {DEP-ID}: {status}

### Starting Retry

Prompt enhanced with retry context.
Execution starting...

Use `/ralph-task-executor:exec-status` to monitor progress.
```

## Error Handling

- **No execution state:** "No execution state found. Run /execute first."
- **Task not found:** "Task {TASK-ID} not found in task file."
- **Task not blocked:** "Task {TASK-ID} is not blocked. Use appropriate command."
- **Already complete:** "Task {TASK-ID} is already complete."

## Example Usage

```bash
# Basic retry with same settings
/ralph-task-executor:retry TASK-007

# Retry with more iterations
/ralph-task-executor:retry TASK-007 --max-iterations 25

# Retry with additional context
/ralph-task-executor:retry TASK-007 --additional-context "The API endpoint is /v2/users not /v1/users"

# Retry with both
/ralph-task-executor:retry TASK-007 --max-iterations 20 --additional-context "Use the new auth token format"
```
