---
description: Show execution progress, metrics, and current state
argument-hint: [--verbose]
allowed-tools: [Read, Glob]
model: inherit
---

# Execution Status

Display the current execution progress, metrics, and state for the running task execution.

## Arguments

- `--verbose`: Show detailed information including task timings and blocked reasons

## Process

### 1. Load Execution State

Read `.claude/ralph-task-executor.state.json`:
- If not found: Report no active execution
- If found: Parse and validate state

### 2. Load Task File

Read the task file referenced in execution state to get task details.

### 3. Calculate Metrics

Compute current metrics:

```
total_tasks = task_file.metadata.total_tasks
completed_count = execution_state.completed.length
blocked_count = execution_state.blocked.length
in_progress_count = execution_state.in_progress.length
remaining_count = total_tasks - completed_count - blocked_count

completion_percentage = (completed_count / total_tasks) * 100

elapsed_seconds = now() - execution_state.started_at
avg_time_per_task = completed_count > 0
  ? elapsed_seconds / completed_count
  : 0
estimated_remaining = remaining_count * avg_time_per_task
```

### 4. Determine Current Phase

Find the execution phase of current/next tasks:

```
if execution_state.current_task:
  current_phase = find_task_phase(current_task)
else:
  next_tasks = get_executable_tasks()
  current_phase = next_tasks[0].execution_phase if next_tasks else "N/A"
```

### 5. Format Output

## Output

### Standard Output

```
## Execution Status: {status}

**Task File:** {task_file}
**Started:** {started_at}

### Progress

| Metric | Value |
|--------|-------|
| Total Tasks | {total} |
| Completed | {completed} ({percentage}%) |
| Blocked | {blocked} |
| In Progress | {in_progress} |
| Remaining | {remaining} |

### Current Activity

**Phase:** {current_phase}
**Current Task:** {TASK-ID}: {title} (iteration {N}/{max})
**Task Started:** {task_start_time}

### Timing

- **Elapsed:** {elapsed_formatted}
- **Avg per task:** {avg_formatted}
- **Est. remaining:** {remaining_formatted}

### Phase Progress

Phase {N}: {task1} ✓, {task2} ✓, {task3} ▶, {task4} ○

Legend: ✓ Complete | ▶ In Progress | ○ Pending | ✗ Blocked

### Blocked Tasks

{If blocked tasks exist:}
- {TASK-ID}: {reason}
- {TASK-ID}: Depends on {blocked_dep}

{If no blocked tasks:}
No blocked tasks.
```

### Verbose Output (--verbose)

Additional sections:

```
### Completed Task Details

| Task | Iterations | Duration |
|------|------------|----------|
| {TASK-ID} | {N} | {duration} |
| {TASK-ID} | {N} | {duration} |

### Blocked Task Details

**{TASK-ID}: {title}**
- Reason: {reason}
- Blocked at: {timestamp}
- Iterations attempted: {N}
- Details: {excerpt}

### Configuration

- Parallel Mode: {Yes|No}
- Auto-sync: {Yes|No}
- Max Iterations: {N}

### Pending Sync

{If manual mode with pending completions:}
The following tasks are complete but not synced to task file:
- {TASK-ID}
- {TASK-ID}

Run `/ralph-task-executor:sync` to update the task file.
```

## Error Handling

- **No execution state:** Report "No active execution found. Run /ralph-task-executor:execute to start."
- **Task file missing:** Report "Task file not found: {path}. Execution state may be stale."
- **Corrupted state:** Report parsing error and suggest running /abort --keep-state

## Example Usage

```bash
# Quick status check
/ralph-task-executor:exec-status

# Detailed status with timings
/ralph-task-executor:exec-status --verbose
```
