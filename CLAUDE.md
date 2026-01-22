# CLAUDE.md

## Project Overview

This repository contains Claude Code plugins for development tools, productivity, and workflow automation. The plugins extend Claude Code with specialized capabilities for PRD generation, task management, Git workflows, and release automation.

**Repository:** `sequenzia/claude-plugins`
**License:** MIT

## Repository Structure

```
claude-plugins/
├── .claude/                          # Claude Code configuration
│   ├── settings.json                 # Plugin enablement
│   └── settings.local.json           # Local settings
├── .claude-plugin/
│   └── marketplace.json              # Central plugin registry
├── plugins/
│   ├── prd-tools/                    # PRD generation
│   ├── task-manager/                 # Spec-driven task decomposition
│   ├── dx-tools/                     # Git workflows and releases
│   ├── mission-control/              # Simplified task management
│   └── feature-ops/                  # Feature development workflow
├── CLAUDE.md                         # This file
├── README.md                         # User documentation
└── LICENSE                           # MIT License
```

## Plugins

### prd-tools
**Location:** `plugins/prd-tools/`
**Version:** 0.1.1

Generates Product Requirements Documents through an interactive interview-based workflow.

**Commands:**
- `/prd-tools:create` - Start PRD creation workflow

**Agents:**
- `interview-agent` - Conducts adaptive requirement gathering interviews (uses opus model)
- `research-agent` - Researches technical docs, best practices, and domain knowledge

**Skills:**
- `prd-generation` - PRD generation knowledge, templates, and compilation guidance

**Key Files:**
- `references/template-high-level.md` - Executive summary template
- `references/template-detailed.md` - Standard PRD template
- `references/template-full-tech.md` - Comprehensive technical template
- `references/interview-questions.md` - Question inspiration library

**Configuration:** Output path configurable via `.claude/prd-tools.local.md`

---

### task-manager
**Location:** `plugins/task-manager/`
**Version:** 0.1.0

Spec Driven Development plugin that transforms specifications into structured, actionable task lists optimized for AI coding agents.

**Commands:**
- `/task-manager:analyze` - Analyze spec and generate task list
- `/task-manager:status` - Show task summary and metrics
- `/task-manager:next` - Suggest next tasks to work on
- `/task-manager:complete` - Mark task complete
- `/task-manager:block` - Mark task as blocked
- `/task-manager:show` - Show task details
- `/task-manager:update` - Re-analyze spec and update tasks
- `/task-manager:export` - Export task list (json, markdown, csv)
- `/task-manager:context-groups` - Generate context-aware task groups
- `/task-manager:next-group` - Get next context group
- `/task-manager:show-group` - Show context group details

**Agents:**
- `spec-analyzer` - Proactively detects and analyzes spec documents

**Skills:**
- `spec-task-management` - Task decomposition methodology and dependency patterns

**Key Files:**
- `references/task-schema.json` - JSON schema for task lists
- `references/dependency-patterns.md` - Dependency identification patterns
- `references/context-defaults.json` - Context grouping configuration

**Task Properties:**
- Priority: critical, high, medium, low
- Complexity: XS, S, M, L, XL (T-shirt sizing)
- Dependencies: hard, soft, resource types
- Status: not_started, in_progress, blocked, complete, obsolete

---

### dx-tools
**Location:** `plugins/dx-tools/`
**Version:** 0.1.4

Developer tools for Git workflows, Python package management, and release automation.

**Commands:**
- `/dx-tools:release [version]` - Python package release workflow
- `/dx-tools:git-commit` - Stage and commit with conventional commit message
- `/dx-tools:git-push` - Push to remote with automatic rebase on conflict
- `/dx-tools:bump-plugin-version` - Bump plugin version in this repository

**Agents:**
- `changelog-agent` - Analyzes git history and updates CHANGELOG.md

**Skills:**
- `git-workflow` - Routes git operations based on intent ("commit", "push", "ship it")
- `changelog-format` - Keep a Changelog format guidelines

**Key Files:**
- `references/entry-examples.md` - Changelog entry examples

**Release Pipeline (9 steps):**
1. Pre-flight checks (main branch, clean directory)
2. Run tests (`uv run pytest`)
3. Run linting (`ruff check`, `ruff format --check`)
4. Verify build (`uv build`)
5. Check CHANGELOG.md is updated
6. Calculate version from changelog
7. Update CHANGELOG.md with version section
8. Commit changelog and push
9. Create and push version tag

---

### mission-control
**Location:** `plugins/mission-control/`
**Version:** 0.1.2

Simplified task management with mission-based organization.

**Commands:**
- `/mission-control:generate` - Create task list from specification
- `/mission-control:status` - Show task summary and metrics
- `/mission-control:next` - Recommend next tasks
- `/mission-control:complete` - Mark task complete
- `/mission-control:show` - Show task details

**Agents:**
- `spec-analyzer` - Analyzes specs and generates mission-based task lists

**Skills:**
- `simple-task-management` - Mission-centric task decomposition

**Storage:** Tasks stored in `missions/<mission-slug>/<project-name>.tasks.json`

---

### feature-ops
**Location:** `plugins/feature-ops/`
**Version:** 0.1.0

Comprehensive feature development workflow with specialized agents for codebase exploration, architecture design, and quality review.

