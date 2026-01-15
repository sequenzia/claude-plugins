# Task Execution Prompt Templates

This document defines the prompt templates used to convert spec-task-manager tasks into ralph-loop prompts.

## Base Task Prompt Template

```markdown
You are executing task {TASK_ID}: {TITLE}

## Task Description

{DESCRIPTION}

## Context from Completed Dependencies

{DEPENDENCY_CONTEXT}

## Acceptance Criteria

You must satisfy ALL of the following criteria:

{ACCEPTANCE_CRITERIA_LIST}

## Test Scenarios

{TEST_SCENARIOS}

## Edge Cases to Handle

{EDGE_CASES}

## Source Requirements

This task addresses the following specification sections:
{SOURCE_REQUIREMENTS}

## Implementation Notes

{NOTES}

---

## Completion Requirement

When ALL acceptance criteria above are met and verified, output:

<promise>{COMPLETION_PROMISE}</promise>

**IMPORTANT:**
- Do NOT output the promise tag until you have verified ALL criteria
- If you cannot complete this task, explain what is blocking you
- The loop will continue until you output the promise or reach max iterations
```

## Template Variables

| Variable | Source | Description |
|----------|--------|-------------|
| `{TASK_ID}` | `task.id` | Task identifier (e.g., TASK-007) |
| `{TITLE}` | `task.title` | Brief task title |
| `{DESCRIPTION}` | `task.description` | Full task description |
| `{DEPENDENCY_CONTEXT}` | Built from completed dependencies | Context from hard/soft dependencies |
| `{ACCEPTANCE_CRITERIA_LIST}` | `task.testing.acceptance_criteria` | Bulleted list of criteria |
| `{TEST_SCENARIOS}` | `task.testing.test_scenarios` | Test cases to satisfy |
| `{EDGE_CASES}` | `task.testing.edge_cases` | Edge cases to handle |
| `{SOURCE_REQUIREMENTS}` | `task.source_requirements` | Spec sections this task addresses |
| `{NOTES}` | `task.notes` | Implementation notes/hints |
| `{COMPLETION_PROMISE}` | Generated | `TASK-{ID}-COMPLETE` |

## Dependency Context Format

For each completed hard dependency, include:

```markdown
### {DEP_ID}: {DEP_TITLE}
- **Status:** Complete
- **Implementation Notes:** {DEP_NOTES}
- **Files Modified:** {DEP_ARTIFACTS}
```

For completed soft dependencies, include abbreviated context:

```markdown
### {DEP_ID} (soft): {DEP_TITLE}
- Patterns and approaches from this task may be relevant
```

## Completion Promise Format

The completion promise follows a predictable pattern:

```
TASK-{ID}-COMPLETE
```

Examples:
- `TASK-001-COMPLETE`
- `TASK-042-COMPLETE`
- `TASK-1234-COMPLETE`

## Prompt Generation Algorithm

```
function buildTaskPrompt(task, allTasks, executionState):
    # Start with template
    prompt = BASE_TEMPLATE

    # Replace simple variables
    prompt = prompt.replace("{TASK_ID}", task.id)
    prompt = prompt.replace("{TITLE}", task.title)
    prompt = prompt.replace("{DESCRIPTION}", task.description)
    prompt = prompt.replace("{COMPLETION_PROMISE}", "TASK-" + task.id + "-COMPLETE")

    # Build dependency context
    dependencyContext = buildDependencyContext(task, allTasks, executionState)
    prompt = prompt.replace("{DEPENDENCY_CONTEXT}", dependencyContext)

    # Format acceptance criteria as bullet list
    criteriaList = task.testing.acceptance_criteria
        .map(c => "- " + c)
        .join("\n")
    prompt = prompt.replace("{ACCEPTANCE_CRITERIA_LIST}", criteriaList)

    # Format test scenarios
    testList = task.testing.test_scenarios
        .map(t => "- " + t)
        .join("\n")
    prompt = prompt.replace("{TEST_SCENARIOS}", testList)

    # Format edge cases
    edgeList = task.testing.edge_cases
        .map(e => "- " + e)
        .join("\n")
    prompt = prompt.replace("{EDGE_CASES}", edgeList)

    # Format source requirements
    sourceList = task.source_requirements
        .map(s => "- " + s)
        .join("\n")
    prompt = prompt.replace("{SOURCE_REQUIREMENTS}", sourceList)

    # Include notes if present
    prompt = prompt.replace("{NOTES}", task.notes || "None")

    return prompt
```

## Example Generated Prompt

Given a task:

```json
{
  "id": "TASK-007",
  "title": "Implement user authentication service",
  "description": "Create a service layer that handles user login, logout, and session management using JWT tokens.",
  "dependencies": {
    "hard": ["TASK-001", "TASK-002"],
    "soft": ["TASK-005"]
  },
  "testing": {
    "acceptance_criteria": [
      "Login endpoint accepts email and password",
      "Successful login returns JWT token",
      "Invalid credentials return 401 error",
      "Logout invalidates the token"
    ],
    "test_scenarios": [
      "Login with valid credentials",
      "Login with invalid password",
      "Login with non-existent user",
      "Logout with valid token"
    ],
    "edge_cases": [
      "Empty email or password",
      "Malformed JWT token",
      "Expired token refresh"
    ]
  },
  "source_requirements": ["Section 3.1: Authentication", "Section 3.2: Session Management"],
  "notes": "Use bcrypt for password hashing. JWT secret should come from environment variable."
}
```

Generated prompt:

```markdown
You are executing task TASK-007: Implement user authentication service

## Task Description

Create a service layer that handles user login, logout, and session management using JWT tokens.

## Context from Completed Dependencies

### TASK-001: Create User model
- **Status:** Complete
- **Implementation Notes:** User model includes email, password_hash, and created_at fields
- **Files Modified:** src/models/user.ts, src/models/index.ts

### TASK-002: Implement User repository
- **Status:** Complete
- **Implementation Notes:** Repository uses TypeORM with PostgreSQL
- **Files Modified:** src/repositories/user.repository.ts

### TASK-005 (soft): Setup JWT configuration
- Patterns and approaches from this task may be relevant

## Acceptance Criteria

You must satisfy ALL of the following criteria:

- Login endpoint accepts email and password
- Successful login returns JWT token
- Invalid credentials return 401 error
- Logout invalidates the token

## Test Scenarios

- Login with valid credentials
- Login with invalid password
- Login with non-existent user
- Logout with valid token

## Edge Cases to Handle

- Empty email or password
- Malformed JWT token
- Expired token refresh

## Source Requirements

This task addresses the following specification sections:
- Section 3.1: Authentication
- Section 3.2: Session Management

## Implementation Notes

Use bcrypt for password hashing. JWT secret should come from environment variable.

---

## Completion Requirement

When ALL acceptance criteria above are met and verified, output:

<promise>TASK-007-COMPLETE</promise>

**IMPORTANT:**
- Do NOT output the promise tag until you have verified ALL criteria
- If you cannot complete this task, explain what is blocking you
- The loop will continue until you output the promise or reach max iterations
```
