# Mission Control

A simplified task management plugin for Claude Code that enables coding agents to generate task lists from specifications, track tasks, and manage dependencies.

## Features

- **Task Generation**: Parse PRDs, technical specs, and design documents into structured task lists
- **Mission-Based Organization**: Group tasks under named missions for better organization
- **Dependency Tracking**: Map blocking dependencies between tasks
- **Progress Monitoring**: Track completion status and identify blocked tasks
- **Smart Recommendations**: Get prioritized task suggestions based on dependencies and complexity
- **PRD Integration**: Seamless integration with prd-tools PRD format

## Quick Start

### 1. Generate Tasks from a Specification

```
/mission-control:generate "Build Auth System" path/to/spec.md
```

This creates:
- `missions/build-auth-system/<project>.tasks.json` - Structured task data
- `missions/build-auth-system/<project>.tasks.md` - Human-readable summary

### 2. Check Status

```
/mission-control:status
```

View completion progress, blocked tasks, and what's ready to start.

### 3. Get Next Tasks

```
/mission-control:next
```

Get prioritized recommendations for what to work on next.

### 4. View Task Details

```
/mission-control:show TASK-001
```

See full task information including dependencies and acceptance criteria.

### 5. Mark Complete

```
/mission-control:complete TASK-001
```

Mark a task done and see what new tasks become unblocked.

## Commands

| Command | Description | Arguments |
|---------|-------------|-----------|
| `generate` | Parse spec and generate task list | `<mission-name> <spec-document>` |
| `show` | Display task details | `<task-id> [project-name]` |
| `status` | Show progress summary | `[project-name]` |
| `complete` | Mark task complete | `<task-id> [project-name]` |
| `next` | Recommend next tasks | `[count] [project-name]` |

## Task Schema

Tasks are stored in JSON format with the following structure:

```json
{
  "mission": {
    "name": "Build User Authentication System",
    "metadata": {
      "source_document": "spec.md",
      "generated_at": "2024-01-15T10:30:00Z",
      "last_updated": "2024-01-15T10:30:00Z",
      "version": "1.0.0",
      "total_tasks": 12,
      "completion_percentage": 0
    },
    "tasks": [
      {
        "id": "TASK-001",
        "title": "Task title",
        "description": "What needs to be done",
        "status": "not_started",
        "priority": "high",
        "complexity": "M",
        "dependencies": ["TASK-002"],
        "blocked_by": [],
        "blocks": ["TASK-003"],
        "acceptance_criteria": ["Criterion 1"],
        "source_requirements": ["Section 5.1"],
        "notes": "Optional notes"
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

## PRD Integration

When analyzing PRDs created with prd-tools:

- **Section 5** (Functional Requirements) → Features and tasks
- **User Stories** (US-XXX) → `source_requirements`
- **Acceptance Criteria** → Task `acceptance_criteria`
- **Priority** (P0-P3) → critical/high/medium/low
- **Section 9** (Implementation Plan) → `execution_phases`
- **Section 10** (Dependencies) → Task dependencies

## Task Status

| Status | Description |
|--------|-------------|
| `not_started` | Task not yet begun |
| `in_progress` | Currently being worked on |
| `blocked` | Waiting on incomplete dependencies |
| `complete` | Task finished |

## Priority Levels

| Priority | Description |
|----------|-------------|
| `critical` | Must be done first, blocks everything |
| `high` | Important, should be prioritized |
| `medium` | Standard priority |
| `low` | Can be deferred |

## Complexity Sizing

| Size | Scope |
|------|-------|
| XS | Single function, < 20 lines |
| S | Single file, 20-100 lines |
| M | Multiple files, 100-300 lines |
| L | Multiple components, 300-800 lines |
| XL | System-wide, > 800 lines |

## Agent

The **spec-analyzer** agent proactively triggers when specification documents are detected in your project. It looks for files matching:

- `*spec*`, `*prd*`, `*requirements*`, `*design-doc*`
- Files in `specs/`, `docs/`, `requirements/` directories

## Differences from task-manager

This is a simplified version of the full task-manager plugin:

| Feature | task-manager | mission-control |
|---------|--------------|-----------------|
| Context window grouping | Yes | No |
| Soft/resource dependencies | Yes | No |
| Test scenarios & edge cases | Yes | No |
| Token estimation | Yes | No |
| Dependency graph | Yes | No |
| Basic task management | Yes | Yes |
| Blocking dependencies | Yes | Yes |
| Acceptance criteria | Yes | Yes |
| Execution phases | Yes | Yes |

Use **mission-control** for simpler projects or when you don't need context window optimization.

## File Structure

```
mission-control/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── generate.md
│   ├── show.md
│   ├── status.md
│   ├── complete.md
│   └── next.md
├── agents/
│   └── spec-analyzer.md
├── skills/
│   └── simple-task-management/
│       ├── SKILL.md
│       └── references/
│           └── task-schema.json
├── missions/
│   └── <mission-slug>/
│       ├── <project>.tasks.json
│       └── <project>.tasks.md
└── README.md
```
