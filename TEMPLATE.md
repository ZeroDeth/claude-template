# claude-template

A small starting point for any project that uses Claude Code. It gives the
agent what it needs on day one and grows as the project does.

## What you get

| File | Purpose |
|---|---|
| `CLAUDE.md` | Claude Code entry point, imports `AGENTS.md` |
| `AGENTS.md` | Commands, working rules, and when to add more structure (any agent, <https://agents.md>) |
| `TASKS.md` | The plan |
| `README.md` | Public description |
| `.claude/settings.json` | Denies reads of `.env` and `secrets/` |
| `.gitignore` | Keeps secrets and `.claude/settings.local.json` out of git |

## Use it

1. Create a repo from this template (GitHub: Use this template), or clone
   it and run `rm -rf .git && git init`.
2. Fill the placeholders: `grep -rn '{{[A-Z_]*}}' .` (name, description,
   build, test and lint commands, and the licence text in `LICENSE`).
3. Write your first phase in `TASKS.md` and commit.
4. Delete this file.

## Grow it

Add structure as the project needs it. The table in `AGENTS.md` says when.

The fuller version of this template (rules, agents, skills, docs, drift
guard, bootstrap script) is on the `full` branch. Copy pieces from there
when a project needs them.
