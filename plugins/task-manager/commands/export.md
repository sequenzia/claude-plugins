---
description: Export task list in various formats
argument-hint: [format] [project-name]
allowed-tools: Read, Write, Glob
---

Export the task list in the specified format.

## Process

1. **Parse arguments**
   - `$1` = Format: json (default), markdown, csv
   - `$2` = Project name (optional)

2. **Locate and read the task file**
   - If project name provided: Read `tasks/$2.tasks.json`
   - If no project name: Find most recently modified `.tasks.json`

3. **Generate export based on format**

### JSON Format (default)
- Write formatted, readable JSON
- Include all fields including `context_groups` array
- Include `context_group_id`, `context_group_start`, `context_group_end` on tasks
- Include `metadata.context_config` and `metadata.total_context_groups`
- Output to `tasks/<project>.export.json`

### Markdown Format
Generate human-readable markdown:

```markdown
# Task List: <project-name>

**Source:** <source_document>
**Generated:** <date>
**Progress:** X% complete

## Summary
- Total: X tasks
- Complete: Y
- In Progress: Z
- Blocked: W
- Not Started: V

## Context Groups (if configured)

**Configuration:**
- Max Tokens: 100,000
- Reserved: 20,000
- Effective Limit: 80,000

| Group | Status | Tasks | Est. Tokens | Phases |
|-------|--------|-------|-------------|--------|
| CG-001 | completed | 5 | 72,000 | 1, 2 |
| CG-002 | active | 4 | 68,500 | 2, 3 |
| CG-003 | pending | 3 | 45,200 | 3 |

### CG-001: Foundation & Setup
- TASK-001: Initialize project structure [complete]
- TASK-002: Setup database schema [complete]
- TASK-003: Configure authentication [complete]
- TASK-004: Create base models [complete]
- TASK-005: Add password hashing [complete]

### CG-002: Core Features (Active)
- TASK-006: Implement login flow [in_progress]
- TASK-007: Add session handling [not_started]
- TASK-008: Create logout endpoint [not_started]
- TASK-009: Add remember me [not_started]

### CG-003: Advanced Features
- TASK-010: Implement OAuth [not_started]
- TASK-011: Add 2FA support [not_started]
- TASK-012: Create password reset [not_started]

## Execution Phases

### Phase 1: Foundation
Tasks with no dependencies.

#### TASK-001: <title>
- **Priority:** high | **Complexity:** M
- **Status:** not_started
- **Context Group:** CG-001

**Description:**
<description>

**Acceptance Criteria:**
- [ ] <criterion 1>
- [ ] <criterion 2>

---

### Phase 2: Core Features
...
```

Output to `tasks/<project>.tasks.md`

### CSV Format
Generate spreadsheet-compatible CSV:

```csv
ID,Title,Status,Priority,Complexity,Hard Dependencies,Soft Dependencies,Blocked By,Context Group,Group Start,Group End,Est Tokens,Acceptance Criteria
TASK-001,"Title here",not_started,high,M,"TASK-002,TASK-003","TASK-004","",CG-001,true,false,4200,"Criterion 1; Criterion 2"
```

Columns added for context groups:
- `Context Group`: The context group ID (e.g., CG-001)
- `Group Start`: true if this is the first task in the group
- `Group End`: true if this is the last task in the group
- `Est Tokens`: Estimated token count for this task

Output to `tasks/<project>.tasks.csv`

4. **Write export file**

5. **Display confirmation**

```
## Export Complete

**Format:** <format>
**Output:** tasks/<filename>

File contains:
- X tasks
- Y execution phases
- Z context groups
- Full dependency information
- Context group assignments and token estimates

The exported file is ready for:
- JSON: Programmatic consumption, backup, API integration
- Markdown: Documentation, sharing with stakeholders, sprint planning
- CSV: Spreadsheet import, project management tools, resource planning
```

Suggest the most appropriate format if none specified based on common use cases.
