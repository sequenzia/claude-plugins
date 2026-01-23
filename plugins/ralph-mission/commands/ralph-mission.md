---
description: "Start Ralph Mission loop to autonomously complete mission-control tasks"
argument-hint: "<mission-path> [--max-iterations N] [--max-failed-attempts N]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/setup-ralph-mission.sh:*)"]
hide-from-slash-command-tool: "true"
---

# Ralph Mission Command

Execute the setup script to initialize the Ralph Mission loop:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-ralph-mission.sh" $ARGUMENTS
```

## How It Works

Ralph Mission autonomously iterates through tasks from a mission-control tasks.json file. For each task:

1. **Implement** the task completely based on its description and acceptance criteria
2. **Verify** all acceptance criteria are met
3. **Run tests** if applicable
4. **Update the task status** in the tasks.json file:
   - Edit the mission file
   - Find the current task by ID
   - Change `"status": "not_started"` to `"status": "complete"`
5. **Commit** your changes with: `feat: TASK-XXX - <title>`

## Important Rules

- **Do NOT mark a task complete unless ALL acceptance criteria are genuinely met**
- The loop detects completion by checking the task status in the JSON file
- Failed attempts (task not completed after your response) increment a counter
- After max failed attempts, the task is marked as "blocked" and we move on
- Progress and learnings are logged to `progress.txt` in the mission directory

## Stopping the Loop

The loop stops when:
- All tasks are complete
- All remaining tasks are blocked
- Max iterations is reached
- You run `/ralph-mission:cancel`

Trust the process - the loop continues until genuine completion.
