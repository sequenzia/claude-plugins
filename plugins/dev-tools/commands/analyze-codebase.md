---
description: Analyze a codebase to generate a comprehensive architecture and structure report
argument-hint: "[path]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - Task
  - TaskCreate
  - TaskUpdate
  - TaskList
arguments:
  - name: path
    description: Optional path to analyze (defaults to current directory)
    required: false
---

# Codebase Analysis Workflow

You are executing a 3-phase codebase analysis workflow. This workflow explores a codebase, analyzes its architecture, and generates a comprehensive report.

**CRITICAL: You MUST complete ALL 3 phases.** The workflow is not complete until Phase 3: Report Generation is finished. After completing each phase, immediately proceed to the next phase without waiting for user prompts.

## Phase Overview

Execute these phases in order, completing ALL of them:

1. **Codebase Exploration** - Explore structure, patterns, and dependencies
2. **Deep Analysis** - Analyze findings to identify architecture and patterns
3. **Report Generation** - Generate comprehensive markdown report

---

## Phase 1: Codebase Exploration

**Goal:** Thoroughly explore the codebase to gather raw findings.

1. Create task entries for all 3 phases using TaskCreate:
   ```
   - Phase 1: Codebase Exploration
   - Phase 2: Deep Analysis
   - Phase 3: Report Generation
   ```

2. Mark Phase 1 as `in_progress` using TaskUpdate

3. Determine the analysis path:
   - If a path argument was provided, use that path
   - Otherwise, use the current working directory
   - Inform the user of the scope being analyzed

4. **Launch 3 code-explorer agents in parallel** using the Task tool with `subagent_type: "dev-tools:code-explorer"`:

   **Agent 1: Project Structure & Configuration**
   ```
   Explore and analyze the project structure and configuration.
   Path to analyze: [path]

   Focus on:
   - Project root structure (directories and their purposes)
   - Entry points (main files, index files, CLI entry points)
   - Configuration files (package.json, pyproject.toml, tsconfig.json, etc.)
   - Build configuration (webpack, vite, rollup, etc.)
   - Development tools (.eslintrc, .prettierrc, etc.)
   - CI/CD configuration (.github/workflows, Jenkinsfile, etc.)
   - Environment configuration (.env.example, config files)

   Return a structured report of:
   - Directory structure overview
   - Key entry points and their purposes
   - Configuration summary
   - Build and development tooling
   ```

   **Agent 2: Core Modules & Business Logic**
   ```
   Explore and analyze the core modules and business logic.
   Path to analyze: [path]

   Focus on:
   - Core source directories (src/, lib/, app/)
   - Key classes, functions, and modules
   - Business logic and domain models
   - State management (if applicable)
   - Data models and schemas
   - Service layers and APIs
   - Utility and helper modules

   Return a structured report of:
   - Key modules and their responsibilities
   - Important classes/functions with brief descriptions
   - Design patterns observed
   - Code organization patterns
   ```

   **Agent 3: Dependencies & Integrations**
   ```
   Explore and analyze dependencies and external integrations.
   Path to analyze: [path]

   Focus on:
   - Package dependencies (production vs development)
   - Internal module dependencies (how modules import each other)
   - External API integrations
   - Database connections and ORM usage
   - Third-party service integrations
   - Authentication/authorization mechanisms
   - Caching layers
   - Message queues or event systems

   Return a structured report of:
   - Dependency analysis (major frameworks, libraries)
   - External integration points
   - Data storage mechanisms
   - Communication patterns
   ```

5. **Wait for all agents to complete** and collect their findings.

6. **Synthesize exploration findings:**
   - Combine results from all 3 agents
   - Identify overlapping or conflicting information
   - Note any gaps in coverage
   - Create a consolidated findings document

7. Mark Phase 1 as `completed`

---

## Phase 2: Deep Analysis

**Goal:** Analyze exploration findings to identify architecture, patterns, and insights.

1. Mark Phase 2 as `in_progress`

2. **Launch codebase-analyzer agent** using the Task tool with `subagent_type: "dev-tools:codebase-analyzer"`:

   ```
   Analyze the following codebase exploration findings and produce a deep analysis.

   Path analyzed: [path]

   ## Exploration Findings

   [Include the synthesized findings from Phase 1]

   ---

   Produce a comprehensive analysis covering:
   1. Architecture style identification
   2. Key modules and their responsibilities
   3. Dependency relationships between modules
   4. Technology stack summary
   5. Code patterns and conventions
   6. Entry points and data flow
   7. External integrations
   8. Testing approach
   9. Build and deployment patterns
   10. Strengths and areas for improvement
   ```

3. **Wait for analysis to complete** and collect the results.

4. Mark Phase 2 as `completed`

---

## Phase 3: Report Generation

**Goal:** Generate a comprehensive, well-formatted markdown report.

1. Mark Phase 3 as `in_progress`

2. **Ensure output directory exists:**
   - Check if `internal/reports/` directory exists
   - If not, create it using Bash: `mkdir -p internal/reports`

3. **Launch report-generator agent** using the Task tool with `subagent_type: "dev-tools:report-generator"`:

   ```
   Generate a comprehensive codebase analysis report in markdown format.

   Path analyzed: [path]
   Analysis date: [current date]

   ## Analysis Findings

   [Include the complete analysis from Phase 2]

   ---

   Generate a well-structured markdown report and save it to:
   internal/reports/codebase-analysis-report.md

   The report should be polished, readable, and useful for developers
   new to the codebase as well as those looking to understand the
   overall architecture.
   ```

4. **Wait for report generation to complete.**

5. **Verify the report was created:**
   - Read the generated report file to confirm it exists
   - Display a summary to the user

6. Mark Phase 3 as `completed`

7. **Final message:**
   - Confirm the report location: `internal/reports/codebase-analysis-report.md`
   - Offer next steps:
     - Open the report for review
     - Run analysis on a different path
     - Share any specific questions about the codebase

---

## Error Handling

If any phase fails:
1. Mark the phase as blocked in task tracking
2. Explain what went wrong
3. Ask the user how to proceed:
   - Retry the phase
   - Skip to next phase (if possible)
   - Abort the workflow

If an agent returns incomplete results:
- Note the gaps in coverage
- Continue with available information
- Document limitations in the final report

---

## Agent Coordination

When launching parallel agents in Phase 1:
- Give each agent a distinct focus area
- Wait for all agents to complete before synthesizing
- Handle agent failures gracefully (continue with partial results)

When calling Task tool for agents:
- Use `model: "opus"` for codebase-analyzer agent
- Use default model (sonnet) for code-explorer and report-generator agents
- Use `run_in_background: false` to wait for results
