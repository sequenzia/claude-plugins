---
description: Resume an interrupted SDD interview session
allowed-tools: [Read, Write, Glob, TodoWrite, AskUserQuestion]
model: inherit
---

# Resume SDD Interview

Continue an interrupted Spec Driven Development interview from where it left off.

## Process

### 1. Check for Existing State

Look for `.claude/sdd-manager.state.json`:

If **not found**:
- Report: "No interrupted interview found."
- Suggest: "Use `/sdd-manager:create` to start a new interview."
- Exit

### 2. Load and Validate State

Read the state file and validate:
- `current_project` exists
- `interview_phase` is valid
- `collected_data` is present
- `last_updated` is parseable

If invalid:
- Report: "State file is corrupted or invalid."
- Offer: "Would you like to (1) start fresh with `/sdd-manager:create`, or (2) delete the state file?"

### 3. Display Resume Summary

Show the user what will be resumed:

```
## Resuming SDD Interview

**Project:** {current_project}
**Phase:** {interview_phase}
**Last Updated:** {last_updated}

**Already Collected:**
- Project Name: {project_name}
- Project Type: {project_type}
- Detail Level: {detail_level}
- ... (summary of collected data)

**Documents to Generate:**
- {document list}

**Next:** Continue with {next_questions_topic}
```

### 4. Confirm Resume

Ask user to confirm:
- "Ready to continue the interview from the {phase} phase?"
- Allow: "Yes, continue" or "No, start over"

If start over:
- Delete state file
- Suggest `/sdd-manager:create`
- Exit

### 5. Launch Interviewer with State

Launch the `sdd-interviewer` agent with existing state:
- Pass the loaded state context
- Agent will pick up from saved phase
- Agent will skip questions that already have answers

### 6. Continue Interview

The interviewer agent continues from saved phase:
- Validates previously collected data
- Asks remaining questions for current phase
- Proceeds through remaining phases
- Generates documents upon completion

## State File Structure

```json
{
  "current_project": "project-name",
  "interview_phase": "foundation|scope|problem|requirements|technical|design|generation",
  "collected_data": {
    "project_name": "...",
    "project_type": "...",
    "detail_level": "...",
    "document_structure": "...",
    "has_ui_components": false,
    "needs_timeline": false,
    "problem_statement": "...",
    "success_metrics": [...],
    "non_goals": [...],
    "core_features": [...],
    "user_stories": [...],
    "constraints": [...],
    "dependencies": [...],
    "architecture_notes": "...",
    "data_models": [...],
    "api_requirements": [...],
    "tech_stack": [...],
    "user_flows": [...],
    "key_screens": [...],
    "interactions": [...],
    "accessibility_requirements": [...]
  },
  "documents_to_generate": ["prd", "tech-spec", "design-spec"],
  "last_updated": "ISO-timestamp"
}
```

## Example Usage

```bash
# Resume an interrupted interview
/sdd-manager:resume
```

## Error Handling

- **No state file:** Direct to `/sdd-manager:create`
- **Corrupted state:** Offer to start fresh
- **Very old state (>7 days):** Warn user, confirm they want to continue
- **Project folder already exists with documents:** Warn about potential overwrite

## Related Commands

- `/sdd-manager:create` - Start new interview
- `/sdd-manager:edit <project-name>` - Edit existing documents
- `/sdd-manager:list` - View all projects
