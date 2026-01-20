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

3. **Calculate context group metrics (if groups exist)**
   - Total context groups
   - Groups completed vs pending
   - Active context group and its progress
   - Estimated tokens used vs available

5. **Identify actionable tasks**
   - Tasks ready to start (not_started with no blockers)
   - Currently blocked tasks and what's blocking them
   - In-progress tasks

6. **Display summary**

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

**Context Groups** (if configured)
| Group | Status | Tasks | Progress | Est. Tokens |
|-------|--------|-------|----------|-------------|
| CG-001 | completed | 5 | 5/5 (100%) | 72,000 |
| CG-002 | active | 4 | 1/4 (25%) | 68,500 |
| CG-003 | pending | 3 | 0/3 (0%) | 45,200 |

**Active Group:** CG-002
- Effective Limit: 80,000 tokens
- Remaining in group: TASK-006, TASK-007, TASK-008

**Ready to Start**
- TASK-XXX: <title> (priority, complexity)
- TASK-YYY: <title> (priority, complexity)

**Currently Blocked**
- TASK-ZZZ: Blocked by TASK-AAA, TASK-BBB
```

### Context Group Status (when groups exist)

If context groups have been generated, include additional section:

```
**Context Window Configuration**
- Max Tokens: 100,000
- Reserved: 20,000
- Effective Limit: 80,000

**Group Progress**
- Groups Completed: 1 of 3
- Active Group: CG-002 (25% complete)
- Remaining Groups: 2

**Recommended Action:**
Complete CG-002 tasks, then run `/sdd-manager:next-group` for CG-003
```

If no task file found, explain how to create one using `/sdd-manager:analyze`.
