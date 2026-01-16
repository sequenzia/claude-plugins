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
