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
claude plugins add sequenzia/claude-plugins/plugins/dev-tools
```

---

## Plugins Overview

| Plugin | Purpose | Commands | Agents | Skills |
|--------|---------|----------|--------|--------|
| [prd-tools](#prd-tools) | PRD generation through interactive interviews | 3 | 4 | 3 |
| [dev-tools](#dev-tools) | Feature development, Git workflows, and release automation | 6 | 6 | 6 |

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

## dev-tools

Developer tools for Git workflows, Python package management, and release automation. Provides streamlined commands for common development operations.

**Version:** 0.1.4

### Commands

| Command | Description |
|---------|-------------|
| `/dev-tools:release [version]` | Prepare and execute a Python package release with verification steps |
| `/dev-tools:git-commit` | Stage all changes and commit with conventional commit message |
| `/dev-tools:git-push` | Push commits to remote with automatic rebase on conflict |
| `/dev-tools:bump-plugin-version` | Bump the version of any plugin in this repository |

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

## Plugin Interconnections

The plugins are designed to work together in a natural development workflow:

```
PRD Creation → Task Generation → Task Execution → Release
     ↓               ↓                 ↓              ↓
 prd-tools     prd-tools:        dev-tools:       dev-tools
              create-tasks       feature-dev      (release)
```

1. **prd-tools**: Create PRDs through interactive interviews, analyze for quality, generate native Tasks
2. **dev-tools**: Implement features, manage Git workflows, automate releases

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
