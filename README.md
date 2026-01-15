# Claude Code Plugins Directory

A collection of plugins for [Claude Code](https://claude.ai/code) that enhance AI-assisted software development with structured workflows, task management, and documentation generation.

## Plugins

| Plugin | Description | Commands |
|--------|-------------|----------|
| [feature-dev](./plugins/feature-dev/) | 7-phase feature development workflow with specialized agents | `/feature-dev` |
| [prd-generator](./plugins/prd-generator/) | Product Requirements Document generator | `/prd-generator` |
| [spec-task-manager](./plugins/spec-task-manager/) | Transform specifications into structured task lists | `/spec-task-manager:*` |
| [ralph-task-executor](./plugins/ralph-task-executor/) | Automated task execution via ralph-loop | `/ralph-task-executor:*` |

## Quick Start

### Installation

#### Option 1: Add as Marketplace (Recommended)

Add this repository as a plugin marketplace directly in Claude Code:

```bash
# Add the marketplace
/plugin marketplace add sequenzia/claude-plugins

# List available plugins
/plugin marketplace list

# Install individual plugins
/plugin install feature-dev@sequenzia/claude-plugins
/plugin install prd-generator@sequenzia/claude-plugins
/plugin install spec-task-manager@sequenzia/claude-plugins
/plugin install ralph-task-executor@sequenzia/claude-plugins
```

This method automatically handles updates and dependencies.

#### Option 2: Clone and Use Locally

Clone the repository and point Claude Code to the plugins directory:

```bash
git clone https://github.com/sequenzia/claude-plugins.git
cd claude-plugins

# Use a specific plugin
claude --plugin-dir ./plugins/feature-dev

# Or use all plugins
claude --plugin-dir ./plugins/feature-dev --plugin-dir ./plugins/prd-generator --plugin-dir ./plugins/spec-task-manager --plugin-dir ./plugins/ralph-task-executor
```

### Usage

Once installed, plugins are available via slash commands:

```bash
# Start a guided feature development workflow
/feature-dev Add user authentication with OAuth

# Generate a PRD for a new feature
/prd-generator Task priority system

# Analyze a specification and create tasks
/spec-task-manager:analyze docs/feature-spec.md

# Execute tasks automatically via ralph-loop
/ralph-task-executor:execute tasks/feature-spec.tasks.json --auto-sync
```

## Plugin Details

### feature-dev

A comprehensive 7-phase workflow for building features:

1. **Discovery** - Understand what needs to be built
2. **Codebase Exploration** - Analyze relevant existing code
3. **Clarifying Questions** - Resolve ambiguities
4. **Architecture Design** - Design multiple approaches
5. **Implementation** - Build the feature
6. **Quality Review** - Review for bugs and quality
7. **Summary** - Document what was accomplished

**Specialized Agents:**
- `code-explorer` - Traces execution paths and maps architecture
- `code-architect` - Designs implementation approaches
- `code-reviewer` - Reviews for bugs, quality, and conventions

[Full documentation](./plugins/feature-dev/README.md)

### prd-generator

Generates structured Product Requirements Documents through a guided process:

1. Ask 3-5 clarifying questions with lettered options
2. Generate PRD with goals, user stories, and requirements
3. Save to `tasks/prd-[feature-name].md`

**PRD Sections:**
- Introduction/Overview
- Goals
- User Stories with Acceptance Criteria
- Functional Requirements
- Non-Goals (Out of Scope)
- Technical Considerations
- Success Metrics

[Full documentation](./plugins/prd-generator/SKILL.md)

### spec-task-manager

Transforms specification documents into actionable task lists optimized for AI agents.

**Commands:**
| Command | Description |
|---------|-------------|
| `analyze <doc>` | Parse spec and generate task list |
| `status` | Show task list summary and metrics |
| `show <task-id>` | Display detailed task information |
| `complete <task-id>` | Mark task complete |
| `block <task-id>` | Mark task blocked with reason |
| `next` | Recommend best next tasks |
| `export [format]` | Export as json, markdown, or csv |

**Features:**
- Automatic dependency mapping (hard, soft, resource)
- Priority calculation based on blocking potential
- Execution phases for parallel work
- Progress tracking and metrics

[Full documentation](./plugins/spec-task-manager/README.md)

### ralph-task-executor

Automated task execution engine that bridges spec-task-manager with ralph-loop for continuous development workflows.

**Commands:**
| Command | Description |
|---------|-------------|
| `execute <file>` | Start automated task execution |
| `exec-status` | Show progress and metrics |
| `pause` | Pause execution loop |
| `resume` | Resume paused execution |
| `abort` | Stop execution entirely |
| `sync` | Sync completions to task file |
| `retry <task-id>` | Retry a blocked task |

**Features:**
- Task-to-prompt conversion with dependency context
- Sequential or parallel execution modes
- Configurable auto-sync to task file
- Failure handling with blocked task cascade
- Progress monitoring and timing metrics

**Dependencies:** Requires `spec-task-manager` and `ralph-loop` plugins

[Full documentation](./plugins/ralph-task-executor/README.md)

## Project Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Central plugin registry
├── plugins/
│   ├── feature-dev/          # Feature development workflow
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/feature-dev.md
│   │   └── agents/
│   │       ├── code-explorer.md
│   │       ├── code-architect.md
│   │       └── code-reviewer.md
│   ├── prd-generator/         # PRD generator
│   │   ├── .claude-plugin/plugin.json
│   │   └── SKILL.md
│   ├── spec-task-manager/     # Specification task manager
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/*.md
│   │   ├── agents/spec-analyzer.md
│   │   └── skills/spec-task-management/
│   └── ralph-task-executor/   # Automated task execution
│       ├── .claude-plugin/plugin.json
│       ├── commands/*.md
│       ├── agents/task-executor.md
│       └── skills/task-execution/
├── CLAUDE.md                  # Project instructions for Claude Code
└── README.md
```

## Plugin Anatomy

Each plugin follows a standard structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── commands/                  # Slash commands (*.md)
├── agents/                    # Agent definitions (*.md)
└── skills/                    # Optional reusable workflows
```

### Command/Agent Definition

Commands and agents are defined in Markdown with YAML frontmatter:

```yaml
---
description: What the command does
argument-hint: Expected arguments
allowed-tools: [Glob, Grep, Read, Write, Edit, Bash]
model: inherit
---

# Command instructions in Markdown...
```

## Creating Your Own Plugin

1. Create a new directory under `plugins/`
2. Add `.claude-plugin/plugin.json` with metadata:
   ```json
   {
     "name": "my-plugin",
     "version": "1.0.0",
     "description": "What my plugin does",
     "author": { "name": "Your Name" }
   }
   ```
3. Add commands in `commands/*.md` with YAML frontmatter
4. Optionally add agents in `agents/*.md`
5. Update the root `marketplace.json` to register your plugin

## Author

Stephen Sequenzia (sequenzia@gmail.com)

## License

MIT
