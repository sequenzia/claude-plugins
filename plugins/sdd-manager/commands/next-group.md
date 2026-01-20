---
description: Get the next context group ready for execution
argument-hint: [project-name]
allowed-tools: Read, Write, Glob
---

Get the next context group that should be executed by an AI coding agent. This command helps with context window management by identifying which group to work on next.

## Process

1. **Parse arguments**
   - `$1` = Project name (optional)

2. **Locate and read the task file**
   - If project name provided: Read `tasks/$1.tasks.json`
   - If no project name: Find most recently modified `.tasks.json`

3. **Verify context groups exist**
   - Check for `context_groups` array in task file
   - If not found, suggest running `/sdd-manager:context-groups` first

4. **Find active or next pending group**
   - First, look for a group with `status: "active"` (already started)
   - If none active, find first group with `status: "pending"`
   - Skip groups with `status: "completed"`

5. **Check if current group is complete**
   - If active group exists, verify all tasks are complete
   - If all complete, mark group as `completed` and move to next pending

6. **Mark next group as active**
   - Update the group's `status` to `"active"`
   - Save the updated task file

7. **Calculate group progress**
   - Count completed tasks in this group
   - Calculate percentage complete
   - Identify remaining tasks

8. **Display group information**

Format output as:

```
## Next Context Group: CG-002

**Status:** Active
**Estimated Tokens:** 68,500 / 80,000 available

### Progress
- Tasks: 1 of 4 complete (25%)
- Phases Covered: 2, 3

### Tasks in This Group

| Order | Task | Status | Priority | Complexity | Est. Tokens |
|-------|------|--------|----------|------------|-------------|
| 1 | TASK-005: Setup auth module | complete | high | M | 4,200 |
| 2 | TASK-006: Implement login flow | not_started | high | L | 10,200 |
| 3 | TASK-007: Add session handling | not_started | medium | M | 4,200 |
| 4 | TASK-008: Create logout endpoint | not_started | medium | S | 1,700 |

### Dependencies Within Group
- TASK-006 depends on TASK-005 (complete)
- TASK-007 depends on TASK-006
- TASK-008 depends on TASK-005 (complete)

### Ready to Start
The following tasks have all dependencies satisfied:
- **TASK-006:** Implement login flow (high priority, L complexity)
- **TASK-008:** Create logout endpoint (medium priority, S complexity)

---

**Recommended:** Start with TASK-006 (high priority, unblocks TASK-007)

**Context Handoff Notes:**
Previous group (CG-001) completed:
- Auth configuration (TASK-004)
- Database schema (TASK-003)

These outputs are available for reference in this group.

---

When all tasks in this group are complete, run `/sdd-manager:next-group` to move to the next context group.
```

## Edge Cases

### No Context Groups
```
## No Context Groups Found

Context groups have not been generated yet.

Run `/sdd-manager:context-groups [project-name]` to create context groups from your task list.
```

### All Groups Complete
```
## All Context Groups Complete!

**Summary:**
- Total Groups: 3
- Total Tasks Completed: 12

All tasks from the specification have been completed.
Use `/sdd-manager:status` for a full completion report.
```

### Group Has Oversized Warning
```
## Next Context Group: CG-003

**Warning:** This group contains an oversized task that exceeds the token limit.

**TASK-015:** Complex integration module
- Complexity: XL
- Estimated Tokens: 25,200

This task may require breaking into smaller subtasks or extending the context window.
Consider running `/sdd-manager:update TASK-015 --split` to decompose this task.
```

### Context Handoff Required
```
## Next Context Group: CG-002

**Context Handoff Required**

This group continues work split from CG-001 due to dependency chain length.

**Handoff Information:**
- Split from: CG-001
- Reason: Dependency chain exceeded token limit
- Required context from previous group:
  - TASK-003: Database schema definitions
  - TASK-004: API endpoint signatures

Ensure these outputs are available before starting this group.
```

## Workflow Integration

This command is designed for the following workflow:

1. **Initial Setup**
   - `/sdd-manager:analyze` - Generate tasks from spec
   - `/sdd-manager:context-groups` - Organize into context groups

2. **Execution Loop** (per coding agent session)
   - `/sdd-manager:next-group` - Get current group to work on
   - Work through tasks in the group
   - Mark tasks complete with `/sdd-manager:complete TASK-XXX`
   - When group complete, agent resets context

3. **New Agent Session**
   - `/sdd-manager:next-group` - Gets next pending group
   - Fresh context, continues from where previous session ended
