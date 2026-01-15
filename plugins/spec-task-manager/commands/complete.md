---
description: Mark a task as complete and show next recommended tasks
argument-hint: <task-id> [project-name]
allowed-tools: Read, Write, Glob
---

Mark a task as complete, update dependencies, and suggest next tasks.

## Process

1. **Parse arguments**
   - `$1` = Task ID (required, e.g., TASK-001)
   - `$2` = Project name (optional)

2. **Locate and read the task file**
   - If project name provided: Read `tasks/$2.tasks.json`
   - If no project name: Find task file containing the specified task ID

3. **Validate the task**
   - Confirm task exists
   - Check current status (warn if already complete or obsolete)

4. **Update the task**
   - Set status to "complete"
   - Record completion (update last_updated in metadata)

5. **Recalculate dependencies**
   - For all tasks that have this task in their `dependencies.hard`:
     - Remove this task from their `blocked_by` array
   - Recalculate which tasks are now unblocked

6. **Update metrics**
   - Recalculate `completion_percentage`
   - Increment metadata version (patch bump)
   - Update `last_updated` timestamp

7. **Write updated task file**

8. **Display results**

Format output as:

```
## Task Completed: TASK-XXX

**<title>** marked as complete.

### Progress Update
- Completion: X% -> Y% (+Z%)
- Tasks remaining: N

### Newly Unblocked
These tasks can now be started:
- TASK-AAA: <title> (priority, complexity)
- TASK-BBB: <title> (priority, complexity)

### Recommended Next Tasks
Based on priority and complexity:

1. **TASK-CCC**: <title>
   - Priority: high
   - Complexity: S
   - No blockers

2. **TASK-DDD**: <title>
   - Priority: medium
   - Complexity: XS
   - No blockers
```

If completing this task unblocks critical-priority tasks, highlight them prominently.
