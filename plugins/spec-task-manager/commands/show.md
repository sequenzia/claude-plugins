---
description: Display detailed information for a specific task
argument-hint: <task-id> [project-name]
allowed-tools: Read, Glob
---

Show detailed information for a specific task.

## Process

1. **Parse arguments**
   - `$1` = Task ID (required, e.g., TASK-001)
   - `$2` = Project name (optional)

2. **Locate the task file**
   - If project name provided: Read `tasks/$2.tasks.json`
   - If no project name: Find task file containing the specified task ID

3. **Find the task**
   - Search for task with matching ID
   - If not found, list available task IDs

4. **Display task details**

Format output as:

```
## TASK-XXX: <title>

**Status:** <status>
**Priority:** <priority>
**Complexity:** <complexity>

### Description
<full description>

### Dependencies
**Hard (must complete first):**
- TASK-YYY: <title> [status]
- TASK-ZZZ: <title> [status]

**Soft (beneficial if complete):**
- TASK-AAA: <title> [status]

### Blocks
These tasks are waiting on this one:
- TASK-BBB: <title>

### Testing Criteria

**Acceptance Criteria:**
1. <criterion 1>
2. <criterion 2>

**Test Scenarios:**
1. <scenario 1>
2. <scenario 2>

**Edge Cases:**
1. <edge case 1>

### Source Requirements
- <reference to spec section>

### Notes
<any additional notes>
```

If task has incomplete hard dependencies, prominently display what's blocking it.
