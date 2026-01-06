---
name: github-pr
description: Create GitHub pull requests using gh CLI with automatic stacked PR detection. Use when the user asks to create a PR, open a pull request, make a PR, or mentions creating/opening a pull request on GitHub.
---

# GitHub Pull Request

This skill creates pull requests using the GitHub CLI (`gh`) with intelligent detection of stacked PRs (PRs built on top of other branches).

## Instructions

## Workflow

### 1. Detect Stack and Parent Branch

- Get current branch: `git rev-parse --abbrev-ref HEAD`
- Get commit history: `git log --oneline -20` (get more if needed to find branch refs)
- Parse the output to find parent branch:
  - First line shows current branch with `HEAD`
  - Look at subsequent commits for branch references in parentheses
  - First branch that is NOT current branch and NOT `main`/`origin/main` = parent branch
  - If parent branch is `main` or `origin/main` → **Normal PR**
  - If parent branch is something else → **Stacked PR**

### 2. Check for Parent PR (Stacked PR only)

- Check if parent branch has open PR: `gh pr list --head <parent-branch> --state open --json number,url`
- Store parent PR number and URL if exists

### 3. Prepare PR Context

**For Normal PR:**

- Target branch: `main`
- Review commits: `git log --oneline origin/main..HEAD`
- Check diff: `git diff origin/main...HEAD`

**For Stacked PR:**

- Target branch: `<parent-branch>`
- Review commits: `git log --oneline <parent-branch>..HEAD` (only commits in THIS branch)
- Check diff: `git diff <parent-branch>...HEAD` (only changes in THIS branch)

### 4. Before Creating PR

- `git status` - verify working tree is clean
- `git push -u origin HEAD` - push branch if not already pushed
- **VERIFY PUSH**: Check that commits are on remote with `git log origin/$(git rev-parse --abbrev-ref HEAD)..HEAD`
  - If output is empty → commits are pushed ✓
  - If output shows commits → push failed or incomplete, DO NOT proceed
- `gh pr list --head $(git rev-parse --abbrev-ref HEAD)` - check if PR already exists

### 5. Create PR

- Look for `.github/pull_request_template.md` for PR template structure
- Use ticket number from branch name (e.g., PAT-123) as PR title prefix if present
- Keep PR description short and proportional to code changes - only fill necessary template sections
- Create PR in draft mode by default unless explicitly requested otherwise
- **For Normal PR**: `gh pr create --draft --base main`
- **For Stacked PR**: `gh pr create --draft --base <parent-branch>`

### 6. Output Format

**For Normal PR:**

```
Created PR
* Merge : `<current-branch>` into `main`
* PR URL: <new-pr-url>
```

**For Stacked PR (with parent PR):**

```
📚 Stacked PR 📚
* Merge    : `<current-branch>` into `<parent-branch>`
* New PR   : <new-pr-url>
* Parent PR: <parent-pr-url>
```

**For Stacked PR (no parent PR):**

```
📚 Stacked PR 📚
* Merge    : `<current-branch>` into `<parent-branch>`
* New PR   : <new-pr-url>
* Parent PR: ⚠️ No Parent PR ⚠️
```

## Important Notes

- Include ticket number in title if branch follows PAT-123 pattern
- Keep description concise - focus on what and why, not how
- Only fill template sections that add value
- For stacked PRs, describe only the changes in THIS branch, not the entire stack
- Git log limit: Default to 20 commits, fetch more if no branch refs found

## Requirements

- GitHub CLI (`gh`) must be installed and authenticated
- Git repository must have a remote configured
- User must have push access to the repository
