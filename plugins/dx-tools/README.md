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

## Requirements

- Python 3.8+
- [uv](https://github.com/astral-sh/uv) package manager
- [ruff](https://github.com/astral-sh/ruff) linter
- Git repository with remote configured

## License

MIT
