# SDD Interview Framework

This document defines the question categories and flow for conducting effective SDD interviews.

## Interview Phases

### Phase 1: Project Foundation
Establish basic project context before diving into details.

### Phase 2: Requirements Discovery
Understand what needs to be built and why.

### Phase 3: Technical Exploration
Gather technical constraints and architecture decisions.

### Phase 4: Design Considerations
Capture UI/UX requirements if applicable.

### Phase 5: Document Generation
Synthesize collected information into specifications.

---

## Question Categories

### Core Questions (Always Asked)

These questions form the foundation of every SDD interview:

1. **Project Identity**
   - What is the name of this project?
   - Is this a new product, a feature for an existing product, or an enhancement?
   - What existing codebase or system does this relate to (if any)?

2. **Problem Statement**
   - What problem are you trying to solve?
   - Who experiences this problem?
   - What happens if this problem isn't solved?

3. **Success Definition**
   - How will you know this project is successful?
   - What metrics or outcomes matter most?
   - What's the minimum viable version that would be useful?

4. **Scope Boundaries**
   - What is explicitly NOT part of this project?
   - Are there related features you're intentionally deferring?

5. **Detail Level Selection**
   - How detailed should the specifications be?
     - **High-level**: Overview and key decisions (good for early exploration)
     - **Mid-level**: Detailed requirements with some implementation guidance
     - **In-depth**: Comprehensive specs ready for immediate implementation

### Document Structure Questions

6. **Output Format**
   - Do you want a combined PRD or separate specification documents?
   - Combined: Single comprehensive document
   - Separate: Individual PRD, Tech Spec, and/or Design Spec

7. **Component Check**
   - Does this project have UI/UX components? (triggers Design Spec questions)
   - Does this project need timeline/milestone planning?

---

### Conditional Questions

#### For Product/Feature Projects

8. **User Context**
   - Who are the primary users?
   - What are their technical skill levels?
   - What's their current workflow for this task?

9. **User Stories**
   - What are the key actions users need to perform?
   - What's the most critical user journey?
   - Are there edge cases or error scenarios to handle?

10. **Functional Requirements**
    - What are the must-have features?
    - What are nice-to-have features?
    - Are there any regulatory or compliance requirements?

#### For Enhancement/Refactor Projects

11. **Current State**
    - What exists today?
    - What's working well that should be preserved?
    - What's broken or suboptimal?

12. **Change Scope**
    - What specifically needs to change?
    - Are there breaking changes to consider?
    - What's the migration strategy?

#### For Integration Projects

13. **Integration Points**
    - What systems need to connect?
    - What data flows between systems?
    - What are the authentication/authorization requirements?

---

### Deep-Dive Questions (Based on Detail Level)

#### Mid-Level and In-Depth Only

14. **Non-Functional Requirements**
    - What are the performance expectations?
    - What are the scalability requirements?
    - What are the security requirements?
    - What are the reliability/uptime requirements?

15. **Constraints**
    - Are there technology constraints (languages, frameworks)?
    - Are there infrastructure constraints?
    - Are there budget or resource constraints?
    - Are there timeline constraints?

#### In-Depth Only

16. **Edge Cases**
    - What happens when things go wrong?
    - What are the failure modes?
    - How should errors be communicated?

17. **Dependencies**
    - What external services or APIs are needed?
    - What internal systems does this depend on?
    - Are there team or organizational dependencies?

18. **Rollout Strategy**
    - How will this be deployed?
    - Is there a feature flag strategy?
    - What's the rollback plan?

---

### Technical Probes (For Tech Spec Generation)

19. **Architecture**
    - What's the high-level architecture approach?
    - Are there existing patterns to follow?
    - What components need to be created vs modified?

20. **Data**
    - What data entities are involved?
    - What's the data flow?
    - Are there data migration needs?

21. **APIs**
    - What APIs need to be created or consumed?
    - What are the request/response patterns?
    - What authentication is needed?

22. **Technology Stack**
    - What languages/frameworks are required?
    - Are there specific library requirements?
    - What's the testing strategy?

---

### UX Probes (For Design Spec Generation)

23. **User Flows**
    - What are the main user journeys?
    - What are the entry points?
    - What are the exit points/completion states?

24. **Interface Components**
    - What UI elements are needed?
    - Are there existing components to reuse?
    - What new components need to be designed?

25. **Interactions**
    - What are the key interactions?
    - What feedback should users receive?
    - What are the loading/error states?

26. **Accessibility**
    - What accessibility standards must be met?
    - Are there specific accessibility requirements?

---

## Interview Flow Guidelines

### Natural Conversation Principles

1. **Start Broad, Get Specific**
   - Begin with open-ended questions
   - Follow interesting threads
   - Circle back to cover gaps

2. **Validate Understanding**
   - Summarize key points periodically
   - Ask clarifying questions when needed
   - Confirm assumptions explicitly

3. **Adapt to Context**
   - Skip irrelevant questions
   - Dive deeper on complex areas
   - Respect time constraints

4. **Maintain Focus**
   - Keep conversation on track
   - Note tangential topics for later
   - Redirect gently when needed

