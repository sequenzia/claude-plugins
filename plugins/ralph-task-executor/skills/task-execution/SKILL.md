---
name: task-execution
description: Orchestrate automated execution of spec-task-manager tasks via ralph-loop
---

# Task Execution Skill

This skill provides the orchestration logic for executing spec-task-manager tasks using ralph-loop for iterative completion.

## Overview

The task execution workflow bridges two plugins:
- **spec-task-manager**: Provides structured task lists with dependencies
- **ralph-loop**: Provides iterative execution via the Ralph Wiggum technique

## Core Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                     Task Execution Flow                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ spec-task-   │───▶│ ralph-task-  │───▶│ ralph-loop   │      │
│  │ manager      │    │ executor     │    │              │      │
│  │              │    │              │    │              │      │
│  │ .tasks.json  │    │ state.json   │    │ local.md     │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│        │                    │                   │               │
│        │                    │                   │               │
│        ▼                    ▼                   ▼               │
│  Task definitions    Execution state      Loop iterations      │
│  Dependencies        Progress tracking    Completion detection │
│  Acceptance criteria Failure handling     Prompt delivery      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Task Selection Algorithm

### Priority Ordering

Tasks are selected based on multiple factors:

1. **Dependency Satisfaction**: Only tasks with all hard dependencies complete
2. **Priority Level**: critical > high > medium > low
3. **Execution Phase**: Earlier phases first
4. **Complexity**: Simpler tasks first (XS > S > M > L > XL)

### Selection Logic

```
function selectNextTasks(taskFile, executionState, parallelMode):
    # Get all tasks
    allTasks = taskFile.tasks

    # Filter to executable tasks
    executable = allTasks.filter(task =>
        task.status == "not_started" AND
        task.id NOT IN executionState.completed AND
        task.id NOT IN executionState.blocked AND
        task.id NOT IN executionState.in_progress AND
        allHardDependenciesMet(task, executionState)
    )

    # Sort by priority
    executable.sort((a, b) =>
        priorityWeight(b.priority) - priorityWeight(a.priority) OR
        (a.execution_phase || 999) - (b.execution_phase || 999) OR
        complexityWeight(a.complexity) - complexityWeight(b.complexity)
    )

    # Return based on mode
    if parallelMode:
        topPhase = executable[0].execution_phase
        return executable.filter(t => t.execution_phase == topPhase)
    else:
        return [executable[0]]

function priorityWeight(priority):
    return { "critical": 4, "high": 3, "medium": 2, "low": 1 }[priority] || 0

function complexityWeight(complexity):
    return { "XS": 1, "S": 2, "M": 3, "L": 4, "XL": 5 }[complexity] || 3
```

## Prompt Generation

### Template Variables

| Variable | Source | Required |
|----------|--------|----------|
| TASK_ID | task.id | Yes |
| TITLE | task.title | Yes |
| DESCRIPTION | task.description | Yes |
| ACCEPTANCE_CRITERIA_LIST | task.testing.acceptance_criteria | Yes |
| TEST_SCENARIOS | task.testing.test_scenarios | No |
| EDGE_CASES | task.testing.edge_cases | No |
| DEPENDENCY_CONTEXT | Built from completed deps | No |
| SOURCE_REQUIREMENTS | task.source_requirements | No |
| NOTES | task.notes | No |
| COMPLETION_PROMISE | Generated: TASK-{ID}-COMPLETE | Yes |

### Dependency Context Building

For each hard dependency that is complete:

```
### {DEP_ID}: {DEP_TITLE}
- **Status:** Complete
- **Implementation Notes:** {notes from task or execution state}
- **Files Modified:** {artifacts from execution state}
```

This provides the executing task with context about work already done.

## State Management

### Execution State Transitions

```
Initial State
     │
     ▼
  running ◀──────────────────┐
     │                       │
     ├───▶ paused ──────────▶│ (resume)
     │                       │
     ├───▶ completed         │
     │                       │
     └───▶ aborted           │
```

### State File Location

- Primary: `.claude/ralph-task-executor.state.json`
- Archive: `.claude/ralph-task-executor.state.{timestamp}.json`

## Failure Handling

### Timeout Detection

A task times out when ralph-loop exits without the completion promise:

