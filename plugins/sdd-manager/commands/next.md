---
description: Suggest the next best tasks to work on
argument-hint: [count] [project-name]
allowed-tools: Read, Glob
---

Analyze the current task list and recommend the best next tasks to work on.

## Process

1. **Parse arguments**
   - `$1` = Number of recommendations (default: 3)
   - `$2` = Project name (optional)

2. **Locate and read the task file**
   - If project name provided: Read `tasks/$2.tasks.json`
   - If no project name: Find the most recently modified `.tasks.json`

3. **Identify candidate tasks**
   - Status is "not_started"
   - No incomplete hard dependencies (blocked_by is empty)
   - Not obsolete

4. **Score and rank candidates**
   Scoring factors:
   - Priority weight: critical=4, high=3, medium=2, low=1
   - Dependency depth: +1 for each task this unblocks
   - Complexity bonus: XS=0.5, S=0.3 (quick wins tiebreaker)

5. **Select top N recommendations**

6. **Display recommendations**

Format output as:

```
## Recommended Next Tasks

Based on priority, dependencies, and quick-win potential:

### 1. TASK-XXX: <title>
- **Priority:** critical
- **Complexity:** M
- **Why:** Unblocks 3 other tasks
- **Acceptance Criteria:**
  - <criterion 1>
  - <criterion 2>

### 2. TASK-YYY: <title>
- **Priority:** high
- **Complexity:** S
- **Why:** Quick win, unblocks 2 tasks
- **Acceptance Criteria:**
  - <criterion 1>

### 3. TASK-ZZZ: <title>
- **Priority:** high
- **Complexity:** XS
- **Why:** Very quick win
- **Acceptance Criteria:**
  - <criterion 1>

---

**Current Progress:** X% complete (Y of Z tasks)

To start a task, begin working on it. Mark complete with:
`/spec-task-manager:complete TASK-XXX`
```

If no tasks are available (all blocked or complete), explain the situation.