### Question Sequencing

```
Foundation → Problem → Users → Requirements → Technical → Design → Wrap-up
```

### Red Flags to Probe

- Vague success criteria
- Unclear scope boundaries
- Conflicting requirements
- Missing stakeholder input
- Unrealistic constraints

### Completion Checklist

Before generating documents, ensure:
- [ ] Project name and type confirmed
- [ ] Problem statement articulated
- [ ] Success metrics defined
- [ ] Scope boundaries clear
- [ ] Detail level selected
- [ ] Output format chosen
- [ ] All applicable question categories covered

---

## Structured Question Templates

Use these templates with the `AskUserQuestion` tool for choice-based questions. Each template shows the exact format to use.

### Foundation Questions

#### Project Type
```json
{
  "header": "Type",
  "question": "What type of project is this?",
  "options": [
    {"label": "New Product", "description": "Building something entirely new from scratch"},
    {"label": "New Feature", "description": "Adding new functionality to an existing product"},
    {"label": "Enhancement", "description": "Improving or extending existing functionality"},
    {"label": "Refactor", "description": "Restructuring code without changing behavior"}
  ],
  "multiSelect": false
}
```

#### Detail Level
```json
{
  "header": "Detail",
  "question": "How detailed should the specifications be?",
  "options": [
    {"label": "High-level", "description": "Overview and key decisions - good for early exploration"},
    {"label": "Mid-level", "description": "Detailed requirements with implementation guidance"},
    {"label": "In-depth", "description": "Comprehensive specs ready for immediate implementation"}
  ],
  "multiSelect": false
}
```

### Scope Questions

#### Document Structure
```json
{
  "header": "Format",
  "question": "How should the specification documents be organized?",
  "options": [
    {"label": "Combined PRD", "description": "Single comprehensive document with all sections"},
    {"label": "Separate Specs", "description": "Individual PRD, Tech Spec, and Design Spec files"}
  ],
  "multiSelect": false
}
```

#### Project Components
```json
{
  "header": "Components",
  "question": "What components does this project include?",
  "options": [
    {"label": "UI/UX", "description": "Has user interface elements requiring design spec"},
    {"label": "API/Backend", "description": "Has server-side logic requiring tech spec"},
    {"label": "Data/Storage", "description": "Has data models or persistence needs"},
    {"label": "Integrations", "description": "Connects to external systems or services"}
  ],
  "multiSelect": true
}
```

### Requirements Questions

#### Constraints
```json
{
  "header": "Constraints",
  "question": "What constraints affect this project?",
  "options": [
    {"label": "Technology", "description": "Must use specific languages, frameworks, or libraries"},
    {"label": "Infrastructure", "description": "Cloud, on-prem, or specific platform requirements"},
    {"label": "Budget", "description": "Cost limitations affecting technology choices"},
    {"label": "Timeline", "description": "Hard deadlines or aggressive schedule"}
  ],
  "multiSelect": true
}
```

#### Non-Functional Requirements
```json
{
  "header": "NFRs",
  "question": "Which non-functional requirements are priorities?",
  "options": [
    {"label": "Performance", "description": "Response time, throughput, latency requirements"},
    {"label": "Scalability", "description": "Must handle growth in users or data"},
    {"label": "Security", "description": "Authentication, authorization, data protection"},
    {"label": "Reliability", "description": "Uptime, fault tolerance, disaster recovery"}
  ],
  "multiSelect": true
}
```

### Design Questions

#### Accessibility
```json
{
  "header": "A11y",
  "question": "What accessibility standards apply?",
  "options": [
    {"label": "WCAG AA", "description": "Standard web accessibility compliance"},
    {"label": "WCAG AAA", "description": "Enhanced accessibility for specialized needs"},
    {"label": "Custom", "description": "Specific organizational requirements"},
    {"label": "Minimal", "description": "Basic accessibility, no formal standards"}
  ],
  "multiSelect": false
}
```

---

## Question Grouping Strategy

Group related questions to reduce interview length and improve user experience.

### Batch 1: Project Identity
Ask these open-ended questions first to establish context:
- Project name
- Existing codebase/system context
- Target date (if any)

### Batch 2: Project Configuration
Use AskUserQuestion with up to 4 questions together:
- Project type (single-select)
- Detail level (single-select)
- Document structure (single-select)
- Project components (multi-select)

### Batch 3: Problem & Goals
Gather narrative context through open-ended questions:
- Problem statement
- Affected users
- Success metrics
- Non-goals/scope boundaries

### Batch 4: Requirements Filters
Use AskUserQuestion for quick categorization:
- Constraints (multi-select)
- NFR priorities (multi-select)

### Batch 5: Deep-Dive (Conditional)
Based on selected components and detail level:
- Technical questions (if API/Backend or Data/Storage selected)
- Design questions (if UI/UX selected)

### Best Practices for Grouping

1. **Maximum 4 questions per AskUserQuestion call** - Tool limitation
2. **Group by decision type** - Keep related choices together
3. **Open-ended first, structured second** - Gather context before offering options
4. **Validate batches before proceeding** - Summarize and confirm understanding
