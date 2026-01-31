---
name: skill-new
description: Create or update Agent Skills for any supported coding agent. Use when the user asks how to author a skill, requests a new skill directory, or needs updates for their installed coding agent(s).
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Skill New (Cross-Agent)

Use this skill to guide users through planning, authoring, and testing Agent Skills for any supported coding agents. Prefer a project-level `skills/` directory when it exists; otherwise detect installed agents and confirm the destination with the user before writing files.

## Overview

- Helps determine where to place skills (project vs personal) and how to scaffold them consistently.
- Includes helper scripts for path detection and initializing a skill skeleton.
- Bundles the official Agent Skills specification and overview docs for offline reference.
- Applicable to both procedural workflows and informational/documentation skills.

## Bundled Resources

- `scripts/detect-skill-paths.sh` – Walks from the current directory up to `$HOME`, checking for common skill directories (`skills/`, `.claude/skills/`, `~/.config/opencode/skills/`, etc.). **Always announce your working directory before running it.** Example success output:
  ```text
  Detected Agent Skill directories:
  - scope=project path=/repo/skills
  - scope=project path=/repo/.claude/skills
  - scope=user path=/Users/example/.claude/skills
  ```
  If nothing is found it prints `No well-known Agent Skill directories detected between <cwd> and <home>.` and exits with status 1.
- `scripts/init-skill.sh <skill-name> <target-dir>` – Creates `skill-name/` with `SKILL.md`, `scripts/`, `references/`, `assets/`, and a pre-filled template containing `[TODO: ...]` placeholders. Example:
  ```bash
  <skill-location-dir>/scripts/init-skill.sh processing-pdfs skills
  ```
- References (all paths are relative to the installed skill directory):
  - [`references/home.md`](references/home.md) – Agent Skills overview.
  - [`references/integrate-skills.md`](references/integrate-skills.md) – How agents discover skills.
  - [`references/specification.md`](references/specification.md) – Full spec (frontmatter rules, directory layout, validation).
  - [`references/what-are-skills.md`](references/what-are-skills.md) – Intro primer.

## Quick Start

1. **Announce current directory:** e.g., “Running from `/Users/me/project`”.
1. **Detect destinations:** run `<skill-location-dir>/scripts/detect-skill-paths.sh`. If a top-level `skills/` directory exists in the project, use that by default. Otherwise, review the script output.
1. **Clarify placement:**
   - If multiple locations are listed, ask the user where to install the skill (project `skills/`, `.claude/skills/`, personal config, etc.).
   - If nothing is detected, ask which agent(s) they use and whether to create `skills/` or `.claude/skills/` in the repo.
1. **Scaffold or edit:**
   - For new skills, run `<skill-location-dir>/scripts/init-skill.sh <skill-name> <target-dir>`.
   - For existing skills, open the current `SKILL.md` and supporting files.
1. **Document everything:** replace `[TODO: ...]` markers, describe scripts with `<skill-location-dir>`, and link references.
1. **Validate & test:** run `skills-ref validate`, ensure scripts are executable, and remind the user to restart their agent and test trigger phrases.

## Core Workflow

1. **Gather requirements** – Confirm scope (project `skills/` vs personal), supported agents, triggers/keywords, needed assets/scripts, and whether the skill is procedural or informational.
1. **Plan resources** – Decide which supporting files belong in `scripts/`, `references/`, or `assets/`. Prefer references for detailed documentation and scripts for deterministic tasks.
1. **Create directories** – Use the init script (preferred) or `mkdir -p <destination>/<skill-name>/{scripts,references,assets}`. Ensure the skill directory name matches the `name` field (lowercase hyphenated).
1. **Author `SKILL.md`** – Follow this section order (matching the template): Overview, Bundled Resources, Quick Start, Core Workflow, Helper Scripts, Important Rules, Checklist. Keep under ~500 lines and reference scripts via `<skill-location-dir>`.
   - For informational skills, describe how to navigate references instead of procedural steps.
1. **Add scripts/references** – Place helpers in `scripts/` (mark executable) and documentation in `references/`. Mention each file once in `SKILL.md` with guidance on when to read or run it.
1. **Validate & test** – Run `skills-ref validate <skill-path>` if available, lint/check scripts, and verify instructions by triggering the skill manually. Remind the user to restart their agent so changes load.

## Helper Scripts

| Script                                                     | Purpose                                                                             | Notes                                                                                                     |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `<skill-location-dir>/scripts/detect-skill-paths.sh`       | Finds project and user skill directories between the current directory and `$HOME`. | State working directory before running; ask the user which destination to use when multiple paths appear. |
| `<skill-location-dir>/scripts/init-skill.sh <skill> <dir>` | Bootstraps the recommended skill structure with `[TODO: ...]` placeholders.         | Validates skill names, creates `scripts/`, `references/`, `assets/`, and prints next steps.               |

## Important Rules & Best Practices

- **ALWAYS** announce the working directory before running helper scripts and confirm the installation path if multiple directories are detected.
- **ALWAYS** reference scripts using `<skill-location-dir>/...` so readers know paths resolve relative to the installed skill.
- **ALWAYS** include trigger keywords in the `description`; use lowercase hyphenated names matching the directory.
- **NEVER** exceed ~500 lines in `SKILL.md`; move detailed material to `references/` and link to it once.
- **NEVER** include AI attribution in generated instructions, commits, or PRs.

## Recommended Skill Structure

```
skill-name/
├── SKILL.md              # Overview, Bundled Resources, Quick Start, Core Workflow, Helper Scripts, Important Rules, Checklist
├── scripts/              # Executable helpers (optional)
├── references/           # Detailed docs (optional)
└── assets/               # Templates/resources used in outputs (optional)
```

Mini-template excerpt (mirrors the init script):

```
## Overview
- [TODO: One-sentence summary]
- [TODO: Trigger phrases]

## Quick Start
1. [TODO: Minimal steps or navigation guidance]

## Core Workflow
1. [TODO: Procedural steps or reference map]

## Helper Scripts
| `<skill-location-dir>/scripts/example.sh` | [TODO: purpose] | [TODO: notes] |

## Important Rules
- **ALWAYS** [TODO]
- **NEVER** [TODO]

## Checklist
- [ ] [TODO: validations]
```

## Validation & Testing

- Run `skills-ref validate <skill-path>` (from the Agent Skills reference tooling) to catch schema issues.
- Ensure every script is executable (`chmod +x`) and includes usage instructions.
- If the skill depends on external assets or references, verify paths and mention them once.
- After updates, remind the user to restart their agent and test trigger phrases relevant to the description.

## Checklist before handing off

- [ ] Placement confirmed (project `skills/` preferred when present; otherwise agreed destination per agent).
- [ ] `SKILL.md` frontmatter valid; description states WHAT + WHEN + trigger keywords.
- [ ] Sections follow the recommended order and reference supporting files once using relative paths.
- [ ] Scripts documented with `<skill-location-dir>` and marked executable.
- [ ] References linked with clear “read when…” guidance (especially for informational skills).
- [ ] Validation/tests completed and the user reminded to restart their agent and exercise the skill.
