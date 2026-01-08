---
name: git-commit
description: Create git commits with appropriate commit messages. Use when the user asks to commit, create a commit, write a commit message, or mentions "commit" in the context of saving changes to git.
---

# Git Commit

## Step 1: Gather Context

Run the skill's context-gathering script:

```bash
./gather-commit-context.sh
```

## Step 2: Decide Commit Style

**One-line** when: \<100 lines, simple change, user asks for "short/quick commit"

**Detailed** when: >100 lines, multiple components, user asks for "detailed commit"

**Match project style**: Use conventional commits (feat:, fix:) only if recent commits use them.

## Step 3: Create Commit

```bash
git commit -m "message"
git commit -m "title" -m "- bullet 1
- bullet 2"
```

## Rules

- NEVER include "generated with Claude Code" or "Co-Authored-By"
- NEVER do `git add .`
- If pre-commit modifies files: add them and retry
- If pre-commit fails: ask user
