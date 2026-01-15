# spec-task-manager

A Claude Code plugin that transforms specification documents into structured, actionable task lists optimized for AI coding agents.

## Overview

When working from PRDs, technical specifications, or design documents, this plugin helps break down requirements into atomic tasks with clear dependencies, priorities, and testing criteria. The generated task lists enable AI agents to work independently or in parallel on implementation.

## Features

- **Specification Analysis**: Parse Markdown specs to extract requirements
- **Task Decomposition**: Break specs into atomic, independent tasks
- **Dependency Mapping**: Identify hard, soft, and resource dependencies
- **Priority Calculation**: Rank tasks by blocking potential and risk
- **Testing Criteria**: Generate acceptance criteria and test scenarios
- **Progress Tracking**: Track task completion and suggest next steps

## Installation

### Option 1: Plugin Directory
```bash
claude --plugin-dir /path/to/spec-task-manager
```

### Option 2: Copy to Project
Copy the entire `spec-task-manager` directory to your project's `.claude-plugin/` folder.

## Commands

| Command | Description |
|---------|-------------|
| `/spec-task-manager:analyze <doc>` | Parse spec and generate task list |
| `/spec-task-manager:update <doc>` | Re-analyze and update existing tasks |
| `/spec-task-manager:status` | Show task list summary and metrics |
| `/spec-task-manager:show <task-id>` | Display detailed task information |
| `/spec-task-manager:complete <task-id>` | Mark task complete, suggest next |
| `/spec-task-manager:block <task-id>` | Mark task blocked with reason |
| `/spec-task-manager:next` | Recommend best next tasks |
| `/spec-task-manager:export [format]` | Export as json, markdown, or csv |

## Proactive Agent

The **spec-analyzer** agent automatically detects specification documents by:

- **Filename patterns**: `*spec*`, `*prd*`, `*requirements*`, `*design-doc*`
- **Directories**: `specs/`, `docs/`, `requirements/`

When detected, the agent offers to analyze specs and generate task lists.

## Task List Format

Task lists are stored as JSON at `tasks/<project-name>.tasks.json`:

```json
{
  "metadata": {
    "source_document": "feature-spec.md",
    "generated_at": "2024-01-15T10:30:00Z",
    "version": "1.0.0",
    "total_tasks": 12,
    "completion_percentage": 25
  },
  "tasks": [
    {
      "id": "TASK-001",
      "title": "Create user model",
      "status": "complete",
      "priority": "high",
      "complexity": "M",
      "dependencies": { "hard": [], "soft": [] },
      "testing": {
        "acceptance_criteria": ["Model has all required fields"],
        "test_scenarios": ["Create user with valid data"]
      }
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
```

## Workflow Example

```bash
# 1. Analyze your specification
/spec-task-manager:analyze docs/feature-spec.md

# 2. Check recommended tasks
/spec-task-manager:next

# 3. Work on a task, then mark complete
/spec-task-manager:complete TASK-001

# 4. Check progress
/spec-task-manager:status

# 5. Export for stakeholders
/spec-task-manager:export markdown
```

## Task Properties

### Status
- `not_started`: Task not yet begun
- `in_progress`: Currently being worked on
- `blocked`: Cannot proceed due to dependencies
- `complete`: Task finished
- `obsolete`: No longer relevant

### Priority
- `critical`: Blocks many tasks, do first
- `high`: Important, do soon
- `medium`: Standard priority
- `low`: Can wait

### Complexity (T-shirt sizing)
- `XS`: < 20 lines, simple change
- `S`: 20-100 lines, straightforward
- `M`: 100-300 lines, moderate complexity
- `L`: 300-800 lines, significant logic
- `XL`: > 800 lines, complex integration

## Dependencies

### Hard Dependencies
Task B cannot start until Task A completes. These are blocking relationships.

### Soft Dependencies
Task B benefits from Task A being complete but can proceed independently.

### Resource Dependencies
Tasks share files, modules, or services and need coordination.

## License

MIT
