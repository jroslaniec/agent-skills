# Agent Skills

Personal collection of Agent Skills for Claude Code.

## Installation

Install using (my) [agent-skill-manager](https://github.com/jroslaniec/agent-skill-manager):

```bash
# Enable skills interactively
sm add -i github.com/jroslaniec/agent-skills

# Or enable specific skills
sm add github.com/jroslaniec/agent-skills/git-commit
sm add github.com/jroslaniec/agent-skills/github-pr
sm add github.com/jroslaniec/agent-skills/git-worktree
```

Skills will be symlinked to `~/.claude/skills/` and available globally in Claude Code.
