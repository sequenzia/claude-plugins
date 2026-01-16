# spec-manager

A Claude Code plugin for creating Product Requirements Documents (PRDs) through guided multi-round interviews. Supports analyzing existing requirements to pre-populate answers and ask targeted follow-up questions.

## Features

- **Guided PRD creation** through structured interviews
- **Overview analysis** - provide an overview file or inline text to pre-populate data
- **Gap detection** - identifies missing information in provided overview
- **Ambiguity flagging** - highlights unclear or conflicting information
- **Session resume** - continue interrupted interviews from where you left off
- **AI-optimized output** - generates PRDs ready for AI coding agents

## Installation

This plugin is part of the claude-plugins collection. To use it:

1. Clone the repository or add it to your Claude Code plugins directory
2. The plugin will be automatically discovered by Claude Code

## Commands

### `/spec-manager:create-prd`

Launch a new PRD interview.

**Usage:**
```bash
# Start with an overview file
/spec-manager:create-prd @docs/project-overview.md

# Start with inline overview
/spec-manager:create-prd "Build a task management app with projects, due dates, and team collaboration"

# Start from scratch (full interview)
/spec-manager:create-prd
```

**Input Methods:**
- **File reference**: `@path/to/overview.md` - Analyzes the file (description, goals, requirements, etc.)
- **Inline text**: `"description..."` - Analyzes the text and extracts project information
- **No input**: Conducts full interview from scratch

### `/spec-manager:resume`

Resume an interrupted PRD interview session.

**Usage:**
```bash
/spec-manager:resume
```

Continues from the saved phase with all previously collected data intact.

## Interview Flow

### With Overview Input

When you provide an overview (file or inline text), the interview:

1. **Analyzes** your input to extract project information
2. **Presents findings** showing what was extracted
3. **Identifies gaps** in the overview
4. **Asks targeted questions** to fill gaps and clarify ambiguities

### Without Overview Input

Full interview covering all topics:

1. **Foundation** - Project name, summary, type, context
2. **Objectives** - Problem statement, goals, success metrics, non-goals
3. **User Stories** - Personas, needs, user stories, edge cases
4. **Functional Requirements** - P0/P1/P2 features, integrations, constraints
5. **Non-Functional Requirements** - NFR priorities, targets, acceptance criteria
6. **Generation** - Review and generate the PRD

## Output

PRDs are generated at:
```
specs/<project-name>.prd.md
```

### PRD Structure

```markdown
---
project: my-project
type: prd
version: 1.0.0
created: 2024-01-15T10:30:00Z
status: draft
---

# My Project - Product Requirements Document

## Overview
## Problem Statement
## Goals & Success Metrics
## User Stories
## Functional Requirements (P0/P1/P2)
## Non-Functional Requirements
## Dependencies & Integrations
## Constraints
## Acceptance Criteria
## Risks & Open Questions
```

## State Management

Interview state is saved to `.claude/spec-manager.state.json`, enabling:

- **Session resume** - Continue interrupted interviews
- **Progress tracking** - Know what's been covered
- **Data preservation** - Don't lose gathered information

## Plugin Structure

```
spec-manager/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── commands/
│   ├── create-prd.md
│   └── resume.md
├── agents/
│   └── prd-interviewer.md
└── skills/
    └── prd-creation/
        ├── SKILL.md
        └── references/
            └── prd-template.md
```

## Integration with Other Plugins

After creating a PRD, you can use it with other plugins:

```bash
# Generate tasks from your PRD
/spec-task-manager:analyze specs/my-project.prd.md

# Execute tasks automatically
/ralph-task-executor:execute my-project
```

## Examples

### Example 1: Quick PRD from Existing Overview

```bash
/spec-manager:create-prd @docs/project-overview.md
```

The interviewer will:
1. Read and analyze your overview
2. Show extracted project name, summary, features
3. Ask about missing priorities (P0/P1/P2)
4. Ask about success metrics and acceptance criteria
5. Generate a complete PRD

### Example 2: Full Interview for New Project

```bash
/spec-manager:create-prd
```

The interviewer will guide you through each phase, asking questions to build a complete picture of your project requirements.

### Example 3: Resume Interrupted Session

```bash
# Session interrupted at user stories phase
/spec-manager:resume

# Resuming PRD Interview
# Project: my-awesome-feature
# Phase: user_stories
# Continue from here...
```

## Best Practices

1. **Provide an overview file** when available to reduce interview time
2. **Be specific** about priorities - P0 means "can't launch without"
3. **Include success metrics** - measurable targets help define "done"
4. **Document non-goals** - prevents scope creep later
5. **Review before generation** - verify the summary matches your intent

## Requirements

- Claude Code CLI
- Write access to create `specs/` directory and `.claude/` state file
