---
description: Edit or update existing SDD documents
argument-hint: <project-name> [section]
allowed-tools: [Read, Write, Edit, Glob, AskUserQuestion]
model: inherit
---

# Edit SDD Documents

Modify existing Spec Driven Development documents for a project.

## Arguments

- `$1` (required): Project name or path to specific document
- `$2` (optional): Specific section to edit (e.g., "requirements", "architecture")

## Process

### 1. Locate Project

Parse the argument to find the project:

**If project name provided:**
- Look for `specs/<project-name>/`
- Verify directory exists with at least one SDD document

**If document path provided:**
- Verify file exists
- Extract project name from path

If not found:
- Report: "Project or document not found."
- Suggest: Use `/sdd-manager:list` to see available projects
- Exit

### 2. Load Existing Documents

Read all SDD documents in the project:
- `specs/<project-name>/prd.md`
- `specs/<project-name>/tech-spec.md` (if exists)
- `specs/<project-name>/design-spec.md` (if exists)

Parse YAML frontmatter to understand:
- Detail level
- Version
- Related documents
- Last updated

### 3. Determine Edit Mode

**If specific section provided ($2):**
- Jump directly to that section
- Show current content
- Ask for changes

**If no section provided:**
- Show document overview
- List available sections
- Ask what user wants to edit

### 4. Present Edit Options

Display interactive menu:

```
## Edit: {project-name}

**Documents:**
1. PRD (prd.md) - Last updated: {date}
2. Tech Spec (tech-spec.md) - Last updated: {date}
3. Design Spec (design-spec.md) - Last updated: {date}

**What would you like to edit?**

**PRD Sections:**
- overview - Project overview
- problem - Problem statement
- goals - Goals and success metrics
- requirements - Functional requirements
- nfr - Non-functional requirements
- stories - User stories
- scope - Out of scope items

**Tech Spec Sections:**
- architecture - System architecture
- data - Data models
- api - API specifications
- stack - Technology stack
- integration - Integration points

**Design Spec Sections:**
- flows - User flows
- components - Component inventory
- wireframes - Wireframe descriptions
- interactions - Interaction patterns
- accessibility - Accessibility considerations

Enter section name or number, or 'q' to quit:
```

### 5. Perform Edits

Based on user selection:

1. **Show current content** for the selected section
2. **Ask for changes** using AskUserQuestion:
   - "What would you like to change in {section}?"
   - Offer options: Replace, Add, Remove, Modify
3. **Apply changes** using Edit tool
4. **Update frontmatter**:
   - Increment patch version
   - Update `last_updated` timestamp

### 6. Validate Changes

After each edit:
- Ensure document structure is preserved
- Verify YAML frontmatter is valid
- Check cross-references still work

### 7. Continue or Complete

After each edit:
- Ask: "Would you like to edit anything else?"
- If yes: Return to step 4
- If no: Show summary of changes

## Output

After editing completes:

```
## Edit Summary: {project-name}

**Changes Made:**
- prd.md: Updated requirements section
- tech-spec.md: Modified architecture section

**Version:** 1.0.0 → 1.0.1
**Last Updated:** {new-timestamp}

**Documents:**
- specs/{project-name}/prd.md
- specs/{project-name}/tech-spec.md
- specs/{project-name}/design-spec.md

Use `/sdd-manager:list` to view all projects.
```

## Example Usage

```bash
# Open interactive editor for a project
/sdd-manager:edit my-feature

# Edit specific section directly
/sdd-manager:edit my-feature requirements

# Edit a specific document
/sdd-manager:edit specs/my-feature/tech-spec.md

# Edit architecture section of tech spec
/sdd-manager:edit my-feature architecture
```

## Section Mappings

| Shortcut | Document | Section |
|----------|----------|---------|
| overview | PRD | Overview |
| problem | PRD | Problem Statement |
| goals | PRD | Goals & Success Metrics |
| requirements | PRD | Functional Requirements |
| nfr | PRD | Non-Functional Requirements |
| stories | PRD | User Stories |
| scope | PRD | Out of Scope |
| architecture | Tech Spec | System Architecture |
| data | Tech Spec | Data Models |
| api | Tech Spec | API Specifications |
| stack | Tech Spec | Technology Stack |
| integration | Tech Spec | Integration Points |
| flows | Design Spec | User Flows |
| components | Design Spec | Component Inventory |
| wireframes | Design Spec | Wireframe Descriptions |
| interactions | Design Spec | Interaction Patterns |
| accessibility | Design Spec | Accessibility Considerations |

## Related Commands

- `/sdd-manager:create` - Create new project
- `/sdd-manager:list` - View all projects
- `/sdd-manager:resume` - Resume interrupted interview
