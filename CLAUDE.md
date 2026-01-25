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
│   ├── prd-tools/                    # PRD generation and analysis
│   ├── task-manager/                 # Spec-driven task decomposition
│   ├── dev-tools/                    # Feature development, Git workflows, and releases
│   ├── mission-control/              # Simplified task management
│   └── ralph-mission/                # Mission-driven autonomous loops
├── CLAUDE.md                         # This file
├── README.md                         # User documentation
└── LICENSE                           # MIT License
```

## Plugins

### prd-tools
**Location:** `plugins/prd-tools/`
**Version:** 0.3.1

Generates and analyzes Product Requirements Documents through interactive workflows, and transforms PRDs into Claude Code native Tasks.

**Commands:**
- `/prd-tools:create` - Start PRD creation workflow
- `/prd-tools:analyze <path>` - Analyze existing PRD for quality issues
- `/prd-tools:create-tasks <path>` - Generate Claude Code native Tasks from an existing PRD

**Agents:**
- `interview-agent` - Conducts adaptive interviews with proactive recommendations (uses opus model)
- `research-agent` - Researches technical docs, best practices, and domain knowledge
- `prd-analyzer` - Analyzes PRDs for quality issues with interactive resolution (uses opus model)
- `task-generator` - Transforms PRDs into native Tasks with dependencies (uses opus model)

**Skills:**
- `prd-generation` - PRD generation knowledge, templates, and compilation guidance
- `prd-analysis` - PRD analysis knowledge, criteria, and common issue patterns
- `task-generation` - Task decomposition patterns, dependency inference, and metadata standards

**Key Files:**
- `skills/prd-generation/references/template-*.md` - PRD templates (high-level, detailed, full-tech)
- `skills/prd-generation/references/interview-questions.md` - Question inspiration library
- `skills/prd-generation/references/recommendation-triggers.md` - Proactive recommendation trigger patterns
- `skills/prd-generation/references/recommendation-format.md` - Recommendation presentation templates
- `skills/prd-analysis/references/analysis-criteria.md` - Depth-specific analysis checklists
- `skills/prd-analysis/references/common-issues.md` - Issue pattern library
- `skills/prd-analysis/references/report-template.md` - Analysis report format
- `skills/task-generation/references/decomposition-patterns.md` - Feature decomposition patterns
- `skills/task-generation/references/dependency-inference.md` - Dependency inference rules

**Interview Features:**
- Proactive recommendations based on detected trigger patterns (auth, scale, security, etc.)
- Inline insights during rounds with Accept/Tell me more/Skip options
- Dedicated recommendations round before summary (for detailed/full-tech depth)
- Proactive research for compliance topics (GDPR, HIPAA, PCI, WCAG)
- Agent Recommendations section clearly distinguished from user requirements

**Analysis Features:**
- Depth-aware analysis (respects high-level/detailed/full-tech)
- Four finding categories: Inconsistencies, Missing Information, Ambiguities, Structure Issues
- Three severity levels: Critical, Warning, Suggestion
- Interactive update mode with Apply/Modify/Skip options
- Progress tracking: `Finding X/Y (N resolved, M skipped)`
- Report saved alongside PRD as `{name}.analysis.md`

**Task Generation Features:**
- Creates Claude Code native Tasks (TaskCreate/TaskUpdate)
- Depth-aware granularity (1-2 tasks for high-level, 5-10 for full-tech)
- Automatic dependency inference from layer relationships
- Priority mapping from PRD (P0-P3 → critical/high/medium/low)
- Complexity estimation (XS/S/M/L/XL)
- Merge mode preserves completed tasks on re-run
- Task metadata includes source PRD section references

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

### dev-tools
**Location:** `plugins/dev-tools/`
**Version:** 0.2.3

Developer tools for feature development, Git workflows, Python package management, and release automation.

**Commands:**
- `/dev-tools:feature-dev <description>` - Feature development workflow (7 phases)
- `/dev-tools:release [version]` - Python package release workflow
- `/dev-tools:git-commit` - Stage and commit with conventional commit message
- `/dev-tools:git-push` - Push to remote with automatic rebase on conflict
- `/dev-tools:bump-plugin-version` - Bump plugin version in this repository

**Agents:**
- `code-explorer` - Explores codebases to find relevant files and map architecture (Sonnet)
- `code-architect` - Designs implementation blueprints with trade-off analysis (Opus)
- `code-reviewer` - Reviews for correctness, security, maintainability with confidence scores (Opus)
- `changelog-agent` - Analyzes git history and updates CHANGELOG.md

**Skills:**
- `architecture-patterns` - MVC, event-driven, microservices, CQRS patterns
- `code-quality` - SOLID principles, DRY, testing strategies
- `language-patterns` - TypeScript, Python, React patterns
- `project-conventions` - Discovering project-specific conventions
- `git-workflow` - Routes git operations based on intent ("commit", "push", "ship it")
- `changelog-format` - Keep a Changelog format guidelines

**Key Files:**
- `references/adr-template.md` - Architecture Decision Record template
- `references/feature-changelog-template.md` - Feature changelog entry template
- `references/entry-examples.md` - Changelog entry examples

**Feature Development Workflow (7 phases):**
1. Discovery - Understand requirements
2. Codebase Exploration - Map relevant code (loads: project-conventions, language-patterns)
3. Clarifying Questions - Resolve ambiguities
4. Architecture Design - Design approach (loads: architecture-patterns, language-patterns)
5. Implementation - Build with explicit approval
6. Quality Review - Review code (loads: code-quality)
7. Summary - Document accomplishments

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

### ralph-mission
**Location:** `plugins/ralph-mission/`
**Version:** 0.1.0

Mission-driven autonomous loop that iterates through mission-control tasks until all are complete.

**Commands:**
- `/ralph-mission <mission-path>` - Start autonomous task loop
- `/ralph-mission:status` - Show loop progress
- `/ralph-mission:cancel` - Cancel active loop

**Hooks:**
- `Stop` - Core loop engine that detects task completion and selects next task

**Task Selection (Priority Scoring):**
```
score = (priority × 100) + (blocks × 50) + complexity_bonus
```
- Priority: critical=4, high=3, medium=2, low=1
- Complexity bonus: XS=+15, S=+10, M=+5, L=0, XL=-5

**Completion Detection:**
- Reads task status from tasks.json file
- Claude updates status to "complete" when task is done
- Hook detects the change and selects next task

**Progress Tracking:**
- Learnings logged to `progress.txt` in mission directory
- Git commits required per task for rollback points

**Safety Features:**
- Max iterations limit (default: 50)
- Max failed attempts per task (default: 3)
- Dependency-aware task selection

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

Use `/dev-tools:git-commit` to auto-generate conventional commit messages.

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
1. PRD Creation (prd-tools:create)
   ↓
2. PRD Analysis (prd-tools:analyze) [optional]
   ↓
3. Task Generation (choose one):
   a. Native Tasks: prd-tools:create-tasks (Claude Code TaskCreate/TaskUpdate)
   b. Mission Tasks: task-manager or mission-control (JSON file)
   ↓
4. Task Execution (choose one):
   a. Manual: dev-tools:feature-dev for each task
   b. Autonomous: ralph-mission for mission-control tasks
   ↓
5. Git Operations (dev-tools: commit, push)
   ↓
6. Release (dev-tools: changelog, version, tag)
```

**Native Tasks Mode:** Use `prd-tools:create-tasks` to generate Claude Code native Tasks with dependencies. View with `TaskList`, track with `TaskGet`/`TaskUpdate`.

**Autonomous Mode:** Use `ralph-mission` to automatically iterate through all tasks from a mission-control tasks.json file until complete.

## Quick Reference

| Task | Command |
|------|---------|
| Create a PRD | `/prd-tools:create` |
| Analyze a PRD | `/prd-tools:analyze <path>` |
| Generate native Tasks from PRD | `/prd-tools:create-tasks <path>` |
| Analyze spec into tasks | `/task-manager:analyze <spec>` |
| See task status | `/task-manager:status` |
| Get next task | `/task-manager:next` |
| Complete a task | `/task-manager:complete <id>` |
| Develop a feature | `/dev-tools:feature-dev <description>` |
| Commit changes | `/dev-tools:git-commit` |
| Push to remote | `/dev-tools:git-push` |
| Release package | `/dev-tools:release` |
| Bump plugin version | `/dev-tools:bump-plugin-version` |
| Start autonomous loop | `/ralph-mission <mission-path>` |
| Check loop progress | `/ralph-mission:status` |
| Cancel loop | `/ralph-mission:cancel` |
