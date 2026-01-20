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

3. **Check for context groups**
   - If `context_groups` array exists, identify the active group
   - Active group has `status: "active"`
   - If no active group, use first `pending` group

4. **Identify candidate tasks**
   - Status is "not_started"
   - No incomplete hard dependencies (blocked_by is empty)
   - Not obsolete
   - **If context groups exist:** Prefer tasks in the active context group

5. **Score and rank candidates**
   Scoring factors:
   - **Context group membership:** +10 if in active context group
   - Priority weight: critical=4, high=3, medium=2, low=1
   - Dependency depth: +1 for each task this unblocks
   - Complexity bonus: XS=0.5, S=0.3 (quick wins tiebreaker)

6. **Select top N recommendations**

7. **Display recommendations**

Format output as:

```
## Recommended Next Tasks

Based on priority, dependencies, and quick-win potential:

### Context Group Status
**Active Group:** CG-001 (3 of 5 tasks complete)
**Effective Limit:** 80,000 tokens

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
`/sdd-manager:complete TASK-XXX`
```

### Context Switch Indicator

When recommending a task from a different context group than the active one:

```
### Context Switch Required

The best available task is in a different context group:

**TASK-010:** Implement caching layer
- **Context Group:** CG-002 (not active)
- **Active Group:** CG-001 (2 tasks remaining)

**Recommendation:** Complete remaining tasks in CG-001 first to maintain context efficiency.

Remaining in CG-001:
- TASK-004: Create auth middleware (blocked by TASK-003)
- TASK-005: Add session handling (not_started)

If you must switch groups, use `/sdd-manager:next-group` to properly transition.
```

If no tasks are available (all blocked or complete), explain the situation.

If context groups exist but active group is complete:
```
### Context Group Complete!

All tasks in CG-001 are complete.

**Next Steps:**
1. Save any important context/outputs
2. Run `/sdd-manager:next-group` to start CG-002
3. Reset your context window for fresh capacity
```
