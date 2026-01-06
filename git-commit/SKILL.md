---
name: git-commit
description: Create git commits with appropriate commit messages. Use when the user asks to commit, create a commit, write a commit message, or mentions "commit" in the context of saving changes to git.
---

# Git Commit

This skill helps create well-formatted git commits with messages that are proportional to the changes being committed.

## Instructions

### Choosing Commit Style

When the user asks to commit without specifying the style, automatically choose based on the changes:

**Use one-line commit (short) when:**

- User explicitly asks for "short commit", "quick commit", or "one-line commit"
- Changes are less than 100 lines
- Changes are simple/focused (e.g., single bug fix, small feature)
- Changes are auto-generated files (formatters, linters, build artifacts)
- Changes are straightforward refactoring or renaming

**Use detailed commit (with body) when:**

- User explicitly asks for "detailed commit", "longer commit", or "commit with description"
- Changes are more than 100 lines
- Changes involve multiple logical steps or components
- Changes introduce new features that need explanation
- Changes fix complex bugs that benefit from context

### Commit Message Types

**One-line commits** (for simple, focused changes):

- Title only, no body
- Concise and proportional to the changes
- Keep it brief but descriptive

**Detailed commits** (for complex or significant changes):

- Short, concise title
- Body with bullet points for important details
- Keep bullets to minimum with only important info
- OK to provide examples of testing (e.g., curl commands, but don't include secrets/credentials)

### Workflow

1. **Review changes** - The files are already staged. Use these commands to understand what you're committing:

   - `git diff --cached --name-only` - show list of files that are going to be committed
   - `git diff --cached` - show the full diff of the files that are going to be committed
   - `git log --oneline -n 5` - show last 5 commits (to match style)

1. **Determine commit style**:

   - Check if previous commits use conventional commit format
   - Only use conventional commits if the project already uses them
   - Choose one-line or detailed format based on change complexity

1. **Create the commit**:

   - The message should reflect the changes in the files, not what you were working on
   - Make the message proportional to the changes
   - Use `git commit -m "..."` for one-line commits
   - Use `git commit -m "title" -m "body"` for detailed commits with body

### Important Rules

- **NEVER** include "generated with Claude Code" or similar notes
- **NEVER** include "Co-Authored-By" or similar notes
- **NEVER EVER** do wildcard `git add .`. Always specify files explicitly.
- If pre-commit hooks run and modify files:
  - Selectively add the modified files with `git add <specific-files>`
  - Retry the commit
- If pre-commit fails for reasons other than formatting:
  - Stop and ask the user whether to fix the issue or continue

## Examples

**One-line commit example:**

```bash
git commit -m "fix: handle null values in user profile"
```

**Detailed commit example:**

```bash
git commit -m "feat: add user authentication" -m "- Implement JWT-based auth
- Add login/logout endpoints
- Include token refresh mechanism
- Tests: curl -X POST http://localhost:3000/api/login"
```
