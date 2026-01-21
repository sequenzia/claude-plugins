# CLAUDE.md

## Project Overview

This repository contains Claude Code plugins for development tools and productivity.

## Plugins

### task-manager
Location: `plugins/task-manager/`

Spec Driven Development document management. Generates and manages PRDs, Tech Specs, and Design Specs with task tracking capabilities.

### prd-generator
Location: `plugins/prd-generator/`

Generates Product Requirements Documents through an interactive interview-based workflow. Features:
- Three depth levels: high-level overview, detailed specifications, full technical documentation
- Adaptive interview process that adjusts based on user responses
- Codebase exploration for "new feature" type PRDs
- Configurable output via `.claude/prd-generator.local.md`

Command: `/prd-generator:create`

## Development Guidelines

- Plugins follow the Claude Code plugin structure with `.claude-plugin/plugin.json` manifest
- Use auto-discovery for commands, agents, and skills
- Document all commands and features in plugin README files