```
function onRalphLoopExit(taskId, finalOutput, executionState):
    expectedPromise = `TASK-${taskId}-COMPLETE`

    if finalOutput.includes(`<promise>${expectedPromise}</promise>`):
        return handleSuccess(taskId, executionState)
    else:
        return handleTimeout(taskId, finalOutput, executionState)
```

### Blocked Task Cascade

When a task is blocked, dependent tasks become transitively blocked:

```
function cascadeBlocked(blockedTaskId, taskFile, executionState):
    for task in taskFile.tasks:
        if blockedTaskId in task.dependencies.hard:
            if task.id NOT IN executionState.blocked:
                executionState.blocked.push(task.id)
                executionState.blocked_reasons[task.id] = {
                    reason: `Dependency ${blockedTaskId} is blocked`,
                    blocked_at: now()
                }
```

## Synchronization Modes

### Auto-Sync Mode

When enabled (`--auto-sync`):

1. On task completion, immediately update `.tasks.json`:
   - Set task.status = "complete"
   - Update blocked_by arrays
   - Recalculate completion_percentage
   - Bump version

2. Benefits:
   - Task file always reflects true state
   - Can use spec-task-manager commands to query

3. Drawbacks:
   - More file writes
   - Potential conflicts if editing task file externally

### Manual Sync Mode (Default)

When disabled:

1. Track completions in `pending_completions` array
2. User runs `/sync` to batch update task file
3. Benefits:
   - Fewer writes
   - Review before committing changes
4. Drawbacks:
   - Task file may be out of sync
   - Must remember to sync

## Parallel Execution

### Batch Selection

In parallel mode, select all tasks in the same execution phase:

```
Phase 1: TASK-001, TASK-002, TASK-003 (all independent)
Phase 2: TASK-004, TASK-005 (depend on Phase 1)
Phase 3: TASK-006 (depends on Phase 2)
```

### Coordination

- Track all tasks in `parallel_batch`
- Count pending in `parallel_pending`
- Wait for batch completion before next phase
- Handle individual failures without blocking siblings

### Resource Conflicts

Check for resource dependencies within parallel batch:

```
function detectResourceConflicts(tasks):
    conflicts = []
    for i, taskA in enumerate(tasks):
        for taskB in tasks[i+1:]:
            if taskA.id in taskB.dependencies.resource OR
               taskB.id in taskA.dependencies.resource:
                conflicts.push([taskA.id, taskB.id])
    return conflicts
```

If conflicts detected, warn user or fall back to sequential for conflicting tasks.

## Metrics Tracking

### Per-Task Metrics

```json
{
  "task_timings": {
    "TASK-001": {
      "started": "2024-01-15T10:30:00Z",
      "completed": "2024-01-15T10:35:00Z",
      "iterations": 3
    }
  }
}
```

### Aggregate Metrics

```json
{
  "metrics": {
    "total_iterations": 45,
    "avg_iterations_per_task": 5.6,
    "total_time_seconds": 2700,
    "avg_time_per_task_seconds": 337
  }
}
```

### Progress Estimation

```
function estimateRemaining(executionState, taskFile):
    completed = executionState.completed.length
    remaining = taskFile.tasks.length - completed - executionState.blocked.length

    if completed == 0:
        return "Unknown"

    avgTime = executionState.metrics.total_time_seconds / completed
    return remaining * avgTime
```

## Integration Commands

### Starting Execution

```bash
/ralph-task-executor:execute tasks/feature.tasks.json [--parallel] [--auto-sync] [--max-iterations N]
```

### Monitoring

```bash
/ralph-task-executor:exec-status [--verbose]
```

### Control

```bash
/ralph-task-executor:pause [reason]
/ralph-task-executor:resume [--skip-current] [--task-id TASK-XXX]
/ralph-task-executor:abort [--keep-state]
```

### Recovery

```bash
/ralph-task-executor:retry TASK-XXX [--max-iterations N] [--additional-context "..."]
/ralph-task-executor:sync [--all | --task-id TASK-XXX]
```

## References

- [Task Schema](references/task-schema.json) - via spec-task-manager
- [Execution State Schema](references/execution-state-schema.json)
- [Prompt Templates](references/prompt-templates.md)
