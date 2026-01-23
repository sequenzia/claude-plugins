---
description: "Cancel active Ralph Mission loop"
allowed-tools: ["Bash(test -f .claude/ralph-mission.local.md:*)", "Bash(rm .claude/ralph-mission.local.md)", "Read(.claude/ralph-mission.local.md)"]
hide-from-slash-command-tool: "true"
---

# Cancel Ralph Mission

To cancel the Ralph Mission loop:

1. Check if `.claude/ralph-mission.local.md` exists using Bash: `test -f .claude/ralph-mission.local.md && echo "EXISTS" || echo "NOT_FOUND"`

2. **If NOT_FOUND**: Say "No active Ralph Mission loop found."

3. **If EXISTS**:
   - Read `.claude/ralph-mission.local.md` to get the current state:
     - `iteration` - current iteration number
     - `current_task_id` - the task being worked on
     - `mission_name` - name of the mission
   - Remove the file using Bash: `rm .claude/ralph-mission.local.md`
   - Report cancellation summary:
     ```
     Cancelled Ralph Mission loop
     - Mission: <mission_name>
     - Current task: <current_task_id>
     - Iteration: <iteration>
     ```
