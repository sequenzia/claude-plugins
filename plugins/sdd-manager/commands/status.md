---
description: Show task list summary and completion metrics
argument-hint: [project-name]
allowed-tools: Read, Glob
---

Display the current status of the task list.

## Process

1. **Locate the task file**
   - If project name provided: Read `tasks/$1.tasks.json`
   - If no argument: Find the most recently modified `.tasks.json` in `tasks/`

2. **Calculate metrics**
   - Total tasks
   - Tasks by status (not_started, in_progress, blocked, complete, obsolete)
   - Completion percentage
   - Tasks by priority breakdown
   - Tasks by complexity breakdown

3. **Identify actionable tasks**
   - Tasks ready to start (not_started with no blockers)
   - Currently blocked tasks and what's blocking them
   - In-progress tasks

4. **Display summary**

Format the output as:

```
## Task Status: <project-name>

**Overview**
- Source: <source_document>
- Generated: <generated_at>
- Last Updated: <last_updated>
- Version: <version>

**Progress**
- Total Tasks: X
- Completed: Y (Z%)
- In Progress: N
- Blocked: M
- Not Started: P

**By Priority**
- Critical: X
- High: Y
- Medium: Z
- Low: W

**Ready to Start**
- TASK-XXX: <title> (priority, complexity)
- TASK-YYY: <title> (priority, complexity)

**Currently Blocked**
- TASK-ZZZ: Blocked by TASK-AAA, TASK-BBB
```

If no task file found, explain how to create one using `/spec-task-manager:analyze`.
