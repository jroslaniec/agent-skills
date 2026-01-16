# Agent Skills Repository

Personal collection of agent skills following the [Agent Skills](https://agentskills.io) open standard.

## Structure

Each skill lives in its own directory with a `SKILL.md` file and optional `scripts/` folder:

- `git-commit/` - Create git commits with appropriate messages
- `github-pr/` - Create GitHub PRs with stacked PR detection
- `git-worktree/` - Manage git worktrees and branches

## Adding Skills

1. Create a directory matching the skill name (lowercase, hyphens only)
1. Add a `SKILL.md` with required frontmatter (`name`, `description`)
1. Put helper scripts in `scripts/` if needed

## Notes

- Skills must not include AI attribution in outputs (commits, PRs, etc.)
- Use `<skill-location-dir>` placeholder for paths to skill scripts
