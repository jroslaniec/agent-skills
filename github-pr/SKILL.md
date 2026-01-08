---
name: github-pr
description: Create GitHub pull requests using gh CLI with automatic stacked PR detection. Use when the user asks to create a PR, open a pull request, make a PR, or mentions creating/opening a pull request on GitHub.
---

# GitHub Pull Request

Create pull requests using GitHub CLI with stacked PR detection.

## Instructions

### Step 1: Gather Context

Run the skill's context-gathering script:

```bash
./gather-pr-context.sh
```

### Step 2: Analyze Context

From the script output, determine:

**Stacked vs Normal PR:**

- Parse `git log --oneline --decorate` for branch refs in parentheses
- First branch NOT current and NOT `main`/`origin/main` = parent branch
- Parent is `main` → Normal PR
- Parent is other branch → Stacked PR

**Push status:**

- `git log origin/<branch>..HEAD` empty → pushed ✓
- Shows commits → need to push first

**Existing PR:**

- `gh pr list` returns data → PR exists, offer to update
- Empty → create new PR

### Step 3: Push if Needed

```bash
git push -u origin HEAD
```

### Step 4: Create PR

**Normal PR:**

```bash
gh pr create --draft --base main --title "title" --body "body"
```

**Stacked PR:**

```bash
gh pr create --draft --base <parent-branch> --title "title" --body "body"
```

**Guidelines:**

- Use ticket number from branch name as title prefix (e.g., PAT-123)
- Keep description short and proportional to changes
- For stacked PRs, describe only THIS branch's changes
- Create in draft mode unless explicitly requested otherwise

### Step 5: Output

**Normal PR:**

```
Created PR
* Merge : `<branch>` into `main`
* PR URL: <url>
```

**Stacked PR:**

```
📚 Stacked PR 📚
* Merge    : `<branch>` into `<parent>`
* New PR   : <url>
* Parent PR: <parent-url or "⚠️ No Parent PR">
```

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Git remote configured
- Push access to repository
