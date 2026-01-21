# dx-tools

Developer tools for Python package management and release workflows.

## Installation

Add the plugin to your Claude Code configuration:

```bash
claude mcp add-json dx-tools '{"type": "claude-plugin", "path": "/path/to/dx-tools"}'
```

Or symlink to your Claude plugins directory.

## Commands

### `/dx-tools:release` - Python Release Manager

Automates the complete pre-release workflow for Python packages using `uv` and `ruff`.

#### Usage

```bash
/dx-tools:release           # Calculate version from changelog
/dx-tools:release 1.0.0     # Use specific version override
```

#### Prerequisites

Your project must have:
- `pyproject.toml` with project configuration
- `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/) format
- `uv` package manager installed
- `ruff` linter configured
- `pytest` for running tests

#### Workflow Steps

1. **Pre-flight Checks** - Verify on `main` branch with clean working directory
2. **Run Tests** - Execute `uv run pytest`
3. **Run Linting** - Execute `uv run ruff check` and `uv run ruff format --check`
4. **Verify Build** - Execute `uv build`
5. **Calculate Version** - Analyze changelog entries for semantic version bump
6. **Update CHANGELOG.md** - Move unreleased items to new version section
7. **Commit Changelog** - Stage, commit, and push changelog updates
8. **Create and Push Tag** - Create annotated tag and push to remote

#### Version Calculation

The command analyzes your `[Unreleased]` changelog section:

| Change Type | Bump |
|-------------|------|
| `### Removed` (v1.0.0+) | MAJOR |
| `### Removed` (v0.x.x) | MINOR |
| `### Added` or `### Changed` | MINOR |
| `### Fixed`, `### Security`, `### Deprecated` only | PATCH |

#### Example Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature description

### Fixed
- Bug fix description

## [0.1.0] - 2024-01-15

### Added
- Initial release

[Unreleased]: https://github.com/user/repo/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/user/repo/releases/tag/v0.1.0
```

#### Repository URL Detection

The command reads your repository URL from `pyproject.toml`:

```toml
[project.urls]
Repository = "https://github.com/user/repo"
```

Supported keys: `Repository`, `repository`, `Source`, `source`, `Homepage`, `homepage`

#### Error Handling

The command fails fast at each verification step. If a step fails after version confirmation, it provides rollback commands:

```bash
git checkout CHANGELOG.md           # Revert changelog changes
git tag -d v{version}               # Delete local tag
git push origin :refs/tags/v{version}  # Delete remote tag
```

## Agents

### Changelog Agent

Analyzes git history and updates CHANGELOG.md with entries for the `[Unreleased]` section.

#### When to Use

- Before a release, to document recent changes
- After completing a feature branch, to add changelog entries
- To catch up on changelog entries for accumulated commits

#### What It Does

1. Reads CHANGELOG.md to find the last release version
2. Gets git commits since the last release tag
3. Categorizes changes based on conventional commit prefixes:
   - `feat:` → Added
   - `fix:` → Fixed
   - `refactor:`, `change:`, `perf:` → Changed
   - `security:` → Security
   - Skips: `docs:`, `chore:`, `test:`, `ci:`, `style:`, `build:`
4. Drafts well-formatted entries following Keep a Changelog guidelines
5. Presents entries for your review and approval
6. Updates CHANGELOG.md with approved entries

#### Example Usage

Simply ask Claude to update the changelog:

```
Update the changelog with recent commits
```

```
Add changelog entries for the work since the last release
```

```
What changes should go in the changelog?
```

The agent will analyze your commits and present suggested entries for approval before making any changes.

## Requirements

- Python 3.8+
- [uv](https://github.com/astral-sh/uv) package manager
- [ruff](https://github.com/astral-sh/ruff) linter
- Git repository with remote configured

## License

MIT
