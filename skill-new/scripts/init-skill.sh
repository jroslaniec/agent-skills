#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: init-skill.sh <skill-name> <target-directory>

Creates a new skill scaffold with the recommended structure:
- SKILL.md pre-filled with required sections
- scripts/, references/, and assets/ directories

Example:
  init-skill.sh processing-pdfs ~/.claude/skills
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 2 ]]; then
  echo "Error: missing required arguments" >&2
  usage >&2
  exit 1
fi

skill_name="$1"
target_root="$2"

if ! [[ "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: skill name must be lowercase, alphanumeric, and hyphenated (matching directory naming rules)." >&2
  exit 1
fi

mkdir -p "$target_root"
target_root_abs=$(cd "$target_root" && pwd)
skill_dir="$target_root_abs/$skill_name"

if [[ -e "$skill_dir" ]]; then
  echo "Error: $skill_dir already exists" >&2
  exit 1
fi

mkdir -p "$skill_dir/scripts" "$skill_dir/references" "$skill_dir/assets"

title=$(echo "$skill_name" | sed 's/-/ /g' | awk '{for (i=1; i<=NF; i++) {$i=toupper(substr($i,1,1)) substr($i,2)}}1')

cat > "$skill_dir/SKILL.md" <<EOF
---
name: $skill_name
description: [TODO: Describe what this skill does, when to use it, and include trigger keywords (≤1024 chars).]
---

# $title

## Overview
- [TODO: One-sentence summary of the skill's purpose.]
- [TODO: Mention user intents or trigger phrases that should activate this skill.]

## Bundled Resources
- `scripts/` – Add deterministic helpers. Reference them via `<skill-location-dir>/scripts/<script-name>` and explain inputs/outputs.
- `references/` – Store detailed docs, schemas, or policies. Link to each file from this section.
- `assets/` – Optional templates/resources included in outputs (images, boilerplate projects, etc.).
- [TODO: If the skill is informational-only, describe how to navigate references instead of scripts.]

## Quick Start
1. [TODO: Minimal steps to run the skill's primary workflow or reference checklist.]
2. [TODO: Include any commands or scripts users must run (state the working directory first when executing scripts).]
3. [TODO: Remind to confirm destructive actions with the user.]

## Core Workflow
1. [TODO: Step-by-step instructions or knowledge navigation guidance.]
2. [TODO: Reference scripts and documents where deeper context is needed.]
3. [TODO: Mention testing/verification requirements (e.g., run tests, validate outputs).]

## Helper Scripts
| Script | Purpose | Notes |
| --- | --- | --- |
| `<skill-location-dir>/scripts/example.sh` | [TODO: Describe what the script automates.] | [TODO: Document inputs/outputs, confirm it's executable.] |

## Important Rules
- **ALWAYS** [TODO: Critical requirement.]
- **NEVER** [TODO: Forbidden action.]
- Keep `SKILL.md` under 500 lines; move detailed material into `references/`.
- Reference supporting files one level deep and mention `<skill-location-dir>` when pointing to scripts.

## Checklist
- [ ] Frontmatter name matches directory; description states WHAT + WHEN + triggers.
- [ ] Quick Start and Core Workflow are copy/paste ready and up to date (or replaced with reference navigation if informational-only).
- [ ] Scripts (if any) are executable (`chmod +x`) and documented above.
- [ ] References are linked here exactly once with clear usage guidance.
- [ ] User knows how to enable the skill, restart their agent, and test triggers.
EOF

cat <<EOF
Initialized skill scaffold at: $skill_dir

Next steps:
1. Edit $skill_dir/SKILL.md and replace the TODOs with real instructions.
2. Add helper scripts or reference files as needed (remember to document them in SKILL.md).
3. Ensure scripts are executable with chmod +x.
4. Validate the skill with tools like skills-ref and restart your agent to load it.
EOF
