---
name: prd
description: Create Product Requirements Documents (PRDs) through structured interviews. Use when the user asks to create a PRD, write requirements, spec out a feature, or needs help defining what to build.
---

# PRD (Product Requirements Document)

Create PRDs by interviewing the user and documenting requirements in a structured format.

**Important: Do NOT start implementing. Just create the PRD.**

## Step 1: Gather Project Context

Check if `spec/README.md` exists for general project information (skip if already loaded in conversation):

## Step 2: Get Next PRD Number

Run the script to determine the next PRD number:

```bash
<skill-location-dir>/scripts/get-next-prd-number.sh .
```

## Step 3: Interview the User

Conduct a discussion to understand the feature. Ask questions to gather:

- What is the feature? What problem does it solve?
- Who are the users?
- What are the goals? What are explicitly NOT goals?
- What are the main user flows/stories?
- What are the functional requirements?
- Any non-functional requirements? (performance, accessibility, theme support, etc.)
- How should this be tested?

**Rules for interviewing:**

- Ask **no more than 3-5 questions at a time**
- It's OK to have multiple rounds of questions
- Listen actively and ask follow-up questions
- Clarify ambiguities before writing the PRD

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
- [ ] All functional requirements are numbered (FR-XXX)
- [ ] All functional requirements are unambiguous and testable
- [ ] Non-functional requirements are included (themes, performance, accessibility)
- [ ] Testing plan covers all user stories
- [ ] Testing plan specifies verification methods (curl, Playwright, pytest, etc.)
- [ ] Edge cases are documented
- [ ] File is saved to `spec/NNNN-prd-[feature-name].md` with correct number
- [ ] No open questions or ambiguities remain in the document
