# CLAUDE.md

## Project Overview

This repository contains Claude Code plugins for development tools, productivity, and workflow automation.

## Plugins

### task-manager
Location: `plugins/task-manager/`

Spec Driven Development plugin that transforms specifications into structured, actionable task lists optimized for AI coding agents.

Commands:
- `/task-manager:analyze` - Analyze spec and generate task list
- `/task-manager:status` - Show task summary and metrics
- `/task-manager:next` - Suggest next tasks to work on
- `/task-manager:complete` - Mark task complete
- `/task-manager:block` - Mark task as blocked
- `/task-manager:show` - Show task details
- `/task-manager:update` - Re-analyze spec and update tasks
- `/task-manager:export` - Export task list
- `/task-manager:context-groups` - Generate context-aware task groups
- `/task-manager:next-group` - Get next context group
- `/task-manager:show-group` - Show context group details

### prd-tools
Location: `plugins/prd-tools/`

Generates Product Requirements Documents through an interactive interview-based workflow. Features:
- Three depth levels: high-level overview, detailed specifications, full technical documentation
- Adaptive interview process that adjusts based on user responses
- On-demand research: technical docs, best practices, competitive analysis, compliance requirements
- Codebase exploration for "new feature" type PRDs
- Configurable output via `.claude/prd-tools.local.md`

Commands:
- `/prd-tools:create` - Start PRD creation workflow

Agents:
- `interview-agent` - Conducts adaptive requirement gathering interviews
- `research-agent` - Researches technical docs, best practices, and domain knowledge

### dx-tools
Location: `plugins/dx-tools/`

Developer tools for Git workflows, Python package management, and release automation.

Commands:
- `/dx-tools:release [version]` - Python package release workflow
- `/dx-tools:git-commit` - Stage and commit with conventional commit message
- `/dx-tools:git-push` - Push to remote with automatic rebase on conflict
- `/dx-tools:bump-plugin-version` - Bump plugin version in this repository

Skills:
- `git-workflow` - Routes git operations based on intent ("commit", "push", "ship it")
- `changelog-format` - Keep a Changelog format guidelines

Agents:
- `changelog-agent` - Analyzes git history and updates CHANGELOG.md

## Development Guidelines

- Plugins follow the Claude Code plugin structure with `.claude-plugin/plugin.json` manifest
- Use auto-discovery for commands, agents, and skills
- Document all commands and features in plugin README files
- Follow Conventional Commits for commit messages
- Keep CHANGELOG.md updated using the changelog-agent
