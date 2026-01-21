# Claude Code Plugins Directory

A collection of Claude Code plugins for development tools, productivity, and MCP integrations.

## Plugins

### prd-generator

Generate Product Requirements Documents through an interactive interview-based workflow.

**Command:**
- `/prd-generator:create` - Start the PRD creation workflow

**Features:**
- **Depth Levels**: Choose from high-level overview, detailed specifications, or full technical documentation
- **Adaptive Interviews**: Questions adjust based on your responses and selected depth
- **On-Demand Research**: Research technical docs, best practices, competitive landscape, and compliance requirements during interviews
- **Codebase Integration**: For "new feature" PRDs, the agent can explore your existing code
- **Pre-compilation Review**: Summary presented for confirmation before generating the final PRD
- **Configurable Output**: Customize output path via `.claude/prd-generator.local.md`

**Depth Options:**
| Level | Description |
|-------|-------------|
| High-level overview | Executive summary with key features and goals (2-3 interview rounds) |
| Detailed specifications | Standard PRD with acceptance criteria and phases (3-4 rounds) |
| Full technical documentation | Comprehensive specs with APIs and data models (4-5 rounds) |

---

### dx-tools

Developer tools for Python package management and release workflows.

**Command:**
- `/dx-tools:release [version]` - Prepare and execute a Python package release

**Features:**
- **Pre-flight Checks**: Verifies clean main branch before proceeding
- **Automated Verification**: Runs tests, linting, and build verification
- **Semantic Versioning**: Calculates version bump from changelog entries
- **Changelog Management**: Updates CHANGELOG.md following Keep a Changelog format
- **Git Integration**: Commits changelog and creates annotated tags

**Workflow Steps:**
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

Spec Driven Development document management plugin. Conducts dynamic interviews to generate PRDs, Tech Specs, and Design Specs optimized for AI coding agents.

**Task Management Commands:**
- `/analyze <spec-document>` - Analyze a specification and generate a structured task list
- `/status [project-name]` - Show task list summary and completion metrics
- `/next [count] [project-name]` - Suggest the next best tasks to work on
- `/complete <task-id>` - Mark a task as complete and show next recommended tasks
- `/block <task-id> --reason "..."` - Mark a task as blocked with a reason
- `/show <task-id>` - Display detailed information for a specific task
- `/update <spec-document>` - Re-analyze specification and update existing task list
- `/export [format] [project-name]` - Export task list (json, markdown, csv)

**Context Window Management Commands:**
- `/context-groups [project-name]` - Generate context window-aware task groups for AI coding agents
- `/next-group [project-name]` - Get the next context group ready for execution
- `/show-group <group-id>` - Display detailed information for a specific context group

## Installation

Add this plugin directory to your Claude Code configuration:

```bash
claude plugins add sequenzia/claude-plugins
```

Or install individual plugins:

```bash
claude plugins add sequenzia/claude-plugins/plugins/prd-generator
claude plugins add sequenzia/claude-plugins/plugins/dx-tools
claude plugins add sequenzia/claude-plugins/plugins/task-manager
```

## License

MIT
