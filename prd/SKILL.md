---
name: prd
description: Create Product Requirements Documents (PRDs) through structured interviews. Use when the user asks to create a PRD, write requirements, spec out a feature, or needs help defining what to build.
---

# PRD (Product Requirements Document)

Create PRDs by interviewing the user and documenting requirements in a structured format.

**Important: Do NOT start implementing. Just create the PRD.**

## Step 1: Explore the Project

Before asking questions, thoroughly explore the codebase to understand:

1. **Project structure and architecture** - Examine directory layout, key modules, and how components connect
1. **Existing patterns** - Look at how similar features are implemented (UI patterns, API patterns, data models)
1. **Technology stack** - Identify frameworks, libraries, and tools already in use
1. **Related code** - Find existing code that relates to the feature being requested
1. **Documentation** - Check `spec/README.md`, existing PRDs in `spec/`, and any relevant docs

**Use the Task tool with `subagent_type=Explore`** to investigate the codebase. Spend adequate time understanding the project before interviewing.

This exploration ensures you:

- Don't ask questions the codebase already answers
- Understand constraints and patterns to follow
- Can ask informed questions about tradeoffs
- Propose solutions that fit the existing architecture

## Step 2: Get Next PRD Number

Run the script to determine the next PRD number:

```bash
<skill-location-dir>/scripts/get-next-prd-number .
```

## Step 3: Interview the User

After exploring the codebase, conduct a focused discussion about **decisions you cannot infer from the code**.

### What NOT to ask (learn from exploration instead):

- Basic project structure or tech stack
- How existing features work
- Current patterns or conventions
- What files/components exist

### What TO ask (requires human input):

**Tradeoffs and design decisions:**

- When there are multiple valid approaches, which does the user prefer and why?
- What should happen in ambiguous edge cases?
- How should this feature prioritize competing concerns (e.g., simplicity vs flexibility, performance vs maintainability)?

**Scope and boundaries:**

- What are the explicit non-goals?
- What's the MVP vs nice-to-have?
- Are there constraints not visible in the code (timeline, team expertise, external dependencies)?

**Business logic and UX:**

- User-facing copy, labels, or messaging
- Error handling preferences (fail silently vs surface errors)
- Behavior in edge cases that require product decisions

**Requirements that need human judgment:**

- Performance thresholds
- Accessibility requirements beyond baseline
- Integration points with external systems

**Rules for interviewing:**

- Ask **no more than 3-5 questions at a time**
- **Start by sharing what you learned** from exploration - this shows the user you've done homework and lets them correct misunderstandings
- Focus questions on decisions, not facts
- It's OK to have multiple rounds of questions
- Listen actively and ask follow-up questions
- Clarify ambiguities before writing the PRD
- **Test data handling:** If the user provides sample/test data (e.g., API responses, database records, file contents) for manual testing or validation purposes, do NOT include this data in the PRD. Real data shared during the interview should not end up in unit tests, test fixtures, or any persisted test files. The PRD should describe *what* to test and *how*, but not contain actual test data that could be copied into automated tests.

## Step 4: Write the PRD

Save to: `spec/NNNN-prd-[feature-name].md` (e.g., `spec/0007-analytics-dashboard.md`)

Use the following structure:

______________________________________________________________________

## PRD Structure

```markdown
# PRD: [Feature Name]

## Overview

Brief description of the feature and the problem it solves. What is this? Why are we building it? Why now?

## Goals

What we are trying to achieve:

- Goal 1
- Goal 2
- Goal 3

## Non-Goals

What we are explicitly NOT doing:

- Non-goal 1
- Non-goal 2

## User Stories

### US-001: [User Story Title]

**As a** [role]
**I want** [capability]
**So that** [benefit]

**Steps to verify:**
1. [Precondition or setup step]
2. [Action to take]
3. [Another action]
4. **Expected:** [What should happen]

**Documentation:** [Yes/No - Does this story require README or other docs to be updated?]

### US-002: [Next User Story]

...

## Functional Requirements

| ID | Requirement | Notes |
|----|-------------|-------|
| FR-001 | [Clear, unambiguous requirement] | [Optional notes] |
| FR-002 | [Another requirement] | |
| FR-003 | [Another requirement] | |

Requirements must be:
- Numbered (FR-001, FR-002, ...)
- Unambiguous and testable
- Written in "shall" or "must" language when appropriate

## Non-Functional Requirements

| ID | Requirement | Notes |
|----|-------------|-------|
| NFR-001 | [e.g., Feature must work on light and dark themes] | |
| NFR-002 | [e.g., Page must load in under 2 seconds] | |
| NFR-003 | [e.g., Must be accessible via keyboard navigation] | |

## Testing Plan

> **Note:** Do not include real/live test data in this section. Describe what to test and how, but do not embed actual data samples that the user shared during the interview. Real data should not be persisted in unit tests or test fixtures.

### Testing Strategy

Describe the types of testing required:
- Unit tests
- Integration tests
- E2E tests (Playwright scripts)
- API tests (curl, httpie)

### Test Scenarios

| Scenario | Type | Verification Method |
|----------|------|---------------------|
| [Scenario 1] | E2E | Playwright script |
| [Scenario 2] | API | curl / httpie |
| [Scenario 3] | Unit | pytest / jest |

### Edge Cases

- [Edge case 1 to test]
- [Edge case 2 to test]
- [Error conditions to verify]
```

______________________________________________________________________

## Checklist Before Saving

Verify all items before saving the PRD:

- [ ] Overview clearly explains what and why
- [ ] Goals are specific and measurable
- [ ] Non-goals explicitly state what is out of scope
- [ ] All user stories have the As/I want/So that format
- [ ] All user stories have numbered verification steps
- [ ] All user stories specify whether documentation updates are required
- [ ] All functional requirements are numbered (FR-XXX)
- [ ] All functional requirements are unambiguous and testable
- [ ] Non-functional requirements are included (themes, performance, accessibility)
- [ ] Testing plan covers all user stories
- [ ] Testing plan specifies verification methods (curl, Playwright, pytest, etc.)
- [ ] Edge cases are documented
- [ ] File is saved to `spec/NNNN-prd-[feature-name].md` with correct number
- [ ] No open questions or ambiguities remain in the document
