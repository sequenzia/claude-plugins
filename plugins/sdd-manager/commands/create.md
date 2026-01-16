---
description: Launch a new SDD interview to create specification documents (PRD, Tech Spec, Design Spec)
argument-hint: [project-name]
allowed-tools: [Read, Glob, Write, TodoWrite, AskUserQuestion]
model: inherit
---

# Create SDD Project

Start a new Spec Driven Development interview to generate specification documents for a project.

## Process

### 1. Check for Optional Project Name

If a project name is provided as argument (`$ARGUMENTS`):
- Use it as the initial project name
- Can be confirmed/changed during interview

### 2. Check for Existing Project

Search for existing SDD projects:
```
specs/<project-name>/
```

If found:
- Warn user: "A project named '{name}' already exists at specs/{name}/"
- Ask: "Do you want to (1) overwrite it, (2) use a different name, or (3) edit the existing documents?"
- Handle response appropriately

### 3. Check for In-Progress Interview

Check if `.claude/sdd-manager.state.json` exists:
- If exists with same project name: Offer to resume
- If exists with different project name: Warn about incomplete interview, offer to continue or abandon

### 4. Launch Interview

Launch the `sdd-interviewer` agent to conduct the interview:

The agent will:
1. Gather project foundation (name, type, context)
2. Configure scope and detail level
3. Explore problem and goals
4. Collect requirements
5. Dive into technical details (if mid/in-depth)
6. Explore design considerations (if UI components exist)
7. Generate specification documents

### 5. Save Initial State

Create initial state at `.claude/sdd-manager.state.json`:

```json
{
  "current_project": "<project-name>",
  "interview_phase": "foundation",
  "collected_data": {},
  "documents_to_generate": [],
  "last_updated": "<ISO-timestamp>"
}
```

## Output

After launching the interview, the user will interact with the sdd-interviewer agent until documents are generated.

Final outputs will be placed in `specs/<project-name>/`:
- `prd.md` - Product Requirements Document (always)
- `tech-spec.md` - Technical Specification (if applicable)
- `design-spec.md` - Design Specification (if UI components)

## Example Usage

```bash
# Start a new SDD interview
/sdd-manager:create

# Start with a suggested project name
/sdd-manager:create my-awesome-feature

# Start with a project name (will be confirmed during interview)
/sdd-manager:create user-authentication
```

## Next Steps After Creation

- `/sdd-manager:edit <project-name>` - Modify specific sections
- `/sdd-manager:list` - View all SDD projects
- `/spec-task-manager:analyze specs/<project-name>/prd.md` - Generate task list from PRD
