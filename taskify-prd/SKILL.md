---
name: taskify-prd
description: Convert PRDs to tasks.json format for autonomous execution. Use when you have an existing PRD in spec/ and need to break it into executable tasks. Triggers on: convert prd to tasks, taskify this prd, create tasks from prd, generate tasks.json.
---

# Taskify PRD

Convert existing PRDs from `spec/` directory into `spec/NNNN-tasks.json` - a structured task format for autonomous execution. The tasks file number prefix matches the PRD number prefix.

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

## Step 2: Check for Existing Tasks File

Check if a tasks file with the same number already exists:

```bash
ls spec/NNNN-tasks.json 2>/dev/null && cat spec/NNNN-tasks.json
```

If it exists:

1. **Ask the user** if they want to archive it
1. If yes, archive to: `spec/archive/NNNN-tasks.json`

```bash
mkdir -p spec/archive
mv spec/NNNN-tasks.json spec/archive/NNNN-tasks.json
```

## Step 3: Read the Source PRD

The PRD must exist in `spec/` directory. Read it:

```bash
cat spec/NNNN-prd-feature-name.md
```

## Step 4: Convert to Tasks

Transform the PRD into `spec/NNNN-tasks.json` (matching the PRD number) using this format:

```json
{
  "prd": "[Full PRD filename with .md, e.g., 0007-prd-analytics-dashboard.md]",
  "branchName": "[feature-name-kebab-case]",
  "description": "[Feature description from PRD overview]",
  "tasks": [
    {
      "id": "US-001",
      "title": "[Task title]",
      "description": "As a [user], I want [feature] so that [benefit]",
      "acceptanceCriteria": [
        "Criterion 1",
        "Criterion 2",
        "[Verification criteria based on project: build passes, tests pass, etc.]",
        "[If PRD specifies docs required: README updated with usage/configuration]"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

**Important:** The tasks file must be named `NNNN-tasks.json` where `NNNN` matches the PRD number prefix.

**Task ID prefixes:**

- `US-XXX` - User stories (new features from PRD)
- `BUG-XXX` - Bug fixes (from QA feedback)
- `FIX-XXX` - Fixes/corrections
- `TASK-XXX` - General tasks
- `ENH-XXX` - Enhancements

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

### Documentation updates:

**Important:** If the PRD specifies that a user story requires documentation updates, include this in the acceptance criteria for that task. Documentation is part of the deliverable, not a separate follow-up.

- Check each user story's "Documentation" field in the PRD
- If Yes, add criterion: "README updated with \[relevant section: usage, configuration, API, etc.\]"
- Documentation updates should be done in the same task as the feature implementation

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

## QA Feedback and PRD Appendix

After implementation, users may QA the feature and discover issues. This flow supports adding new tasks from QA feedback:

### When QA finds issues:

1. **Update the PRD** with an appendix section:

```markdown
## Appendix: QA Feedback (YYYY-MM-DD)

### Issue 1: [Brief description]
- **Found:** [What was observed]
- **Expected:** [What should happen]
- **Steps to reproduce:** [If applicable]

### Issue 2: ...
```

2. **Add new tasks to the tasks file** using appropriate prefixes:

```json
{
  "id": "BUG-001",
  "title": "Fix [issue description]",
  "description": "QA found: [description]. Expected: [correct behavior]",
  "acceptanceCriteria": [
    "Issue no longer reproducible",
    "Build passes",
    "Tests pass"
  ],
  "priority": 7,
  "passes": false,
  "notes": "From QA feedback YYYY-MM-DD"
}
```

3. **Assign priorities** that come after existing completed tasks (continue numbering)

### Task lifecycle:

- Initial implementation: `US-XXX` tasks from PRD user stories
- QA fixes: `BUG-XXX` or `FIX-XXX` tasks from QA feedback
- Enhancements: `ENH-XXX` for improvements discovered during QA

______________________________________________________________________

## Step 5: Verify the Output

Run the verification script to ensure valid structure:

```bash
<skill-location-dir>/scripts/verify-tasks spec/NNNN-tasks.json
```

______________________________________________________________________

## Checklist Before Saving

Before writing the tasks file, verify:

- [ ] **Existing tasks file archived** (if one exists with the same number)
- [ ] Tasks file named `NNNN-tasks.json` matching PRD number prefix
- [ ] `prd` field is the full PRD filename with `.md` extension
- [ ] `branchName` is kebab-case feature name
- [ ] Each task is completable in one context window (small enough)
- [ ] Tasks are ordered by dependency (schema → backend → UI)
- [ ] Acceptance criteria are verifiable (not vague)
- [ ] Relevant verification criteria included (build, test, lint based on project)
- [ ] Documentation updates included in acceptance criteria where PRD requires them
- [ ] No task depends on a later task
- [ ] All tasks have `passes: false` and empty `notes`
- [ ] Verification script passes
