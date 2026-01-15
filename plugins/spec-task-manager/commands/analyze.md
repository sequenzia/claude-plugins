---
description: Analyze a specification document and generate a structured task list
argument-hint: <spec-document>
allowed-tools: Read, Write, Glob
---

Analyze the specification document provided and generate a comprehensive task list.

**Input document:** @$ARGUMENTS

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
   - **Hard dependencies**: Task B cannot start until Task A completes
   - **Soft dependencies**: Task B benefits from Task A being complete
   - Calculate `blocked_by` and `blocks` relationships

4. **Assign priorities and complexity**
   - Priority: critical, high, medium, low (based on dependency depth and risk)
   - Complexity: XS, S, M, L, XL (T-shirt sizing)

5. **Generate testing criteria for each task**
   - Acceptance criteria (must be true when complete)
   - Test scenarios (concrete verification steps)
   - Edge cases (boundary conditions to consider)

6. **Organize into execution phases**
   - Phase 1: Tasks with no hard dependencies
   - Phase 2+: Tasks whose dependencies are satisfied by previous phases

## Output

Write the task list to `tasks/<project-name>.tasks.json` where `<project-name>` is derived from the specification filename.

Create the `tasks/` directory if it doesn't exist.

Use the JSON schema from the spec-task-management skill for proper formatting:
- Include full metadata (source_document, generated_at, version, etc.)
- All tasks with complete properties
- Dependency graph with nodes and edges
- Execution phases for parallel work

After writing, display a summary:
- Total tasks generated
- Breakdown by priority and complexity
- Number of execution phases
- Tasks ready to start (Phase 1)
