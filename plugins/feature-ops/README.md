# feature-ops

A structured feature development workflow plugin for Claude Code. Guides you through exploration, architecture design, implementation, and review phases with configurable depth.

## Installation

This plugin is part of the `sequenzia/claude-plugins` repository. Enable it in your Claude Code settings.

## Usage

```bash
# Default (thorough) mode - full parallel agent workflow
/feature-ops Add user authentication with JWT

# Quick mode - single agent per phase, faster execution
/feature-ops --quick Fix the login button alignment
```

## Features

- **7-phase workflow**: Discovery, Exploration, Questions, Architecture, Implementation, Review, Summary
- **Parallel agents**: Multiple specialized agents work concurrently (in thorough mode)
- **Skills integration**: Auto-loads relevant knowledge at each phase
- **Artifact generation**: Creates ADRs and changelog entries automatically
- **Two modes**: Thorough (default) and Quick for different needs

## Workflow Phases

### Phase 1: Discovery
Understand the feature requirements and create a task plan.

### Phase 2: Codebase Exploration
**Skills loaded:** `project-conventions`, `language-patterns`

- **Thorough:** 2-3 `code-explorer` agents analyze entry points, data models, and utilities
- **Quick:** 1 `code-explorer` agent performs focused exploration

### Phase 3: Clarifying Questions
Review findings and ask clarifying questions before designing.

### Phase 4: Architecture Design
**Skills loaded:** `architecture-patterns`, `language-patterns`

- **Thorough:** 2-3 `code-architect` agents (Opus) propose different approaches
- **Quick:** 1 `code-architect` agent (Opus) proposes a balanced approach

**Output:** Architecture Decision Record (ADR) saved to `docs/adr/`

### Phase 5: Implementation
With explicit user approval, implement the feature following the chosen architecture.

### Phase 6: Quality Review
**Skills loaded:** `code-quality`

- **Thorough:** 3 `code-reviewer` agents (Opus) focus on correctness, security, and maintainability
- **Quick:** 1 `code-reviewer` agent (Opus) performs comprehensive review

Only issues with confidence >= 80 are reported.

### Phase 7: Summary
Document accomplishments and generate changelog entry.

**Output:** Changelog entry saved to `docs/changelog/`

## Agents

| Agent | Model | Focus |
|-------|-------|-------|
| `code-explorer` | Sonnet | Traces execution paths, maps architecture |
| `code-architect` | Opus | Designs implementation blueprints |
| `code-reviewer` | Opus | Reviews with confidence-based filtering |

## Skills

| Skill | Auto-loads At | Content |
|-------|---------------|---------|
| `architecture-patterns` | Phase 4 | MVC, event-driven, microservices, CQRS |
| `code-quality` | Phase 6 | SOLID, DRY, testing strategies |
| `language-patterns` | Phase 2, 4 | TypeScript, Python, React patterns |
| `project-conventions` | Phase 2 | Discovering project-specific patterns |

## Mode Comparison

| Aspect | Thorough (default) | Quick (`--quick`) |
|--------|-------------------|-------------------|
| Exploration agents | 2-3 parallel | 1 |
| Architecture agents | 2-3 parallel | 1 |
| Review agents | 3 parallel | 1 |
| Best for | Complex features, unfamiliar codebases | Simple features, familiar codebases |

## Artifacts

### Architecture Decision Records (ADRs)
- Location: `docs/adr/NNNN-feature-slug.md`
- Contains: Context, decision, consequences, alternatives
- Generated in Phase 4 after user selects an approach

### Changelog Entries
- Location: `docs/changelog/YYYY-MM-DD-feature-slug.md`
- Contains: Summary, changes, files modified
- Generated in Phase 7 as summary

## Example Session

```
User: /feature-ops Add a dark mode toggle

Claude: [Phase 1] Understanding the feature...
        - Core: Toggle between light and dark themes
        - Need: State persistence, CSS variables, user preference

        Is this understanding correct?

User: Yes

Claude: [Phase 2] Launching exploration agents...
        Agent 1: Exploring UI components and theming
        Agent 2: Exploring state management and preferences

        Found: Tailwind CSS, Zustand store, localStorage patterns

Claude: [Phase 3] Clarifying questions:
        1. Should dark mode respect system preference?
        2. Where should the toggle appear (header, settings)?

User: Yes to system preference, toggle in header

Claude: [Phase 4] Architecture design...
        Approach 1: CSS custom properties + Zustand
        Approach 2: Tailwind dark mode class + context

        Recommending Approach 2 (matches existing patterns)

        Saved ADR to docs/adr/0001-dark-mode-toggle.md

User: Go with approach 2

Claude: [Phase 5] Ready to implement. Proceed?

User: Yes

Claude: [Phase 5] Implementing...
        - Created ThemeContext
        - Added dark mode toggle to Header
        - Updated Tailwind config
        ...

Claude: [Phase 6] Quality review...
        No critical issues found.
        1 moderate suggestion: Add transition animations

User: Fix that suggestion

Claude: [Phase 7] Summary:
        - Added dark mode with system preference detection
        - Files: 5 created, 3 modified
        - Saved changelog to docs/changelog/2024-01-15-dark-mode.md

        Ready to commit!
```

## Configuration

No additional configuration required. Artifacts are saved to `docs/` in your project root.

## License

MIT
