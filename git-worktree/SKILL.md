---
name: git-worktree
description: Manage git worktrees and branches. Use when the user asks to create a worktree, new worktree, create a branch, new branch, switch branches, or work on a new feature.
---

# Git Worktree and Branch Management

This skill helps create and manage git worktrees following a consistent directory structure and workflow.

## Worktree Directory Structure

When creating worktrees, follow this pattern:

**Current project location:** `~/projects/user-api`

**Worktree locations:**

- `~/projects/user-api-FEATURENAME` (where FEATURENAME is also the branch name)

**Examples:**

- `~/projects/payment-service-fix-transaction-bug` → branch: `fix-transaction-bug`
- `~/projects/user-api-add-authentication` → branch: `add-authentication`
- `~/projects/analytics-dashboard-update-charts` → branch: `update-charts`

## When to Create Worktree vs Branch

**Create worktree:** Only when user explicitly asks for "worktree"
**Create branch:** When user asks to create/start a branch without mentioning worktree

## Creating a Branch (without worktree)

### Workflow

1. **Check current branch:**

   ```bash
   git branch --show-current
   ```

1. **Determine base branch:**

   - If currently on `main` → create branch from `main`
   - If NOT on `main` and user didn't specify → **ask user which base branch to use**

1. **Create and switch to branch:**

   ```bash
   git checkout -b BRANCH_NAME
   ```

## Creating a Worktree

### Pre-flight Checks

Before creating a worktree, run the status check script to get all necessary information:

```bash
./scripts/check-worktrees.sh
```

This script provides:

- Current branch
- Remote sync status (whether origin/main is ahead)
- Existing worktrees with their status

Based on the script output:

1. **If NOT on main branch:**

   - Ask user: "Should the worktree be created from main branch or from the current branch?"
   - Wait for user response before proceeding

1. **If on main branch and remote is ahead:**

   - Ask: "Remote main has new commits. Would you like to pull before creating the worktree?"
   - If user says yes, pull:
     ```bash
     git pull origin main
     ```

### Creating the Worktree

1. **Determine paths:**

   - Get current project directory name (e.g., `user-api`)
   - Get parent directory path (e.g., `~/projects`)
   - Construct worktree path: `PARENT_DIR/PROJECT_NAME-FEATURE_NAME`

1. **Create worktree:**

   ```bash
   git worktree add -b BRANCH_NAME ../PROJECT_NAME-FEATURE_NAME BASE_BRANCH
   ```

   Where:

   - `BRANCH_NAME`: The feature branch name (e.g., `add-authentication`)
   - `../PROJECT_NAME-FEATURE_NAME`: The worktree directory path (e.g., `../user-api-add-authentication`)
   - `BASE_BRANCH`: Either `main` or the current branch (based on pre-flight check)

1. **After creation, inform user:**

   ```
   ✓ Worktree created successfully!

   Location: /full/path/to/worktree
   Branch: BRANCH_NAME

   To navigate to the worktree:

     cd /full/path/to/worktree

   For better experience, please add the worktree to your session:

     /add-dir /full/path/to/worktree
   ```

## Branch Naming

Use descriptive names without enforced prefixes:

- ✓ Good: `fix-balance-sheet-bug`, `add-settings-to-sidebar`, `update-readme`
- ✗ Avoid: `feat/`, `fix/` prefixes (unless user specifically requests them)

## Worktree Status Script

The `check-worktrees.sh` script provides comprehensive git and worktree information:

```bash
./scripts/check-worktrees.sh
```

**Output includes:**

- Current branch
- Remote sync status (fetch + check if remote is ahead)
- List of existing worktrees
- Worktree age (inactive for >30 days)
- Worktrees with merged branches
- Warning if many worktrees exist (>5)
- Cleanup candidates

**When to use:**

- Before creating a worktree (pre-flight checks)
- To check existing worktrees
- To identify old worktrees that can be cleaned up

## Removing Worktrees

When a feature is complete and merged:

```bash
# Remove the worktree
git worktree remove /path/to/worktree

# Delete the branch (if merged)
git branch -d BRANCH_NAME

# Delete remote branch (if needed)
git push origin --delete BRANCH_NAME
```

## Common Scenarios

### Scenario 1: User asks "create a branch for fixing authentication bug"

1. Check current branch: `git branch --show-current`
1. If on main → create branch from main
1. If not on main → ask which base branch to use
1. Create branch: `git checkout -b fix-authentication-bug`

### Scenario 2: User asks "create a worktree for adding payment integration"

1. Run status script: `./scripts/check-worktrees.sh`
1. Check script output for current branch and remote status
1. If not on main → ask: create from main or current branch?
1. If on main and remote is ahead → ask: pull before creating?
1. Create worktree: `git worktree add -b add-payment-integration ../user-api-add-payment-integration main`
1. Provide cd command: `cd ~/projects/user-api-add-payment-integration`
1. Inform user to add worktree: `/add-dir ~/projects/user-api-add-payment-integration`

### Scenario 3: User asks "switch to feature branch"

1. Check if branch exists locally: `git branch --list BRANCH_NAME`
1. If exists → switch: `git checkout BRANCH_NAME`
1. If not → ask if they want to create it or check it out from remote

## Important Notes

- **Never** create worktrees automatically when user just asks for a branch
- **Always** run `./scripts/check-worktrees.sh` before creating worktrees
- **Always** ask for confirmation when base branch is ambiguous
- **Always** remind user to add worktree directory to session after creation (`/add-dir`)
- Use the status script output to make informed decisions about pulling and cleanup
