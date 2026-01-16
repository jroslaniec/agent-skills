---
name: taskify-prd
description: Convert PRDs to prd.json task format for autonomous execution. Use when you have an existing PRD in spec/ and need to break it into executable tasks. Triggers on: convert prd to tasks, taskify this prd, create tasks from prd, generate prd.json.
---

# Taskify PRD

Convert existing PRDs from `spec/` directory into `spec/prd.json` - a structured task format for autonomous execution.

**Important: Do NOT start implementing. Just create the tasks file.**

## Step 1: Gather Project Context

Check for project configuration to determine relevant verification criteria (skip if already known):

```bash
# Check for common config files
ls -la package.json Makefile pyproject.toml .pre-commit-config.yaml 2>/dev/null

# Check for project info in spec/
[ -f spec/README.md ] && cat -n spec/README.md
```

Based on findings, determine which verification criteria apply:

- `package.json` → "npm run build passes", "npm test passes"
- `Makefile` → "make lint passes", "make test passes"
- `pyproject.toml` → "pytest passes", "ruff check passes"
- `.pre-commit-config.yaml` → "pre-commit passes"

## Step 2: Check for Existing prd.json

Before creating a new prd.json, check if one exists:

```bash
[ -f spec/prd.json ] && cat spec/prd.json
```

If it exists and has a different `prd` field than the new PRD:

1. **Ask the user** if they want to archive it
1. If yes, archive to: `spec/archive/{prd-name}-prd.json`

```bash
mkdir -p spec/archive
mv spec/prd.json spec/archive/{old-prd-name}-prd.json
```

## Step 3: Read the Source PRD

The PRD must exist in `spec/` directory. Read it:

```bash
cat spec/NNNN-prd-feature-name.md
```

## Step 4: Convert to Tasks

Transform the PRD into `spec/prd.json` using this format:

```json
{
  "prd": "[PRD filename without .md, e.g., 0007-analytics-dashboard]",
  "branchName": "[feature-name-kebab-case]",
  "description": "[Feature description from PRD overview]",
  "userStories": [
    {
      "id": "US-001",
      "title": "[Task title]",
      "description": "As a [user], I want [feature] so that [benefit]",
      "acceptanceCriteria": [
        "Criterion 1",
        "Criterion 2",
        "[Verification criteria based on project: build passes, tests pass, etc.]"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

______________________________________________________________________

## Task Sizing: The Critical Rule

**Each task must be completable in ONE context window.**

If a task is too big, the agent runs out of context before finishing and produces incomplete work.

### Right-sized tasks:

- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

### Too big (split these):

- "Build the entire dashboard" → Split into: schema, queries, UI components, filters
- "Add authentication" → Split into: schema, middleware, login UI, session handling
- "Refactor the API" → Split into one task per endpoint or pattern

**Rule of thumb:** If you cannot describe the change in 2-3 sentences, it is too big.

______________________________________________________________________

## Task Ordering: Dependencies First

Tasks execute in priority order. Earlier tasks must not depend on later ones.

**Correct order:**

1. Schema/database changes (migrations)
1. Server actions / backend logic
1. UI components that use the backend
1. Dashboard/summary views that aggregate data

**Wrong order:**

1. UI component (depends on schema that does not exist yet)
1. Schema change

______________________________________________________________________

## Acceptance Criteria: Must Be Verifiable

Each criterion must be something the agent can CHECK, not something vague.

### Good criteria (verifiable):

- "Add `status` column to tasks table with default 'pending'"
- "Filter dropdown has options: All, Active, Completed"
- "Clicking delete shows confirmation dialog"
- "Build passes"
- "Tests pass"

### Bad criteria (vague):

- "Works correctly"
- "User can do X easily"
- "Good UX"
- "Handles edge cases"

### Always include relevant verification criteria:

Based on project setup, include applicable ones:

- "pre-commit passes"
- "npm run build passes" / "make build passes"
- "npm test passes" / "pytest passes" / "make test passes"

______________________________________________________________________

## Splitting Large PRDs

If a PRD has big features, split them:

**Original:**

> "Add user notification system"

**Split into:**

1. US-001: Add notifications table to database
1. US-002: Create notification service for sending notifications
1. US-003: Add notification bell icon to header
1. US-004: Create notification dropdown panel
1. US-005: Add mark-as-read functionality
1. US-006: Add notification preferences page

Each is one focused change that can be completed and verified independently.

______________________________________________________________________

## Step 5: Verify the Output

Run the verification script to ensure valid structure:

```bash
<skill-location-dir>/scripts/verify-tasks.py spec/prd.json
```

______________________________________________________________________

## Checklist Before Saving

Before writing prd.json, verify:

- [ ] **Existing prd.json archived** (if it exists with different prd name)
- [ ] `prd` field matches source PRD filename (without .md)
- [ ] `branchName` is kebab-case feature name
- [ ] Each task is completable in one context window (small enough)
- [ ] Tasks are ordered by dependency (schema → backend → UI)
- [ ] Acceptance criteria are verifiable (not vague)
- [ ] Relevant verification criteria included (build, test, lint based on project)
- [ ] No task depends on a later task
- [ ] All tasks have `passes: false` and empty `notes`
- [ ] Verification script passes
