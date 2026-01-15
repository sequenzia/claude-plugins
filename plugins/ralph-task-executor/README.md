# Ralph Task Executor

Automated task execution engine that integrates **spec-task-manager** with **ralph-loop** for continuous development workflows.

## Overview

Ralph Task Executor bridges the gap between task planning and task execution:

- **spec-task-manager** generates structured task lists from specifications
- **ralph-loop** provides iterative AI execution via the Ralph Wiggum technique
- **ralph-task-executor** orchestrates the execution of tasks through ralph-loop

The result is an automated development pipeline that can execute entire feature implementations from a single specification document.

## Installation

This plugin requires both `spec-task-manager` and `ralph-loop` plugins to be installed.

```bash
# Install dependencies first
/plugin install spec-task-manager
/plugin install ralph-loop

# Then install this plugin
/plugin install ralph-task-executor
```

## Quick Start

```bash
# 1. Generate tasks from a specification
/spec-task-manager:analyze docs/feature-spec.md

# 2. Start automated execution
/ralph-task-executor:execute tasks/feature-spec.tasks.json

# 3. Monitor progress
/ralph-task-executor:exec-status

# 4. Sync completed tasks (if not using --auto-sync)
/ralph-task-executor:sync
```

## Commands

### `/execute` - Start Execution

Start automated execution of a task file.

```bash
/ralph-task-executor:execute <tasks-file> [options]
```

**Options:**
- `--parallel`: Execute independent tasks concurrently
- `--auto-sync`: Auto-update task file on completion
- `--max-iterations N`: Max ralph-loop iterations per task (default: 10)

**Examples:**

```bash
# Basic sequential execution
/ralph-task-executor:execute tasks/my-feature.tasks.json

# Parallel with auto-sync
/ralph-task-executor:execute tasks/my-feature.tasks.json --parallel --auto-sync

# More iterations for complex tasks
/ralph-task-executor:execute tasks/my-feature.tasks.json --max-iterations 20
```

### `/exec-status` - Check Progress

Display execution progress and metrics.

```bash
/ralph-task-executor:exec-status [--verbose]
```

**Output includes:**
- Completion percentage
- Current task and iteration
- Blocked tasks with reasons
- Timing estimates

### `/pause` - Pause Execution

Pause the current execution loop.

```bash
/ralph-task-executor:pause [reason]
```

### `/resume` - Resume Execution

Resume a paused execution.

```bash
/ralph-task-executor:resume [--skip-current] [--task-id TASK-XXX]
```

**Options:**
- `--skip-current`: Mark current task as blocked and continue
- `--task-id`: Start from a specific task

### `/abort` - Abort Execution

Stop execution entirely.

```bash
/ralph-task-executor:abort [--keep-state]
```

### `/sync` - Sync Completions

Sync completed tasks to the task file (manual mode only).

```bash
/ralph-task-executor:sync [--task-id TASK-XXX]
```

### `/retry` - Retry Blocked Task

Retry a task that failed to complete.

```bash
/ralph-task-executor:retry <task-id> [--max-iterations N] [--additional-context "..."]
```

## How It Works

### Task-to-Prompt Conversion

Each task from spec-task-manager is converted into a ralph-loop prompt:

1. **Task details**: ID, title, description
2. **Dependency context**: Information from completed prerequisite tasks
3. **Acceptance criteria**: What must be satisfied
4. **Completion promise**: Unique tag to signal completion

### Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  Task File ──▶ Select Next Task ──▶ Build Prompt           │
│       │              │                    │                 │
│       │              │                    ▼                 │
│       │              │            Invoke ralph-loop         │
│       │              │                    │                 │
│       │              │                    ▼                 │
│       │              │         Iterate until complete       │
│       │              │                    │                 │
│       │              │           ┌───────┴───────┐          │
│       │              │           │               │          │
│       │              │     Success?          Timeout?       │
│       │              │           │               │          │
│       │              │           ▼               ▼          │
│       │              │     Mark complete   Mark blocked     │
│       │              │           │               │          │
│       │              │           └───────┬───────┘          │
│       │              │                   │                  │
│       │              ◀───────────────────┘                  │
│       │                                                     │
│       ▼                                                     │
│  All done? ──▶ Report Summary                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Dependency Handling

Tasks are executed in dependency order:

- **Hard dependencies**: Must complete before task can start
- **Soft dependencies**: Provide helpful context but don't block
- **Resource dependencies**: Warn about potential conflicts in parallel mode

### Failure Handling

When a task fails (max iterations without completion):

1. Task is marked as **blocked**
2. Reason is recorded in execution state
3. Dependent tasks are marked as **transitively blocked**
4. Execution continues with next available task
5. User can `/retry` blocked tasks later

## State Files

### Execution State

Location: `.claude/ralph-task-executor.state.json`

Tracks:
- Current execution status
- Completed and blocked tasks
- Timing metrics
- Configuration

### Task File

Location: `tasks/<project>.tasks.json` (from spec-task-manager)

Contains:
- Task definitions
- Dependencies
- Acceptance criteria

## Modes

### Sequential Mode (Default)

Executes one task at a time in dependency order. Simpler and safer.

```bash
/ralph-task-executor:execute tasks/feature.tasks.json
```

### Parallel Mode

Executes independent tasks concurrently. Faster but requires more coordination.

```bash
/ralph-task-executor:execute tasks/feature.tasks.json --parallel
```

### Auto-Sync Mode

Automatically updates task file on completion. Keeps spec-task-manager in sync.

```bash
/ralph-task-executor:execute tasks/feature.tasks.json --auto-sync
```

### Manual Sync Mode (Default)

Tracks completions internally. User syncs manually when ready.

```bash
# Execute without auto-sync
/ralph-task-executor:execute tasks/feature.tasks.json

# Later, sync completions
/ralph-task-executor:sync
```

## Best Practices

### Setting Max Iterations

- **Simple tasks** (XS/S complexity): 5-10 iterations
- **Medium tasks** (M complexity): 10-15 iterations
- **Complex tasks** (L/XL complexity): 15-25 iterations

```bash
# For a file with mostly complex tasks
/ralph-task-executor:execute tasks/feature.tasks.json --max-iterations 20
```

### Monitoring Long Executions

```bash
# Check status periodically
/ralph-task-executor:exec-status

# Get detailed breakdown
/ralph-task-executor:exec-status --verbose
```

### Handling Blocked Tasks

```bash
# See why a task blocked
/ralph-task-executor:exec-status --verbose

# Retry with more context
/ralph-task-executor:retry TASK-007 --additional-context "Use the v2 API endpoint"

# Skip and continue
/ralph-task-executor:resume --skip-current
```

### Using with Version Control

```bash
# Commit task file before execution
git add tasks/feature.tasks.json
git commit -m "Add tasks for feature X"

# Run execution
/ralph-task-executor:execute tasks/feature.tasks.json --auto-sync

# Commit results
git add .
git commit -m "Implement feature X via ralph-task-executor"
```

## Troubleshooting

### "No executable tasks found"

- Check that task file has tasks with status `not_started`
- Verify dependencies are satisfied
- Check if all tasks are blocked

### Task keeps timing out

- Increase `--max-iterations`
- Add context via `--additional-context` on retry
- Break task into smaller subtasks in spec

### Parallel mode conflicts

- Check for resource dependencies
- Fall back to sequential for conflicting tasks
- Use `--verbose` to see conflict warnings

## Dependencies

- **spec-task-manager**: Task generation and management
- **ralph-loop**: Iterative execution engine

## Version

0.1.0
