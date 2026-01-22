# Claude Code Plugins Directory

A collection of Claude Code plugins for development tools, productivity, and workflow automation. These plugins extend Claude Code with specialized capabilities for PRD generation, task management, Git workflows, and release automation.

## Quick Install

Add the full plugin collection:

```bash
claude plugins add sequenzia/claude-plugins
```

Or install individual plugins:

```bash
claude plugins add sequenzia/claude-plugins/plugins/prd-tools
claude plugins add sequenzia/claude-plugins/plugins/task-manager
claude plugins add sequenzia/claude-plugins/plugins/dx-tools
claude plugins add sequenzia/claude-plugins/plugins/mission-control
claude plugins add sequenzia/claude-plugins/plugins/feature-ops
```

---

## Plugins Overview

| Plugin | Purpose | Commands | Agents | Skills |
|--------|---------|----------|--------|--------|
| [prd-tools](#prd-tools) | PRD generation through interactive interviews | 1 | 2 | 1 |
| [task-manager](#task-manager) | Spec-driven task decomposition with context management | 11 | 1 | 1 |
| [dx-tools](#dx-tools) | Git workflows and Python release automation | 4 | 1 | 2 |
| [mission-control](#mission-control) | Simplified mission-based task management | 5 | 1 | 1 |
| [feature-ops](#feature-ops) | Feature development workflow with exploration, architecture, and review | 1 | 3 | 4 |

---

## prd-tools

Generate Product Requirements Documents through an interactive interview-based workflow with depth-aware templates and on-demand research capabilities.

**Version:** 0.1.1

### Commands

| Command | Description |
|---------|-------------|
| `/prd-tools:create` | Start the PRD creation workflow |

### Features

- **Depth Levels**: Choose the appropriate level of detail for your PRD:

| Level | Description | Interview Rounds |
|-------|-------------|------------------|
| High-level overview | Executive summary with key features and goals | 2-3 rounds, 6-10 questions |
| Detailed specifications | Standard PRD with acceptance criteria and phases | 3-4 rounds, 12-18 questions |
| Full technical documentation | Comprehensive specs with APIs and data models | 4-5 rounds, 18-25 questions |

- **Adaptive Interviews**: Questions adjust based on your responses and selected depth
- **On-Demand Research**: Research technical docs, best practices, competitive landscape, and compliance requirements during interviews
- **Codebase Integration**: For "new feature" PRDs, the agent explores your existing code to understand context
- **Pre-compilation Review**: Summary presented for confirmation before generating the final PRD
- **Configurable Output**: Customize output path via `.claude/prd-tools.local.md`

### Agents

| Agent | Description |
|-------|-------------|
| `interview-agent` | Conducts adaptive requirement gathering interviews with mandatory user interaction |
| `research-agent` | Researches technical documentation, domain knowledge, and competitive landscape |

### Configuration

Create `.claude/prd-tools.local.md` to configure output settings:

```yaml
---
output_directory: docs/prds
---
```

---

## task-manager

Spec Driven Development plugin that transforms specifications into structured, actionable task lists optimized for AI coding agents. Features comprehensive dependency tracking and context window management.

**Version:** 0.1.0

### Commands

**Task Management:**

| Command | Description |
|---------|-------------|
| `/task-manager:analyze <spec-document>` | Analyze a specification and generate a structured task list |
| `/task-manager:status [project-name]` | Show task list summary and completion metrics |
| `/task-manager:next [count] [project-name]` | Suggest the next best tasks to work on |
| `/task-manager:complete <task-id>` | Mark a task as complete and show next recommended tasks |
| `/task-manager:block <task-id> --reason "..."` | Mark a task as blocked with a reason |
| `/task-manager:show <task-id>` | Display detailed information for a specific task |
| `/task-manager:update <spec-document>` | Re-analyze specification and update existing task list |
| `/task-manager:export [format] [project-name]` | Export task list (json, markdown, csv) |

**Context Window Management:**

| Command | Description |
|---------|-------------|
| `/task-manager:context-groups [project-name]` | Generate context window-aware task groups for AI coding agents |
| `/task-manager:next-group [project-name]` | Get the next context group ready for execution |
| `/task-manager:show-group <group-id>` | Display detailed information for a specific context group |

### Features

- **Task Decomposition**: Breaks specifications into atomic, actionable tasks
- **Dependency Tracking**: Hard, soft, and resource dependencies with automatic blocking detection
- **Priority Levels**: Critical, high, medium, low with weighted scoring
- **Complexity Estimation**: T-shirt sizing (XS, S, M, L, XL) for effort estimation
- **Context Grouping**: Token-based grouping for optimal AI agent handoffs
- **Execution Phases**: Organizes tasks into logical implementation phases
- **Progress Tracking**: Real-time completion metrics and status updates

### Task Status Lifecycle

```
not_started → in_progress → complete
                    ↓
                 blocked → (resolve blocker) → in_progress
                    ↓
                 obsolete
```

### Agents

| Agent | Description |
|-------|-------------|
| `spec-analyzer` | Proactively detects and analyzes spec documents by filename patterns |

---

## dx-tools

Developer tools for Git workflows, Python package management, and release automation. Provides streamlined commands for common development operations.

**Version:** 0.1.4

### Commands

| Command | Description |
|---------|-------------|
| `/dx-tools:release [version]` | Prepare and execute a Python package release with verification steps |
| `/dx-tools:git-commit` | Stage all changes and commit with conventional commit message |
| `/dx-tools:git-push` | Push commits to remote with automatic rebase on conflict |
| `/dx-tools:bump-plugin-version` | Bump the version of any plugin in this repository |

### Release Workflow

The release command executes a comprehensive 9-step verification pipeline:

| Step | Action |
|------|--------|
| 1 | Pre-flight checks (main branch, clean directory) |
| 2 | Run tests (`uv run pytest`) |
| 3 | Run linting (`ruff check`, `ruff format --check`) |
| 4 | Verify build (`uv build`) |
| 5 | Check CHANGELOG.md is updated |
| 6 | Calculate version from changelog (semantic versioning) |
| 7 | Update CHANGELOG.md with version section |
| 8 | Commit changelog and push |
| 9 | Create and push version tag |

### Skills

| Skill | Description | Triggers |
|-------|-------------|----------|
| `git-workflow` | Routes git operations based on user intent | "commit changes", "push changes", "ship it" |
| `changelog-format` | Keep a Changelog format guidelines | Changelog-related questions |

### Agents

| Agent | Description |
|-------|-------------|
| `changelog-agent` | Analyzes git history and updates CHANGELOG.md with categorized entries |

### Changelog Categories

The changelog-agent organizes entries following Keep a Changelog format:

1. **Added** - New features
2. **Changed** - Changes to existing functionality
3. **Deprecated** - Soon-to-be removed features
4. **Removed** - Removed features
5. **Fixed** - Bug fixes
6. **Security** - Vulnerability fixes

---

## mission-control

Simplified task management for coding agents with mission-based organization. Generates task lists from specifications with a streamlined dependency model.

**Version:** 0.1.2

### Commands

| Command | Description |
|---------|-------------|
| `/mission-control:generate <mission-name> <spec-document>` | Create structured task list from specification |
| `/mission-control:status` | Show task list summary and completion metrics |
| `/mission-control:next [count]` | Recommend next tasks to work on |
| `/mission-control:complete <task-id>` | Mark task as complete and show newly unblocked tasks |
| `/mission-control:show <task-id>` | Display detailed information for specific task |

### Features

- **Mission-Centric Organization**: Tasks grouped under mission directories (`missions/<mission-slug>/`)
- **Simplified Dependencies**: Focuses on blocking dependencies only
- **Priority Scoring**: Algorithm weighs priority, blocking impact, and complexity
- **Progress Tracking**: Real-time completion percentages and phase progress
- **Execution Phases**: Logical grouping for implementation order

### Task Scoring Algorithm

```
score = priority_weight * 100 + blocking_weight * 50 + complexity_bonus
```

### Agents

| Agent | Description |
|-------|-------------|
| `spec-analyzer` | Proactively analyzes specs and generates mission-based task lists |

---

## feature-ops

Comprehensive feature development workflow with specialized agents for codebase exploration, architecture design, and quality review. Supports parallel agent execution in thorough mode or streamlined single-agent execution in quick mode.

**Version:** 0.1.0

### Commands

| Command | Description |
|---------|-------------|
| `/feature-ops <description>` | Run feature development workflow (thorough mode) |
| `/feature-ops --quick <description>` | Run feature development workflow (quick mode) |

### Workflow Phases

The plugin guides you through 7 structured phases:

| Phase | Description | Skills Loaded |
|-------|-------------|---------------|
| 1. Discovery | Understand requirements, create task plan | - |
| 2. Codebase Exploration | Map relevant code areas | `project-conventions`, `language-patterns` |
| 3. Clarifying Questions | Resolve ambiguities before designing | - |
| 4. Architecture Design | Design implementation approach | `architecture-patterns`, `language-patterns` |
| 5. Implementation | Build the feature with explicit approval | - |
| 6. Quality Review | Review for issues with confidence scoring | `code-quality` |
| 7. Summary | Document accomplishments | - |

### Mode Comparison

| Aspect | Thorough (default) | Quick (`--quick`) |
|--------|-------------------|-------------------|
| Exploration agents | 2-3 parallel | 1 |
| Architecture agents | 2-3 parallel (Opus) | 1 (Opus) |
| Review agents | 3 parallel (Opus) | 1 (Opus) |
| Best for | Complex features, unfamiliar codebases | Simple features, familiar codebases |

### Agents

| Agent | Model | Description |
|-------|-------|-------------|
| `code-explorer` | Sonnet | Traces execution paths, maps architecture, identifies patterns |
| `code-architect` | Opus | Designs implementation blueprints with multiple approaches |
| `code-reviewer` | Opus | Reviews code with confidence-based filtering (≥80 threshold) |

### Skills

| Skill | Description |
|-------|-------------|
| `architecture-patterns` | MVC, event-driven, microservices, CQRS, hexagonal architecture |
| `code-quality` | SOLID principles, DRY, testing strategies, code smells |
| `language-patterns` | TypeScript, Python, React patterns and best practices |
| `project-conventions` | Guidance for discovering project-specific conventions |

### Artifacts

The workflow generates two artifacts:

| Artifact | Phase | Location |
|----------|-------|----------|
| Architecture Decision Record (ADR) | Phase 4 | `docs/adr/NNNN-feature-slug.md` |
| Changelog Entry | Phase 7 | `docs/changelog/YYYY-MM-DD-feature-slug.md` |

---

## Plugin Interconnections

The plugins are designed to work together in a natural development workflow:

```
PRD Creation → Task Generation → Feature Development → Release
     ↓               ↓                   ↓                ↓
 prd-tools    task-manager/        feature-ops       dx-tools
              mission-control    (explore, design,   (release)
                                 implement, review)
```

1. **prd-tools → task-manager**: PRDs generated by prd-tools can be analyzed to create task lists
2. **task-manager → feature-ops**: Individual tasks implemented using the feature-ops workflow
3. **feature-ops → dx-tools**: Completed features committed using git-commit, changelog updated
4. **dx-tools**: Full release pipeline with changelog, versioning, and tagging

---

## Development

### Plugin Structure

All plugins follow the Claude Code plugin structure:

```
plugins/{plugin-name}/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/                 # Slash commands
├── agents/                   # Subagents
├── skills/                   # Skills/routing rules
├── references/               # Reference files and schemas
└── README.md                 # Plugin documentation
```

### Contributing

1. Follow the existing plugin structure patterns
2. Use Conventional Commits for commit messages
3. Update CHANGELOG.md using the changelog-agent
4. Document all commands and features in plugin README files

---

## License

MIT
