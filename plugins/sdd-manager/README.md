# sdd-manager

A Claude Code plugin for Spec Driven Development (SDD) document management. Conducts dynamic interviews to generate PRDs, Tech Specs, and Design Specs optimized for AI coding agents.

## Overview

SDD Manager guides you through a conversational interview process to capture project requirements, then generates well-structured specification documents. The interview adapts to your project type and desired detail level, ensuring you capture the right information without wasting time on irrelevant questions.

## Features

- **Dynamic Interviews**: Natural conversation flow that adapts to project context
- **Multiple Document Types**: Generate PRDs, Tech Specs, and/or Design Specs
- **Configurable Detail Levels**: High-level overviews to in-depth implementation specs
- **Session Resume**: Interrupt and continue interviews without losing progress
- **AI-Optimized Output**: Documents structured for AI coding agent consumption
- **Edit Capability**: Update specific sections without regenerating entire documents

## Installation

### Option 1: Plugin Directory
```bash
claude --plugin-dir /path/to/sdd-manager
```

### Option 2: Copy to Project
Copy the entire `sdd-manager` directory to your project's `.claude-plugin/` folder.

## Commands

| Command | Description |
|---------|-------------|
| `/sdd-manager:create [name]` | Start new SDD interview |
| `/sdd-manager:resume` | Continue interrupted interview |
| `/sdd-manager:edit <project> [section]` | Edit existing documents |
| `/sdd-manager:list` | View all SDD projects |

## Quick Start

```bash
# 1. Start a new SDD project
/sdd-manager:create my-feature

# 2. Answer interview questions
# (The interviewer will guide you through the process)

# 3. Documents are generated in specs/my-feature/
# - prd.md
# - tech-spec.md (if applicable)
# - design-spec.md (if UI components exist)

# 4. Edit specific sections later
/sdd-manager:edit my-feature requirements
```

## Document Types

### Product Requirements Document (PRD)
Focuses on **what** and **why**:
- Problem statement and goals
- Functional requirements
- User stories and acceptance criteria
- Non-functional requirements
- Out of scope items

### Technical Specification (Tech Spec)
Focuses on **how** at a system level:
- System architecture
- Data models
- API specifications
- Technology stack decisions
- Integration points

### Design Specification (Design Spec)
Focuses on **how** at a user experience level:
- User flows
- Component inventory
- Wireframe descriptions
- Interaction patterns
- Accessibility considerations

## Interview Flow

The interview progresses through these phases:

1. **Foundation**: Project name, type, context
2. **Scope**: Detail level, document format, component types
3. **Problem**: Problem statement, affected users, success metrics
4. **Requirements**: Features, user stories, constraints
5. **Technical** (mid/in-depth): Architecture, data, APIs, tech stack
6. **Design** (if UI components): Flows, screens, interactions
7. **Generation**: Document creation

## Detail Levels

| Level | Description | Best For |
|-------|-------------|----------|
| High-level | Overview and key decisions | Early exploration, quick alignment |
| Mid-level | Detailed requirements with guidance | Most projects |
| In-depth | Comprehensive, implementation-ready | Complex projects, AI agents |

## Output Structure

Documents are generated in `specs/<project-name>/`:

```
specs/
└── my-feature/
    ├── prd.md           # Always generated
    ├── tech-spec.md     # If technical complexity warrants
    └── design-spec.md   # If UI/UX components exist
```

### Document Frontmatter

All documents include YAML frontmatter for metadata:

```yaml
---
project: my-feature
type: prd
version: 1.0.0
created: 2024-01-15T10:30:00Z
last_updated: 2024-01-15T10:30:00Z
detail_level: mid
status: draft
related_documents:
  - ./tech-spec.md
  - ./design-spec.md
---
```

## Session State

Interview progress is saved to `.claude/sdd-manager.state.json`, enabling:
- Resume interrupted sessions
- Track what information has been collected
- Preserve work if session ends unexpectedly

Use `/sdd-manager:resume` to continue an interrupted interview.

## Workflow Integration

SDD Manager integrates well with spec-task-manager:

```bash
# 1. Create specifications
/sdd-manager:create user-auth

# 2. Generate task list from PRD
/spec-task-manager:analyze specs/user-auth/prd.md

# 3. Execute tasks
/ralph-task-executor:execute tasks/user-auth.tasks.json
```

## Editing Documents

Edit specific sections without regenerating:

```bash
# Open interactive editor
/sdd-manager:edit my-feature

# Edit specific section directly
/sdd-manager:edit my-feature requirements
/sdd-manager:edit my-feature architecture
/sdd-manager:edit my-feature flows
```

### Available Sections

**PRD**: overview, problem, goals, requirements, nfr, stories, scope
**Tech Spec**: architecture, data, api, stack, integration
**Design Spec**: flows, components, wireframes, interactions, accessibility

## License

MIT
