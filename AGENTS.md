# Agent Instructions

Personal collection of Agent Skills and Subagents following the [Agent Skills](https://agentskills.io) standard. Managed through `agent-skill-manager`; enabling a skill/subagent creates symlinks in each registered coding agent config directory.

## Repository Layout

```
repo/
├── <skill-name>/
│   ├── SKILL.md        # required; includes name/description frontmatter
│   └── scripts/…       # optional helpers referenced via <skill-location-dir>
├── <agent-name>/
│   └── AGENT.md        # required instructions + metadata for subagents
├── bin/agent-loop      # Ralph Loop helper CLI
└── docs/…              # helper guides (README, project-pytest-guidelines, …)
```

### Skills

- directories use lowercase with hyphens
- include `SKILL.md` frontmatter (`name`, `description`)
- optional `scripts/` folder for shared shell helpers
- no AI attribution in generated commits/PRs

### Subagents

- mirror the skill layout but with `AGENT.md`
- document purpose, workflows, and setup expectations
- surfaced automatically by `agent-skill-manager` as "subagents"

## Adding or Updating Entries

1. create directory matching the skill/subagent name
1. add the required instruction file (`SKILL.md` or `AGENT.md`)
1. place supporting scripts under `scripts/` and reference them via `<skill-location-dir>`
1. follow associated docs/tests (e.g., `project-pytest-guidelines.md`) when relevant

## Agent Loop Helpers

This repo ships `bin/agent-loop`, an implementation of the [Ralph Loop](https://ghuntley.com/ralph/) workflow used with the `prd` and `taskify-prd` skills (see README). Use it to bootstrap autonomous runs against the `spec/` directory produced by those skills.
