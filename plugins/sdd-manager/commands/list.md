---
description: List all SDD projects in the specs directory
allowed-tools: [Read, Glob, Bash]
model: inherit
---

# List SDD Projects

Display all Spec Driven Development projects found in the `specs/` directory.

## Process

### 1. Check for specs Directory

Verify `specs/` directory exists:
- If not found: Report "No specs/ directory found. Use `/sdd-manager:create` to start your first project."

### 2. Scan for Projects

Find all SDD project directories:
- Look for directories containing SDD documents (`prd.md`, `tech-spec.md`, `design-spec.md`)
- Extract project metadata from YAML frontmatter

### 3. Gather Project Information

For each project found, collect:
- Project name (directory name)
- Documents present (PRD, Tech Spec, Design Spec)
- Detail level (from frontmatter)
- Version (from frontmatter)
- Last updated (from frontmatter)
- Status (draft/final)

### 4. Check for Active Interview

Check `.claude/sdd-manager.state.json`:
- If exists: Note which project has an in-progress interview

### 5. Display Results

Format and display the project list:

```
## SDD Projects

Found {count} project(s) in specs/

| Project | Documents | Detail | Version | Last Updated | Status |
|---------|-----------|--------|---------|--------------|--------|
| {name} | PRD, Tech | mid | 1.0.0 | 2024-01-15 | draft |
| {name} | PRD, Design | high | 1.2.0 | 2024-01-10 | draft |
| {name} | PRD | in-depth | 2.0.0 | 2024-01-05 | final |

{If active interview exists:}
**In Progress:** {project-name} (phase: {phase})
  Use `/sdd-manager:resume` to continue.

**Commands:**
- `/sdd-manager:create` - Start new project
- `/sdd-manager:edit <project>` - Edit project documents
- `/sdd-manager:resume` - Continue interrupted interview
```

## Output Format

### Table Columns

| Column | Description |
|--------|-------------|
| Project | Directory name under specs/ |
| Documents | Which SDD docs exist (PRD, Tech, Design) |
| Detail | Detail level: high, mid, in-depth |
| Version | Document version from frontmatter |
| Last Updated | Most recent update across all docs |
| Status | draft or final |

### Document Abbreviations

- **PRD** - Product Requirements Document
- **Tech** - Technical Specification
- **Design** - Design Specification

## Example Output

```
## SDD Projects

Found 3 project(s) in specs/

| Project | Documents | Detail | Version | Last Updated | Status |
|---------|-----------|--------|---------|--------------|--------|
| user-auth | PRD, Tech, Design | in-depth | 1.0.0 | 2024-01-15 | draft |
| api-v2 | PRD, Tech | mid | 2.1.0 | 2024-01-12 | draft |
| landing-page | PRD, Design | high | 1.0.0 | 2024-01-08 | final |

**In Progress:** payment-system (phase: requirements)
  Use `/sdd-manager:resume` to continue.

**Commands:**
- `/sdd-manager:create` - Start new project
- `/sdd-manager:edit <project>` - Edit project documents
- `/sdd-manager:resume` - Continue interrupted interview
```

## Edge Cases

### No Projects Found
```
## SDD Projects

No projects found in specs/

Get started by creating your first project:
  /sdd-manager:create

Or check if your specs are in a different location.
```

### No specs/ Directory
```
## SDD Projects

No specs/ directory found.

Create your first SDD project:
  /sdd-manager:create

This will create the specs/ directory and start an interview
to generate specification documents.
```

### Malformed Project
If a project has documents but missing/invalid frontmatter:
- Include in list with "?" for unknown values
- Note: "Some projects have missing metadata. Use /sdd-manager:edit to fix."

## Example Usage

```bash
# List all SDD projects
/sdd-manager:list
```

## Related Commands

- `/sdd-manager:create` - Start new project
- `/sdd-manager:edit <project>` - Edit project documents
- `/sdd-manager:resume` - Continue interrupted interview
