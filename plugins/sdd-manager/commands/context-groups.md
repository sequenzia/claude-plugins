---
description: Generate context window-aware task groups for AI coding agents
argument-hint: [project-name] [--max-tokens=N] [--reserve=N]
allowed-tools: Read, Write, Glob
---

Generate context groups from an existing task list, organizing tasks into batches that fit within AI context window limits.

## Process

1. **Parse arguments**
   - `$1` = Project name (optional)
   - `--max-tokens=N` = Maximum context window tokens (default: 100000)
   - `--reserve=N` = Reserved tokens for agent responses (default: 20000)

2. **Locate and read the task file**
   - If project name provided: Read `tasks/$1.tasks.json`
   - If no project name: Find most recently modified `.tasks.json`

3. **Load token configuration**
   - Read defaults from `skills/spec-task-management/references/context-defaults.json`
   - Apply any command-line overrides

4. **Calculate token estimates for each task**

   Use complexity-based estimation:
   | Complexity | Base Tokens |
   |------------|-------------|
   | XS | 500 |
   | S | 1,500 |
   | M | 4,000 |
   | L | 10,000 |
   | XL | 25,000 |

   Add overhead:
   - Base per task: 200 tokens
   - Per hard dependency: 100 tokens

5. **Build dependency graph**
   - Create adjacency list from hard dependencies
   - Detect any cycles (should already be handled)
   - Calculate in-degree for each task

6. **Topological sort by execution phase**
   - Order tasks by their execution_phase first
   - Within phase, order by dependency depth (tasks that unblock more come first)
   - Break ties by priority (critical > high > medium > low)

7. **Bin-pack tasks into context groups**

   ```
   effective_limit = max_tokens - reserve_tokens
   current_group = new group
   current_tokens = 0

   for each task in sorted_order:
       # Calculate tokens needed for task + any hard deps not yet assigned
       task_tokens = estimate_tokens(task)
       unassigned_dep_tokens = sum(estimate_tokens(d) for d in task.hard_deps if not d.assigned)
       total_needed = task_tokens + unassigned_dep_tokens

       # Check if task exceeds effective limit (oversized)
       if task_tokens > effective_limit:
           # Close current group if not empty
           if current_group.tasks.length > 0:
               mark_group_end(current_group.tasks.last)
               save_group(current_group)

           # Create dedicated group for oversized task
           oversized_group = new group with oversized_warning=true
           add_task(oversized_group, task)
           mark_group_start(task)
           mark_group_end(task)
           save_group(oversized_group)

           current_group = new group
           current_tokens = 0
           continue

       # Check if adding task exceeds limit
       if current_tokens + total_needed > effective_limit:
           # Close current group
           mark_group_end(current_group.tasks.last)
           save_group(current_group)

           # Start new group
           current_group = new group
           current_tokens = 0

       # Add unassigned hard dependencies first (in order)
       for dep in task.hard_deps:
           if not dep.assigned:
               if current_group.tasks.length == 0:
                   mark_group_start(dep)
               add_task(current_group, dep)
               current_tokens += estimate_tokens(dep)

       # Add the task
       if current_group.tasks.length == 0:
           mark_group_start(task)
       add_task(current_group, task)
       current_tokens += task_tokens

   # Close final group
   if current_group.tasks.length > 0:
       mark_group_end(current_group.tasks.last)
       save_group(current_group)
   ```

8. **Handle dependency chains exceeding limit**
   - If a chain of hard dependencies exceeds limit, split at minimum-cut points
   - Add `context_handoff` metadata to indicate split
   - Document which outputs from previous group are needed

9. **Update task file**
   - Add `context_group_id` to each task
   - Set `context_group_start` on first task of each group
   - Set `context_group_end` on last task of each group
   - Add `estimated_tokens` to each task
   - Add `context_groups` array at root level
   - Update `metadata.context_config` with configuration used
   - Set `metadata.total_context_groups`

10. **Display summary**

Format output as:

```
## Context Groups Generated

**Configuration**
- Max Tokens: 100,000
- Reserved: 20,000
- Effective Limit: 80,000

**Summary**
- Total Tasks: X
- Total Groups: Y
- Average Tasks/Group: Z

### Group Breakdown

| Group | Tasks | Est. Tokens | Phases | Status |
|-------|-------|-------------|--------|--------|
| CG-001 | 5 | 72,000 | 1, 2 | pending |
| CG-002 | 4 | 68,500 | 2, 3 | pending |
| CG-003 | 3 | 45,200 | 3 | pending |

### Warnings

- CG-002: Contains oversized task TASK-015 (XL complexity)
- CG-003: Dependency chain split from CG-002

---

**Next Steps:**
- Use `/sdd-manager:next-group` to get the first group ready for execution
- Use `/sdd-manager:show-group CG-001` to see group details
- Coding agents should reset context between groups
```

## Edge Cases

### Oversized Task (XL > effective_limit)
- Place in its own group
- Add `oversized_warning: true` to group
- Display warning in output
- Continue with remaining tasks

### Dependency Chain Exceeds Limit
- Identify minimum-cut point in chain
- Split into separate groups
- Add `context_handoff` metadata:
  ```json
  {
    "from_group": "CG-001",
    "to_group": "CG-002",
    "split_reason": "Dependency chain exceeded token limit",
    "handoff_tasks": ["TASK-003", "TASK-004"]
  }
  ```

### All Tasks Already Assigned
- Skip tasks with existing `context_group_id`
- Only process unassigned tasks
- Useful for incremental updates

### No Tasks to Group
- Display message: "No unassigned tasks found"
- Suggest running `/sdd-manager:analyze` first

## Example Output

After running `/sdd-manager:context-groups my-project --max-tokens=100000`:

```json
{
  "metadata": {
    "context_config": {
      "max_tokens": 100000,
      "reserve_tokens": 20000,
      "effective_limit": 80000
    },
    "total_context_groups": 3
  },
  "tasks": [
    {
      "id": "TASK-001",
      "context_group_id": "CG-001",
      "context_group_start": true,
      "context_group_end": false,
      "estimated_tokens": 4200
    },
    {
      "id": "TASK-004",
      "context_group_id": "CG-001",
      "context_group_start": false,
      "context_group_end": true,
      "estimated_tokens": 10200
    },
    {
      "id": "TASK-005",
      "context_group_id": "CG-002",
      "context_group_start": true,
      "estimated_tokens": 1700
    }
  ],
  "context_groups": [
    {
      "id": "CG-001",
      "tasks": ["TASK-001", "TASK-002", "TASK-003", "TASK-004"],
      "estimated_tokens": 72000,
      "phases_covered": [1, 2],
      "status": "pending"
    },
    {
      "id": "CG-002",
      "tasks": ["TASK-005", "TASK-006", "TASK-007"],
      "estimated_tokens": 68500,
      "phases_covered": [2, 3],
      "status": "pending"
    }
  ]
}
```
