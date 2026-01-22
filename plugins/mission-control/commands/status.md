---
description: Show task list summary and completion metrics
argument-hint: [project-name]
allowed-tools: Read, Glob
---

Display a summary of task progress and completion status.

**Arguments:**
- `project-name` (optional): Project name to show status for specific task file

## Process

1. **Locate task files**
   - Search for `tasks/*.tasks.json` files
   - If `project-name` provided, use `tasks/<project-name>.tasks.json`
   - If multiple files and no project specified, show status for all or ask user

2. **Calculate metrics**
   - Count tasks by status (not_started, in_progress, blocked, complete)
   - Calculate completion percentage
   - Identify ready tasks (not_started with empty blocked_by)
   - Count tasks per execution phase

3. **Display summary**

## Output Format

```
# Task Status: <project-name>

**Source:** <spec-document>
**Last Updated:** <timestamp>

## Progress

| Metric | Value |
|--------|-------|
| Total Tasks | XX |
| Completed | XX (XX%) |
| In Progress | XX |
| Blocked | XX |
| Not Started | XX |

## Completion Bar

[████████░░░░░░░░░░░░] 40% Complete

## By Priority

| Priority | Total | Done | Remaining |
|----------|-------|------|-----------|
| Critical | X | Y | Z |
| High | X | Y | Z |
| Medium | X | Y | Z |
| Low | X | Y | Z |

## By Complexity

| Size | Total | Done | Remaining |
|------|-------|------|-----------|
| XS | X | Y | Z |
| S | X | Y | Z |
| M | X | Y | Z |
| L | X | Y | Z |
| XL | X | Y | Z |

## Execution Phases

| Phase | Name | Tasks | Done |
|-------|------|-------|------|
| 1 | Foundation | 5 | 3/5 |
| 2 | Core Features | 8 | 0/8 |
| 3 | Polish | 4 | 0/4 |

## Ready to Start

Tasks with no blockers (can begin now):

1. **TASK-XXX:** <title> (priority: high, complexity: M)
2. **TASK-YYY:** <title> (priority: medium, complexity: S)

## Currently Blocked

Tasks waiting on dependencies:

1. **TASK-AAA:** Blocked by TASK-XXX, TASK-YYY
2. **TASK-BBB:** Blocked by TASK-ZZZ

## Quick Actions

- View task: `/mission-control:show TASK-XXX`
- Complete task: `/mission-control:complete TASK-XXX`
- Next recommendations: `/mission-control:next`
```

## Multiple Projects

If multiple task files exist, show a summary table first:

```
# Task Status Overview

| Project | Total | Done | Progress |
|---------|-------|------|----------|
| project-a | 15 | 8 | 53% |
| project-b | 22 | 5 | 23% |

Run `/mission-control:status <project-name>` for details.
```
