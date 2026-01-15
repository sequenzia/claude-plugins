---
description: Re-analyze specification and update existing task list
argument-hint: <spec-document> [project-name]
allowed-tools: Read, Write, Glob
---

Re-analyze the specification document and update the existing task list with changes.

**Input document:** @$1

## Process

1. **Locate existing task list**
   - If project name provided ($2): Read `tasks/$2.tasks.json`
   - Otherwise: Derive project name from spec filename

2. **Read current task list**
   - Load existing tasks with their current statuses
   - Note which tasks are complete, in_progress, or blocked

3. **Re-analyze the specification**
   - Parse the updated specification document
   - Extract all current requirements

4. **Compare and reconcile**

   For each requirement in the updated spec:
   - **Unchanged**: Keep existing task, preserve status
   - **Modified**: Update task description/criteria, preserve status if in_progress
   - **New**: Create new task with stable ID

   For existing tasks not in updated spec:
   - Mark as "obsolete" (don't delete - preserve history)

5. **Recalculate dependencies**
   - Update dependency graph for any structural changes
   - Recalculate blocked_by for all non-complete tasks
   - Rebuild execution phases

6. **Update metadata**
   - Increment version (minor bump for structural changes)
   - Update last_updated timestamp
   - Recalculate total_tasks and completion_percentage

7. **Write updated task file**
   - Backup previous version (rename to .tasks.json.bak)
   - Write new task list

8. **Display change summary**

Format output as:

```
## Task List Updated: <project-name>

**Version:** <old> -> <new>

### Changes Summary
- **New tasks:** X
- **Modified tasks:** Y
- **Obsolete tasks:** Z
- **Unchanged tasks:** W

### New Tasks Added
- TASK-XXX: <title> (priority, complexity)
- TASK-YYY: <title> (priority, complexity)

### Tasks Marked Obsolete
- TASK-ZZZ: <title> (was: status)

### Modified Tasks
- TASK-AAA: <change description>

### Progress Impact
- Completion: X% -> Y%
- Total tasks: A -> B

### Next Actions
Run `/spec-task-manager:next` to see recommended tasks.
```

If this is a significant restructuring, warn about potential workflow disruption.
