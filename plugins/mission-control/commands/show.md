---
description: Display detailed information for a specific task
argument-hint: <task-id> [project-name]
allowed-tools: Read, Glob
---

Display comprehensive details for a specific task.

**Arguments:**
- `task-id` (required): The task ID to display (e.g., TASK-001)
- `project-name` (optional): Project name to narrow search if multiple task files exist

## Process

1. **Locate the task file**
   - Search for `tasks/*.tasks.json` files
   - If `project-name` provided, look for `tasks/<project-name>.tasks.json`
   - If multiple task files exist and no project specified, list them and ask user to specify

2. **Find the task**
   - Parse the JSON task file
   - Search for the task by ID
   - If not found, report error and suggest similar task IDs

3. **Display task details**

## Output Format

```
## TASK-XXX: <title>

**Status:** <status>
**Priority:** <priority>
**Complexity:** <complexity>

### Description
<full description>

### Dependencies

**Depends on:**
- TASK-YYY: <title> [<status>]
- TASK-ZZZ: <title> [<status>]

**Blocked by (incomplete):**
- TASK-YYY: <title>

**Blocks:**
- TASK-AAA: <title>
- TASK-BBB: <title>

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Source Requirements
- Section 5.1: Feature Name
- US-001: User story reference

### Notes
<any additional notes>

---

**Ready to start:** Yes/No
**Execution phase:** <phase number>
```

## Edge Cases

- If task is blocked, highlight the blocking tasks prominently
- If task is complete, show checkmarks on acceptance criteria
- If task has no dependencies, note "No dependencies"
- If task blocks nothing, note "Does not block other tasks"
