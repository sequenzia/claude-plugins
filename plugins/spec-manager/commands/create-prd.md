---
description: Launch a new PRD interview to create a Product Requirements Document
argument-hint: [@overview-file | "inline project overview"]
allowed-tools: [Read, Glob, Write, TodoWrite, AskUserQuestion]
model: inherit
---

# Create PRD

Start a new PRD creation interview to generate a Product Requirements Document for a project.

## Input Methods

The command accepts optional project overview input in two forms:

1. **File reference**: `@overview.md` - Reads and analyzes the file content (project description, goals, requirements, etc.)
2. **Inline text**: `"Build a user auth system with OAuth..."` - Direct text argument
3. **No input**: Start from scratch with full interview

## Process

### 1. Parse Arguments

Check `$ARGUMENTS` for input:
- If starts with `@`: Extract file path, read file content
- If quoted text: Use as inline requirements
- If empty: No pre-populated data, full interview

### 2. Check for In-Progress Interview

Check if `.claude/spec-manager.state.json` exists:
- If exists and `interview_phase` is not `completed`:
  - Show current project name and phase
  - Ask: "An interview for '{project}' is in progress at phase '{phase}'. Would you like to (1) Resume it, (2) Abandon it and start fresh?"
  - Handle response appropriately

### 3. Check for Existing PRD

If project name is determinable from requirements:
- Search for `specs/<project-name>.prd.md`
- If found: Warn about existing PRD, offer to overwrite or use different name

### 4. Initialize State

Create initial state at `.claude/spec-manager.state.json`:

```json
{
  "version": "1.0.0",
  "current_project": null,
  "interview_phase": "analysis",
  "started_at": "<ISO-timestamp>",
  "last_updated": "<ISO-timestamp>",
  "project_overview": {
    "provided": true|false,
    "source": "file|inline|none",
    "source_path": "path/to/file.md",
    "raw_content": "...",
    "analysis": null
  },
  "collected_data": {},
  "phases_completed": [],
  "output_file": null
}
```

### 5. Launch Interviewer

Launch the `prd-interviewer` agent to conduct the interview.

The agent will:
1. **If overview provided**: Analyze input, extract data, present findings, ask targeted follow-ups
2. **If no overview**: Conduct full interview from scratch
3. Gather project foundation (name, summary, type)
4. Explore objectives (problem, goals, metrics)
5. Collect user stories (personas, needs, stories)
6. Define functional requirements (P0/P1/P2 features)
7. Specify non-functional requirements (NFRs, constraints)
8. Generate the PRD document

## Output

After completing the interview, the PRD will be generated at:
```
specs/<project-name>.prd.md
```

## Example Usage

```bash
# Start with an overview file
/spec-manager:create-prd @docs/project-overview.md

# Start with inline overview
/spec-manager:create-prd "Build a task management app with projects, due dates, and team collaboration"

# Start from scratch
/spec-manager:create-prd
```

## Next Steps After Creation

- `/spec-manager:resume` - Resume an interrupted interview
- `/spec-task-manager:analyze specs/<project-name>.prd.md` - Generate task list from PRD
