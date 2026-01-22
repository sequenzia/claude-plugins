# Claude Code Plugins Directory

A collection of Claude Code plugins for development tools, productivity, and workflow automation.

## Plugins

### prd-tools

Generate Product Requirements Documents through an interactive interview-based workflow.

**Commands:**
- `/prd-tools:create` - Start the PRD creation workflow

**Features:**
- **Depth Levels**: Choose from high-level overview, detailed specifications, or full technical documentation
- **Adaptive Interviews**: Questions adjust based on your responses and selected depth
- **On-Demand Research**: Research technical docs, best practices, competitive landscape, and compliance requirements during interviews
- **Codebase Integration**: For "new feature" PRDs, the agent can explore your existing code
- **Pre-compilation Review**: Summary presented for confirmation before generating the final PRD
- **Configurable Output**: Customize output path via `.claude/prd-tools.local.md`

**Depth Options:**
| Level | Description |
|-------|-------------|
| High-level overview | Executive summary with key features and goals (2-3 interview rounds) |
| Detailed specifications | Standard PRD with acceptance criteria and phases (3-4 rounds) |
| Full technical documentation | Comprehensive specs with APIs and data models (4-5 rounds) |

---

### dx-tools

Developer tools for Git workflows, Python package management, and release automation.

**Commands:**

| Command | Description |
|---------|-------------|
| `/dx-tools:release [version]` | Prepare and execute a Python package release |
| `/dx-tools:git-commit` | Stage all changes and commit with conventional commit message |
| `/dx-tools:git-push` | Push commits to remote with automatic rebase on conflict |
| `/dx-tools:bump-plugin-version` | Bump the version of any plugin in this repository |

**Skills:**
- **git-workflow** - Routes git operations based on user intent ("commit changes", "push to remote", "ship it")
- **changelog-format** - Keep a Changelog format guidelines and best practices

**Agents:**
- **changelog-agent** - Analyzes git history and updates CHANGELOG.md with categorized entries

**Release Workflow:**
| Step | Action |
|------|--------|
| 1 | Pre-flight checks (main branch, clean directory) |
| 2 | Run tests (`uv run pytest`) |
| 3 | Run linting (`ruff check`, `ruff format --check`) |
| 4 | Verify build (`uv build`) |
| 5 | Calculate version from changelog |
| 6 | Update CHANGELOG.md |
| 7 | Commit and push changelog |
| 8 | Create and push version tag |

---

### task-manager

Spec Driven Development plugin for transforming specifications into structured, actionable task lists optimized for AI coding agents.

**Task Management Commands:**
- `/task-manager:analyze <spec-document>` - Analyze a specification and generate a structured task list
- `/task-manager:status [project-name]` - Show task list summary and completion metrics
- `/task-manager:next [count] [project-name]` - Suggest the next best tasks to work on
- `/task-manager:complete <task-id>` - Mark a task as complete and show next recommended tasks
- `/task-manager:block <task-id> --reason "..."` - Mark a task as blocked with a reason
- `/task-manager:show <task-id>` - Display detailed information for a specific task
- `/task-manager:update <spec-document>` - Re-analyze specification and update existing task list
- `/task-manager:export [format] [project-name]` - Export task list (json, markdown, csv)

**Context Window Management Commands:**
- `/task-manager:context-groups [project-name]` - Generate context window-aware task groups for AI coding agents
- `/task-manager:next-group [project-name]` - Get the next context group ready for execution
- `/task-manager:show-group <group-id>` - Display detailed information for a specific context group

## Installation

Add this plugin directory to your Claude Code configuration:

```bash
claude plugins add sequenzia/claude-plugins
```

Or install individual plugins:

```bash
claude plugins add sequenzia/claude-plugins/plugins/prd-tools
claude plugins add sequenzia/claude-plugins/plugins/dx-tools
claude plugins add sequenzia/claude-plugins/plugins/task-manager
```

## License

MIT