**Commands:**
- `/feature-ops <description>` - Run feature development workflow (thorough mode)
- `/feature-ops --quick <description>` - Run feature development workflow (quick mode)

**Agents:**
- `code-explorer` - Traces execution paths, maps architecture (Sonnet)
- `code-architect` - Designs implementation blueprints (Opus)
- `code-reviewer` - Reviews with confidence-based filtering ≥80 (Opus)

**Skills:**
- `architecture-patterns` - MVC, event-driven, microservices, CQRS patterns
- `code-quality` - SOLID principles, DRY, testing strategies
- `language-patterns` - TypeScript, Python, React patterns
- `project-conventions` - Discovering project-specific conventions

**Key Files:**
- `references/adr-template.md` - Architecture Decision Record template
- `references/changelog-template.md` - Changelog entry template

**Workflow Phases:**
1. Discovery - Understand requirements
2. Codebase Exploration - Map relevant code (loads: project-conventions, language-patterns)
3. Clarifying Questions - Resolve ambiguities
4. Architecture Design - Design approach (loads: architecture-patterns, language-patterns)
5. Implementation - Build with explicit approval
6. Quality Review - Review code (loads: code-quality)
7. Summary - Document accomplishments

**Modes:**
- Thorough (default): 2-3 parallel agents at phases 2, 4, 6
- Quick (`--quick`): 1 agent per phase

**Artifacts:**
- ADR saved to `docs/adr/NNNN-feature-slug.md`
- Changelog entry saved to `docs/changelog/YYYY-MM-DD-feature-slug.md`

---

## Development Guidelines

### Plugin Structure

All plugins follow the Claude Code plugin structure with auto-discovery:

```
plugins/{plugin-name}/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest (required)
├── commands/                 # Slash commands (auto-discovered)
│   └── *.md                  # Command definitions with YAML frontmatter
├── agents/                   # Subagents (auto-discovered)
│   └── *.md                  # Agent definitions with system prompts
├── skills/                   # Skills (auto-discovered)
│   └── *.md                  # Skill definitions with knowledge content
├── references/               # Reference files (JSON schemas, examples)
└── README.md                 # Plugin documentation
```

### Plugin Manifest (plugin.json)

Required fields:
```json
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "Brief description",
  "commands": "auto",
  "agents": "auto",
  "skills": "auto"
}
```

### Command Frontmatter

Commands use YAML frontmatter for metadata:
```yaml
---
description: Short description for help text
allowed-tools:
  - Read
  - Write
  - Bash
arguments:
  - name: arg-name
    description: Argument description
    required: true
---
```

### Agent Frontmatter

Agents use YAML frontmatter for configuration:
```yaml
---
description: When to use this agent
tools:
  - Read
  - Write
  - AskUserQuestion
model: opus  # optional: sonnet (default), opus, haiku
---
```

### Skill Frontmatter

Skills use YAML frontmatter for trigger configuration:
```yaml
---
description: When this skill activates
---
```

### Conventional Commits

Follow Conventional Commits format for all commit messages:
- `feat(scope): description` - New features
- `fix(scope): description` - Bug fixes
- `docs(scope): description` - Documentation changes
- `refactor(scope): description` - Code refactoring
- `test(scope): description` - Test additions/changes
- `chore(scope): description` - Maintenance tasks

Use `/dx-tools:git-commit` to auto-generate conventional commit messages.

### Changelog Management

Keep CHANGELOG.md updated following Keep a Changelog format:
- Use the `changelog-agent` to analyze git history and generate entries
- Categories in order: Added, Changed, Deprecated, Removed, Fixed, Security
- Write entries in imperative mood ("Add feature" not "Added feature")
- Focus on user-facing changes

### Testing Plugins

When developing plugins:
1. Test commands manually in the Claude Code CLI
2. Verify agent prompts produce expected behavior
3. Check skill triggers activate appropriately
4. Validate JSON schemas in reference files

### Marketplace Registration

Update `.claude-plugin/marketplace.json` when adding/modifying plugins:
```json
{
  "plugins": [
    {
      "name": "plugin-name",
      "version": "0.1.0",
      "description": "Description",
      "path": "plugins/plugin-name",
      "owner": "Author Name",
      "homepage": "https://github.com/...",
      "categories": ["category"]
    }
  ]
}
```

## Plugin Workflow Integration

The plugins are designed for a natural development workflow:

```
1. PRD Creation (prd-tools)
   ↓
2. Task Generation (task-manager or mission-control)
   ↓
3. Feature Development (feature-ops: explore, design, implement, review)
   ↓
4. Git Operations (dx-tools: commit, push)
   ↓
5. Release (dx-tools: changelog, version, tag)
```

## Quick Reference

| Task | Command |
|------|---------|
| Create a PRD | `/prd-tools:create` |
| Analyze spec into tasks | `/task-manager:analyze <spec>` |
| See task status | `/task-manager:status` |
| Get next task | `/task-manager:next` |
| Complete a task | `/task-manager:complete <id>` |
| Develop a feature (thorough) | `/feature-ops <description>` |
| Develop a feature (quick) | `/feature-ops --quick <description>` |
| Commit changes | `/dx-tools:git-commit` |
| Push to remote | `/dx-tools:git-push` |
| Release package | `/dx-tools:release` |
| Bump plugin version | `/dx-tools:bump-plugin-version` |
