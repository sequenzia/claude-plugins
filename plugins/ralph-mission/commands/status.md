---
description: "Show Ralph Mission loop progress"
allowed-tools: ["Read", "Bash(jq:*)"]
hide-from-slash-command-tool: "true"
---

# Ralph Mission Status

To show the current Ralph Mission status:

1. Check if `.claude/ralph-mission.local.md` exists by reading it

2. **If file doesn't exist**: Say "No active Ralph Mission loop."

3. **If file exists**, parse the YAML frontmatter to extract:
   - `mission_path` - path to tasks.json
   - `mission_name` - name of the mission
   - `current_task_id` - task being worked on
   - `iteration` - current iteration
   - `max_iterations` - safety limit
   - `max_failed_attempts` - attempts per task
   - `current_attempts` - attempts on current task
   - `started_at` - when loop started

4. Read the tasks.json file from `mission_path` and calculate:
   - Total tasks
   - Completed tasks
   - Blocked tasks
   - Remaining tasks (not_started + in_progress)
   - Completion percentage

5. Display status report:

```
🔄 Ralph Mission Status

Mission: <mission_name>
Source: <mission_path>
Started: <started_at>

Current Task: <current_task_id>
Attempts: <current_attempts>/<max_failed_attempts>

Progress:
  ✅ Completed: X tasks
  🚫 Blocked: Y tasks
  ⏳ Remaining: Z tasks
  📊 Overall: XX%

Loop:
  Iteration: <iteration>/<max_iterations or "unlimited">
```

If there's a `progress.txt` file in the mission directory, mention that learnings are being recorded there.
