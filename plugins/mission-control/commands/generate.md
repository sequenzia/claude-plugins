---
description: Generate a structured task list from a specification document
argument-hint: <mission-name> <spec-document>
allowed-tools: Read, Write, Glob
---

Generate a comprehensive task list from a specification document, organized under a named mission.

**Arguments:** $ARGUMENTS

Parse the arguments to extract:
- **Mission name**: First argument (required) - The name for this mission (e.g., "Build User Authentication System")
- **Spec document**: Second argument (required) - Path to the specification document

If mission name contains spaces, it should be quoted. Example: `/mission-control:generate "Build Auth System" specs/auth-spec.md`

## Analysis Process

1. **Read and parse the specification document thoroughly**
   - Identify all explicit requirements, features, and acceptance criteria
   - Extract implicit requirements (error handling, infrastructure, etc.)
   - Note constraints and scope boundaries

2. **Decompose into atomic tasks**
   - Each task should have single responsibility
   - Tasks should be independent where possible
   - Tasks must have clear start/end conditions
   - Tasks must be testable with verifiable criteria

3. **Map dependencies between tasks**
   - Identify blocking dependencies: Task B cannot start until Task A completes
   - Calculate `blocked_by` and `blocks` relationships
   - Flag tasks that are ready to start (no blockers)

4. **Assign priorities and complexity**
   - Priority: critical, high, medium, low (based on dependency depth and risk)
   - Complexity: XS, S, M, L, XL (T-shirt sizing)
   - When parsing PRDs, map P0=critical, P1=high, P2=medium, P3=low

5. **Generate acceptance criteria for each task**
   - Derive from the specification's acceptance criteria and user stories
   - Ensure each criterion is specific and testable

6. **Organize into execution phases**
   - Phase 1: Tasks with no blocking dependencies
   - Phase 2+: Tasks whose dependencies are satisfied by previous phases

## PRD Integration

When analyzing PRDs from prd-tools:
- Extract features from Section 5 (Functional Requirements)
- Map user stories (US-XXX) to `source_requirements`
- Convert acceptance criteria items to task `acceptance_criteria`
- Map P0-P3 priorities to critical/high/medium/low
- Use Section 9 (Implementation Plan) for `execution_phases`
- Use Section 10 (Dependencies) for task dependencies

## Output

### Directory Structure

Create the mission directory: `missions/<mission-slug>/`

The mission slug is derived from the mission name:
- Convert to lowercase
- Replace spaces with hyphens
- Remove special characters

Example: "Build User Authentication System" → `missions/build-user-authentication-system/`

### 1. JSON Task File

Write the task list to `missions/<mission-slug>/<project-name>.tasks.json` where `<project-name>` is derived from the specification filename.

**Required structure:**
```json
{
  "mission": {
    "name": "Build User Authentication System",
    "metadata": {
      "source_document": "<spec path>",
      "generated_at": "<ISO-8601>",
      "last_updated": "<ISO-8601>",
      "version": "1.0.0",
      "total_tasks": <count>,
      "completion_percentage": 0
    },
    "tasks": [
      {
        "id": "TASK-001",
        "title": "Brief descriptive title",
        "description": "What needs to be done",
        "status": "not_started",
        "priority": "high",
        "complexity": "M",
        "dependencies": ["TASK-002"],
        "blocked_by": [],
        "blocks": ["TASK-003"],
        "acceptance_criteria": ["Criterion 1", "Criterion 2"],
        "source_requirements": ["Section 5.1", "US-001"],
        "notes": "Optional implementation notes"
      }
    ],
    "execution_phases": [
      {
        "phase": 1,
        "name": "Foundation",
        "tasks": ["TASK-001", "TASK-002"]
      }
    ]
  }
}
```

### 2. Markdown Summary File

Write a markdown summary to `missions/<mission-slug>/<project-name>.tasks.md`:

```markdown
# Mission: <mission-name>

**Source:** <spec-path>
**Generated:** <timestamp>

## Summary

- **Total tasks:** X
- **Execution phases:** Y
- **Ready to start:** Z

## By Priority

| Priority | Count |
|----------|-------|
| Critical | X |
| High | Y |
| Medium | Z |
| Low | W |

## By Complexity

| Size | Count |
|------|-------|
| XS | X |
| S | Y |
| M | Z |
| L | W |
| XL | V |

## Execution Phases

### Phase 1: <phase-name>

| Task | Title | Priority | Complexity |
|------|-------|----------|------------|
| TASK-001 | <title> | high | M |

### Phase 2: <phase-name>

| Task | Title | Priority | Complexity |
|------|-------|----------|------------|
| TASK-003 | <title> | high | L |

(continue for all phases)

## Ready to Start

Tasks with no blocking dependencies:

- **TASK-001:** <title>
- **TASK-002:** <title>

## Next Steps

1. View task details: `/mission-control:show TASK-XXX`
2. Start recommended tasks: `/mission-control:next`
3. Mark tasks complete: `/mission-control:complete TASK-XXX`
```

### 3. Display Summary

After writing both files, display a brief summary to the console:
- Mission name
- Total tasks generated
- Breakdown by priority and complexity
- Number of execution phases
- Tasks ready to start (Phase 1)
- Paths to both output files
