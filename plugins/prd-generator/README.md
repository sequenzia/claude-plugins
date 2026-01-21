# PRD Generator Plugin

A Claude Code plugin that generates Product Requirements Documents (PRDs) through an interactive interview-based workflow.

## Features

- **Interactive Interview Process**: Gathers requirements through adaptive questioning
- **Depth-Aware Templates**: Three detail levels to match your needs
- **Codebase Integration**: Can explore existing code for "new feature" PRDs
- **On-Demand Research**: Research technical docs, best practices, and domain knowledge during interviews
- **AI-Optimized Output**: PRDs structured for optimal AI assistant consumption

## Installation

1. Copy the `prd-generator` folder to your Claude Code plugins directory
2. Restart Claude Code or reload plugins

## Usage

### Basic Usage

Run the create command to start generating a PRD:

```
/prd-generator:create
```

This will:
1. Ask for initial information (name, type, depth, description)
2. Launch an adaptive interview to gather detailed requirements
3. Present a summary for your review
4. Generate the PRD and save it to your configured location

### Depth Levels

| Level | Description | Best For |
|-------|-------------|----------|
| **High-level overview** | Executive summary with key features and goals | Initial alignment, stakeholder communication |
| **Detailed specifications** | Standard PRD with acceptance criteria and phases | Development planning, sprint planning |
| **Full technical documentation** | Comprehensive specs including APIs and data models | Complex features, API-first development |

### Product Types

- **New product**: For completely new products being built from scratch
- **New feature**: For features in existing products (can explore your codebase for context)

## Configuration

### Settings File

Create a settings file at `.claude/prd-generator.local.md` to customize the plugin:

```yaml
---
output_path: specs/PRD-{name}.md
author: Your Name
---

# PRD Generator Settings

Custom settings for the PRD Generator plugin.
```

#### Available Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `output_path` | `specs/PRD-{name}.md` | Where to save generated PRDs. `{name}` is replaced with the PRD name. |
| `author` | Not specified | Default author name for generated PRDs |

### Output Location

By default, PRDs are saved to `specs/PRD-{name}.md` where `{name}` is the name you provide.

Examples:
- Name: "User Authentication" → `specs/PRD-User-Authentication.md`
- Name: "API Gateway" → `specs/PRD-API-Gateway.md`

## Interview Categories

The interview covers four main categories:

### 1. Problem & Goals
- Problem statement and impact
- Success metrics and baselines
- User personas
- Business value

### 2. Functional Requirements
- Must-have features
- User stories and acceptance criteria
- Workflows and edge cases
- Error handling

### 3. Technical Specifications
- Architecture and tech stack
- Data models and APIs
- Performance requirements
- Security and compliance

### 4. Implementation Planning
- Phases and milestones
- Dependencies and risks
- Out of scope items
- Checkpoint gates

## On-Demand Research

During the interview, you can request research on any topic to inform your PRD. Simply ask the agent to research something, and it will gather current information from documentation and the web.

### Research Types

| Type | Example Request | What You Get |
|------|-----------------|--------------|
| **Technical Documentation** | "Research the Stripe subscriptions API" | API endpoints, auth methods, rate limits, SDKs |
| **Best Practices** | "Research best practices for checkout flows" | UX patterns, industry standards, design guidelines |
| **Competitive Analysis** | "How do competitors handle user onboarding?" | Competitor approaches, notable features, market patterns |
| **Compliance/Regulatory** | "What GDPR requirements apply to user data?" | Compliance requirements, implementation guidelines |
| **Domain Knowledge** | "Help me understand inventory management challenges" | Industry terminology, common workflows, problem space context |

### How to Use

During any point in the interview, you can say:
- "Research the {library} documentation for {feature}"
- "Look up best practices for {topic}"
- "Research how competitors handle {feature}"
- "What {compliance} requirements apply to {feature}?"

Research findings are automatically formatted for PRD incorporation and include source citations.

## Generated PRD Structure

### High-Level Template Includes:
- Executive Summary
- Problem Statement
- Key Features
- Success Metrics
- Implementation Phases
- Risks & Dependencies

### Detailed Template Adds:
- User Personas & Journey Maps
- Detailed User Stories
- Acceptance Criteria
- Non-Functional Requirements
- Technical Constraints

### Full Tech Template Adds:
- System Architecture Diagrams
- Data Model Specifications
- API Endpoint Definitions
- Performance SLAs
- Testing Strategy
- Deployment Plan

## Tips for Best Results

1. **Be specific in the initial description**: The more context you provide upfront, the more targeted the interview questions will be.

2. **Choose the right depth level**: Start with "High-level overview" if you're still exploring the idea. Use "Full technical documentation" only when you need API specs.

3. **Review the summary carefully**: The pre-compilation summary is your chance to add or correct information before the PRD is generated.

4. **For new features**: Allow the agent to explore your codebase - it helps identify existing patterns and integration points.

## File Structure

```
prd-generator/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/
│   └── create.md             # /prd-generator:create command
├── agents/
│   ├── interview-agent.md    # Adaptive interview agent
│   └── research-agent.md     # On-demand research agent
├── skills/
│   └── prd-generation/
│       ├── SKILL.md          # PRD generation knowledge
│       └── references/
│           ├── template-high-level.md
│           ├── template-detailed.md
│           ├── template-full-tech.md
│           └── interview-questions.md
└── README.md                 # This file
```

## Troubleshooting

### PRD not saving to expected location
Check your `.claude/prd-generator.local.md` settings file for the correct `output_path` format.

### Interview seems too short/long
The interview depth is based on the level you select. Choose "Full technical documentation" for the most comprehensive interview.

### Want to skip certain questions
If a question isn't relevant, you can indicate "no preference" or "not applicable" and the agent will adapt accordingly.

## Contributing

This plugin is part of the claude-plugins repository. Feel free to submit issues or pull requests for improvements.

## License

MIT
