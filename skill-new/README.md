# Skill New

Cross-agent guide for creating or updating Agent Skills. Use it when you need a structured workflow to gather requirements, pick the right installation path, scaffold files, and validate instructions, regardless of which coding agent (Claude Code, OpenCode, Codex, Gemini CLI, Cursor, etc.) you run.

## Included Resources

- `scripts/detect-skill-paths.sh` – Finds project/user skill directories, preferring a project-level `skills/` folder when present.
- `scripts/init-skill.sh` – Generates the recommended `SKILL.md` skeleton with `[TODO: ...]` markers plus `scripts/`, `references/`, and `assets/` directories.
- `references/` – Mirrors the official Agent Skills documentation from [https://agentskills.io](https://agentskills.io) (`home.md`, `integrate-skills.md`, `specification.md`, `what-are-skills.md`) so the instructions can cite the spec offline.

Consult `SKILL.md` for full workflows, best practices, and validation checklists.
