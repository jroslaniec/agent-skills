# Agent Skills

Personal collection of Agent Skills for AI coding agents (Claude Code, Codex, etc.).

## Installation

Install using (my) [agent-skill-manager](https://github.com/jroslaniec/agent-skill-manager):

```bash
# Enable skills interactively
sm add -i git@github.com:jroslaniec/agent-skills.git

# Or enable specific skills
sm add git@github.com:jroslaniec/agent-skills.git/git-commit
sm add git@github.com:jroslaniec/agent-skills.git/github-pr
sm add git@github.com:jroslaniec/agent-skills.git/git-worktree
sm add git@github.com:jroslaniec/agent-skills.git/prd
sm add git@github.com:jroslaniec/agent-skills.git/taskify-prd
```

Skills will be symlinked to your coding agent's config directory (e.g., `~/.claude/skills/` for Claude Code).

## Available Skills

| Skill          | Description                                              |
| -------------- | -------------------------------------------------------- |
| `git-commit`   | Create git commits with appropriate messages             |
| `github-pr`    | Create GitHub PRs with stacked PR detection              |
| `git-worktree` | Manage git worktrees and branches                        |
| `prd`          | Create Product Requirements Documents through interviews |
| `taskify-prd`  | Convert PRDs to executable task files                    |

## Agent Loop (Ralph Loop)

This repo includes `bin/agent_loop` - an implementation of the [Ralph Loop](https://ghuntley.com/ralph/) pattern for autonomous task execution.

### Workflow

**1. Create a PRD using the skill:**

```
/prd Add user authentication with email/password login
```

This interviews you and creates `spec/NNNN-prd-feature-name.md`.

**2. Convert PRD to tasks:**

```
/taskify-prd
```

This creates `spec/NNNN-tasks.json` with executable tasks.

**3. Initialize and run the loop:**

```bash
# Add agent-loop to your PATH
export PATH=$PATH:/path/to/agent-skills/bin

# Create loop prompt (reads tasks file, substitutes paths)
agent-loop init

# Start autonomous execution
agent-loop
```

### agent-loop Usage

```
agent-loop [init | [-n N] [--prd NUM] [-- AGENT_CMD...]]
```

| Option      | Description                                                                |
| ----------- | -------------------------------------------------------------------------- |
| `init`      | Create `spec/prompt.md` and `spec/loop/` files                             |
| `-n N`      | Maximum iterations (default: 10)                                           |
| `--prd NUM` | Use specific PRD number (default: latest)                                  |
| `-- CMD`    | Custom agent command (default: `claude -p --dangerously-skip-permissions`) |

**Examples:**

```bash
# Run with defaults (latest tasks, 10 iterations, claude)
agent-loop

# Limit to 5 iterations
agent-loop -n 5

# Target specific PRD
agent-loop --prd 8

# Use different agent
agent-loop -- codex --dangerously-skip-permissions
```

The loop continues until all tasks pass (`passes: true`) or the iteration limit is reached.
