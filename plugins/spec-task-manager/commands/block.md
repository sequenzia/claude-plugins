---
description: Mark a task as blocked with a reason
argument-hint: <task-id> --reason "<reason>" [project-name]
allowed-tools: Read, Write, Glob
---

Mark a task as blocked and document the blocking reason.

## Process

1. **Parse arguments**
   - Extract task ID from arguments
   - Extract reason (text after --reason)
   - Extract optional project name

2. **Locate and read the task file**
   - If project name provided: Read `tasks/<project>.tasks.json`
   - If no project name: Find task file containing the specified task ID

3. **Validate**
   - Confirm task exists
   - Warn if task is already complete or obsolete

4. **Update the task**
   - Set status to "blocked"
   - Add blocking reason to `notes` field (append to existing notes)
   - Format: "[BLOCKED <timestamp>] <reason>"

5. **Update metadata**
   - Update `last_updated` timestamp
   - Increment version (patch bump)

6. **Write updated task file**

7. **Display confirmation**

Format output as:

```
## Task Blocked: TASK-XXX

**<title>** marked as blocked.

**Reason:** <reason>

### Impact Assessment
Tasks depending on this one:
- TASK-AAA: <title> (also now blocked)
- TASK-BBB: <title> (also now blocked)

### Resolution Needed
To unblock this task:
1. Address the blocking issue
2. Use `/spec-task-manager:complete TASK-XXX` when resolved

Or update the task with `/spec-task-manager:update` if requirements changed.
```

If no reason provided, prompt for one - blocking should always be documented.
