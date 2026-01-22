---
description: Recommend next tasks to work on based on priority and dependencies
argument-hint: [count] [project-name]
allowed-tools: Read, Glob
---

Suggest the best tasks to work on next based on priority, complexity, and dependency analysis.

**Arguments:**
- `count` (optional): Number of recommendations (default: 5)
- `project-name` (optional): Project name if multiple task files exist

## Process

1. **Locate task file**
   - Search for `tasks/*.tasks.json` files
   - Use specified project or prompt if multiple exist

2. **Filter eligible tasks**
   - Status is "not_started" or "in_progress"
   - `blocked_by` array is empty (no incomplete dependencies)

3. **Score and rank tasks**

   **Scoring algorithm:**
   ```
   score = (priority_weight * 100) + (blocking_weight * 50) + complexity_bonus

   Priority weights:
   - critical: 4
   - high: 3
   - medium: 2
   - low: 1

   Blocking weight:
   - Number of tasks this task blocks (unblocks others faster)

   Complexity bonus (quick wins):
   - XS: +15
   - S: +10
   - M: +5
   - L: +0
   - XL: -5
   ```

4. **Generate recommendations**

## Output Format

```
# Next Task Recommendations

**Project:** <project-name>
**Available tasks:** X (of Y total)

## Top Recommendations

### 1. TASK-XXX: <title>
**Score:** 450 | **Priority:** critical | **Complexity:** S

<brief description>

**Why recommended:**
- Critical priority (highest urgency)
- Blocks 3 other tasks
- Small complexity (quick win)

**Acceptance criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

---

### 2. TASK-YYY: <title>
**Score:** 380 | **Priority:** high | **Complexity:** M

<brief description>

**Why recommended:**
- High priority
- Blocks 2 other tasks
- Unlocks Phase 2 work

---

### 3. TASK-ZZZ: <title>
**Score:** 320 | **Priority:** high | **Complexity:** XS

<brief description>

**Why recommended:**
- High priority
- Extra small complexity (very quick win)

---

(continue for requested count)

## Summary

| Rank | Task | Priority | Complexity | Blocks | Score |
|------|------|----------|------------|--------|-------|
| 1 | TASK-XXX | critical | S | 3 | 450 |
| 2 | TASK-YYY | high | M | 2 | 380 |
| 3 | TASK-ZZZ | high | XS | 0 | 320 |

## Quick Actions

- View task details: `/mission-control:show TASK-XXX`
- Mark complete when done: `/mission-control:complete TASK-XXX`
```

## Edge Cases

- **No available tasks:** All tasks are either blocked or complete
- **All tasks complete:** Project finished! Congratulate user
- **All remaining blocked:** Show what's blocking progress and recommend completing blockers
- **Only low priority left:** Note that remaining work is lower priority
