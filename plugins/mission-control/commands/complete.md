---
description: Mark a task as complete and show newly unblocked tasks
argument-hint: <task-id> [project-name]
allowed-tools: Read, Write, Glob
---

Mark a task as complete and update all dependent task relationships.

**Arguments:**
- `task-id` (required): The task ID to mark complete (e.g., TASK-001)
- `project-name` (optional): Project name if multiple task files exist

## Process

1. **Locate and validate**
   - Find the task file (`tasks/*.tasks.json` or `tasks/<project-name>.tasks.json`)
   - Verify the task exists
   - Check current status (warn if already complete)

2. **Update task status**
   - Set `status` to "complete"
   - Update `metadata.last_updated` timestamp
   - Recalculate `metadata.completion_percentage`

3. **Update dependent tasks**
   - For each task that has this task in `blocked_by`:
     - Remove this task from their `blocked_by` array
     - If `blocked_by` becomes empty and status was "blocked", change to "not_started"
   - Track which tasks became unblocked

4. **Write updated file**
   - Save the modified JSON to the task file
   - Preserve formatting

5. **Display results**

## Output Format

```
## Task Completed

**TASK-XXX:** <title>

Status: not_started -> complete

### Progress Update

- Completion: 45% -> 50% (10/20 tasks)
- Tasks unblocked: 2

### Newly Unblocked Tasks

The following tasks can now be started:

1. **TASK-AAA:** <title>
   - Priority: high
   - Complexity: M
   - Was waiting on: TASK-XXX

2. **TASK-BBB:** <title>
   - Priority: medium
   - Complexity: S
   - Was waiting on: TASK-XXX, TASK-YYY (TASK-YYY already complete)

### Recommended Next

Based on priority and dependencies:

1. **TASK-AAA** - High priority, medium complexity
2. **TASK-CCC** - High priority, small complexity

Run `/mission-control:next` for full recommendations.
```

## Edge Cases

- **Task already complete:** Warn but don't error
- **Task is blocked:** Error - cannot complete a blocked task without completing blockers first
- **Task in progress:** Allow completion (normal flow)
- **No tasks unblocked:** Note that no new tasks were unblocked
- **All tasks complete:** Congratulate user on completing the project!

## Validation

Before marking complete, consider asking:
- If task has acceptance criteria, remind user to verify them
- If task blocks critical path tasks, highlight the impact
