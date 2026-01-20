---
description: Display detailed information for a specific context group
argument-hint: <group-id> [project-name]
allowed-tools: Read, Glob
---

Show detailed information about a specific context group, including all tasks, dependencies, and progress.

## Process

1. **Parse arguments**
   - `$1` = Group ID (required, e.g., "CG-001")
   - `$2` = Project name (optional)

2. **Validate arguments**
   - Group ID must match pattern `CG-XXX`
   - If invalid, show usage help

3. **Locate and read the task file**
   - If project name provided: Read `tasks/$2.tasks.json`
   - If no project name: Find most recently modified `.tasks.json`

4. **Find the requested context group**
   - Search `context_groups` array for matching ID
   - If not found, list available groups

5. **Gather task details**
   - For each task in the group, collect full task information
   - Calculate completion status
   - Identify dependencies within and outside the group

6. **Display group details**

Format output as:

```
## Context Group: CG-001

**Status:** active
**Estimated Tokens:** 72,000 / 80,000 effective limit
**Phases Covered:** 1, 2

### Progress
- **Completed:** 2 of 5 tasks (40%)
- **In Progress:** 1 task
- **Blocked:** 0 tasks
- **Not Started:** 2 tasks

---

### Tasks

#### TASK-001: Initialize project structure [COMPLETE]
- **Priority:** high | **Complexity:** S | **Tokens:** 1,700
- **Description:** Set up the base project directory structure and configuration files
- **Acceptance Criteria:**
  - [x] Directory structure created
  - [x] package.json configured
  - [x] TypeScript config in place

---

#### TASK-002: Setup database schema [COMPLETE]
- **Priority:** high | **Complexity:** M | **Tokens:** 4,200
- **Dependencies:** TASK-001 (complete)
- **Description:** Define database tables and relationships
- **Acceptance Criteria:**
  - [x] User table created
  - [x] Session table created
  - [x] Migrations written

---

#### TASK-003: Implement user model [IN PROGRESS]
- **Priority:** high | **Complexity:** M | **Tokens:** 4,200
- **Dependencies:** TASK-002 (complete)
- **Description:** Create the User model with CRUD operations
- **Acceptance Criteria:**
  - [ ] User class implemented
  - [ ] Validation logic added
  - [ ] Unit tests passing

---

#### TASK-004: Create authentication service [NOT STARTED]
- **Priority:** critical | **Complexity:** L | **Tokens:** 10,200
- **Dependencies:** TASK-003 (in progress)
- **Blocked By:** TASK-003
- **Description:** Implement authentication logic with JWT
- **Acceptance Criteria:**
  - [ ] Login endpoint working
  - [ ] Token generation implemented
  - [ ] Token validation middleware

---

#### TASK-005: Add password hashing [NOT STARTED]
- **Priority:** high | **Complexity:** S | **Tokens:** 1,700
- **Dependencies:** TASK-001 (complete)
- **Description:** Implement secure password hashing utility
- **Acceptance Criteria:**
  - [ ] bcrypt integration
  - [ ] Hash and verify functions
  - [ ] Salt rounds configurable

---

### Dependency Graph (This Group)

```
TASK-001 (complete)
  ├── TASK-002 (complete)
  │     └── TASK-003 (in_progress)
  │           └── TASK-004 (blocked)
  └── TASK-005 (not_started)
```

### External Dependencies
- **From Previous Groups:** None
- **For Next Groups:**
  - CG-002 depends on: TASK-003, TASK-004

### Token Breakdown

| Task | Base | Overhead | Total |
|------|------|----------|-------|
| TASK-001 | 1,500 | 200 | 1,700 |
| TASK-002 | 4,000 | 200 | 4,200 |
| TASK-003 | 4,000 | 200 | 4,200 |
| TASK-004 | 10,000 | 200 | 10,200 |
| TASK-005 | 1,500 | 200 | 1,700 |
| **Total** | | | **22,000** |

---

### Ready to Start Now
Tasks with all dependencies satisfied:
- **TASK-005:** Add password hashing (high, S)

### Blocked Tasks
- **TASK-004:** Waiting on TASK-003

---

**Commands:**
- Mark complete: `/sdd-manager:complete TASK-XXX`
- Update task: `/sdd-manager:update TASK-XXX --status in_progress`
- See all groups: `/sdd-manager:status`
```

## Edge Cases

### Group Not Found
```
## Context Group Not Found: CG-005

The group "CG-005" does not exist in this task list.

**Available Groups:**
- CG-001 (5 tasks, pending)
- CG-002 (4 tasks, pending)
- CG-003 (3 tasks, pending)

Use `/sdd-manager:show-group CG-001` to view a specific group.
```

### No Context Groups Exist
```
## No Context Groups

Context groups have not been generated for this project.

Run `/sdd-manager:context-groups [project-name]` to organize tasks into context groups.
```

### Group Has Warnings
```
## Context Group: CG-003

**Status:** pending
**Warning:** Contains oversized task

### Oversized Task Warning

**TASK-015:** Complex integration module
- **Complexity:** XL
- **Estimated Tokens:** 25,200 (exceeds 20,000 safe limit)

This task is larger than recommended for a single context window session.
Consider:
1. Breaking into smaller subtasks
2. Using a larger context window model
3. Proceeding with awareness of potential context limitations
```

### Context Handoff Information
```
## Context Group: CG-002

**Context Handoff**
This group continues work from CG-001.

**Split Reason:** Dependency chain exceeded token limit

**Required Context from CG-001:**
- TASK-003 outputs: Database schema, migration files
- TASK-004 outputs: API route definitions

Ensure you have access to these before starting.
```

## Usage Examples

```bash
# Show specific group
/sdd-manager:show-group CG-001

# Show group from specific project
/sdd-manager:show-group CG-002 my-project

# Common workflow
/sdd-manager:status              # See all groups overview
/sdd-manager:show-group CG-001   # Detailed view of group 1
/sdd-manager:next-group          # Get next actionable group
```
