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
- Include all fields
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

## Execution Phases

### Phase 1: Foundation
Tasks with no dependencies.

#### TASK-001: <title>
- **Priority:** high | **Complexity:** M
- **Status:** not_started

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
ID,Title,Status,Priority,Complexity,Hard Dependencies,Soft Dependencies,Blocked By,Acceptance Criteria
TASK-001,"Title here",not_started,high,M,"TASK-002,TASK-003","TASK-004","","Criterion 1; Criterion 2"
```

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
- Full dependency information

The exported file is ready for:
- JSON: Programmatic consumption, backup
- Markdown: Documentation, sharing with stakeholders
- CSV: Spreadsheet import, project management tools
```

Suggest the most appropriate format if none specified based on common use cases.
