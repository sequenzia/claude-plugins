# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **Claude Code Plugin Directory** containing three plugins for feature development, PRD generation, and specification-based task management. Plugins are defined entirely in Markdown files with YAML frontmatter.

## Project Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Central plugin registry
└── plugins/
    ├── feature-dev/          # 7-phase feature development workflow
    ├── prd/                   # PRD generation
    └── spec-task-manager/    # Spec decomposition into tasks
```

Each plugin follows this structure:
```
plugin-name/
├── .claude-plugin/plugin.json    # Plugin metadata
├── README.md                     # Plugin documentation
├── commands/                     # Slash commands (*.md)
├── agents/                       # Agent definitions (*.md)
└── skills/                       # Optional reusable workflows
    └── skill-name/
        ├── SKILL.md
        └── references/           # Supporting schemas/patterns
```

## Plugin System

**No build system** - plugins are Markdown files loaded directly by Claude Code.

### Plugin Metadata (`plugin.json`)
```json
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "What the plugin does",
  "author": { "name": "Name", "email": "email@example.com" }
}
```

### Command/Agent Definition (YAML Frontmatter)
```yaml
---
# Commands
description: What the command does
argument-hint: Expected arguments
allowed-tools: [Glob, Grep, Read, Write, Edit, Bash, TodoWrite]
model: inherit  # or opus/haiku

# Agents
name: agent-identifier
description: What the agent does
tools: [Glob, Grep, Read, TodoWrite]
model: inherit
color: yellow  # yellow/green/red/cyan
---
```

### Key Patterns

- **Tool Restrictions**: Commands/agents declare `allowed-tools` for security and focus
- **Model Selection**: `inherit` from context, or explicitly specify `opus`/`haiku`
- **Color Coding**: Agents use colors for visual differentiation in UI
- **Frontmatter Required**: All commands and agents need YAML frontmatter

## Plugins

### feature-dev
7-phase workflow: Discovery → Codebase Exploration → Clarifying Questions → Architecture Design → Implementation → Quality Review → Summary

**Agents**: `code-explorer` (traces patterns), `code-architect` (designs approaches), `code-reviewer` (finds bugs)

### spec-task-manager
Transforms specifications into structured task lists with dependency tracking.

**Commands**: `analyze`, `complete`, `status`, `show`, `block`, `next`, `export`, `update`

**Task output**: `tasks/<project-name>.tasks.json`

**Dependency model**:
- Hard: Blocking (Task B requires Task A complete)
- Soft: Informational (Task B benefits from Task A)
- Resource: Coordination (tasks share files)

**Execution phases**: Auto-calculated for parallel work

### prd
Generates Product Requirements Documents with goals, user stories, functional requirements, and success metrics.

**Output**: `tasks/prd-[feature-name].md`

## Development Workflow

1. Add new command/agent as `.md` file with YAML frontmatter
2. Place in appropriate directory (`commands/`, `agents/`, `skills/`)
3. Update `plugin.json` version if significant changes
4. Update plugin `README.md` with new functionality
5. Update `/.claude-plugin/marketplace.json` if adding new plugin

## File Conventions

- Commands: `/commands/command-name.md`
- Agents: `/agents/agent-name.md`
- Skills: `/skills/skill-name/SKILL.md`
- Reference docs: `/skills/skill-name/references/`
- Plugin metadata: `/.claude-plugin/plugin.json`
