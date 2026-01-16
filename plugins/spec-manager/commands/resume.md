---
description: Resume an interrupted PRD interview session
allowed-tools: [Read, Write, Glob, TodoWrite, AskUserQuestion]
model: inherit
---

# Resume PRD Interview

Continue an interrupted PRD creation interview from where it left off.

## Process

### 1. Check for Existing State

Look for `.claude/spec-manager.state.json`:

If **not found**:
- Report: "No interrupted interview found."
- Suggest: "Use `/spec-manager:create-prd` to start a new interview."
- Exit

### 2. Load and Validate State

Read the state file and validate:
- `version` is compatible (1.0.x)
- `current_project` exists or is null (early stage)
- `interview_phase` is valid
- `collected_data` is present
- `last_updated` is parseable

If invalid:
- Report: "State file is corrupted or invalid."
- Offer: "Would you like to (1) start fresh with `/spec-manager:create-prd`, or (2) delete the state file?"

### 3. Check for Completed Interview

If `interview_phase` is `completed`:
- Report: "The interview for '{project}' was already completed."
- Show output file path
- Suggest: "Use `/spec-manager:create-prd` to start a new interview."
- Exit

### 4. Display Resume Summary

Show the user what will be resumed:

```
## Resuming PRD Interview

**Project:** {current_project or "Not yet named"}
**Phase:** {interview_phase}
**Started:** {started_at}
**Last Updated:** {last_updated}

**Project Overview:**
{if provided: source type and summary}
{if not provided: "None - full interview mode"}

**Already Collected:**
{summary of collected_data fields that have values}

**Phases Completed:** {phases_completed list}

**Next:** Continue with {phase description}
```

### 5. Check for Stale State

If `last_updated` is older than 7 days:
- Warn: "This interview was last updated {X days} ago."
- Ask: "Would you like to continue or start fresh?"

### 6. Confirm Resume

Ask user to confirm:
- "Ready to continue the interview from the {phase} phase?"
- Options: "Yes, continue" / "No, start over"

If start over:
- Delete state file
- Suggest `/spec-manager:create-prd`
- Exit

### 7. Launch Interviewer with State

Launch the `prd-interviewer` agent with existing state context:
- Agent reads current state
- Picks up from saved phase
- Skips questions that already have answers
- Continues through remaining phases

## State File Structure

```json
{
  "version": "1.0.0",
  "current_project": "project-name",
  "interview_phase": "analysis|foundation|objectives|user_stories|functional|nfr|generation|completed",
  "started_at": "ISO-timestamp",
  "last_updated": "ISO-timestamp",
  "project_overview": {
    "provided": true,
    "source": "file|inline|none",
    "source_path": "path/to/file.md",
    "raw_content": "...",
    "analysis": {
      "extracted_project_name": "...",
      "extracted_summary": "...",
      "gaps_identified": [...],
      "ambiguities": [...]
    }
  },
  "collected_data": {
    "project_name": "...",
    "project_summary": "...",
    "project_type": "...",
    "existing_context": "...",
    "problem_statement": "...",
    "affected_users": "...",
    "primary_goals": [...],
    "success_metrics": "...",
    "non_goals": "...",
    "primary_users": "...",
    "user_needs": "...",
    "user_stories": [...],
    "edge_cases": "...",
    "p0_features": [...],
    "p1_features": [...],
    "p2_features": [...],
    "integrations": "...",
    "constraints": [...],
    "nfr_priorities": [...],
    "nfr_targets": "...",
    "acceptance_criteria": "...",
    "risks_questions": "..."
  },
  "phases_completed": ["analysis", "foundation"],
  "output_file": null
}
```

## Example Usage

```bash
# Resume an interrupted interview
/spec-manager:resume
```

## Error Handling

- **No state file:** Direct to `/spec-manager:create-prd`
- **Corrupted state:** Offer to start fresh
- **Very old state (>7 days):** Warn user, confirm they want to continue
- **Already completed:** Show output file, suggest new interview

## Related Commands

- `/spec-manager:create-prd` - Start new interview
