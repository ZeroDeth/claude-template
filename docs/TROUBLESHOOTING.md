# Troubleshooting -- {{PROJECT_NAME}}

Common errors and their fixes. Add entries as you hit them.

## Drift guard fails with "CLAUDE.md is N lines, must stay <=200"

You added content to `CLAUDE.md` that pushes it past Anthropic's
published 200-line target
(<https://code.claude.com/docs/en/memory>).

**Fix:** move the new content out of `CLAUDE.md` into one of these
homes, then reference it from `CLAUDE.md` with an `@` import or a
plain-prose link:

- Path-scoped rule: `.claude/rules/*.md` with a `paths:` frontmatter
  glob. Loads only when Claude is editing matching files.
- On-demand playbook: `.claude/skills/{name}/SKILL.md`. Loads when
  invoked via `/{name}` or when Claude matches the description.
- Long-form reference: `docs/*.md`. Loads only when read.

HTML comments (`<!-- ... -->`) inside `CLAUDE.md` are stripped before
context injection, so maintainer notes cost zero tokens and can stay
in the file.

## Drift guard fails with "machine-local path references found"

A tracked file contains a reference to something that only exists on
one machine. The guard looks for four categories:

1. Home-directory shortcut references to the Claude Code config
   directory (the tilde prefix followed by the config folder).
2. Absolute paths under a user home directory on macOS (anything
   beginning with the `/Users/<name>` prefix).
3. References to the Claude Code auto-memory directory, which lives
   under the user's home and is machine-local by design per
   <https://code.claude.com/docs/en/memory>.
4. The specific broken memory filename from a past incident (recorded
   in the drift guard source for posterity).

Any of these break for every contributor who is not the person who
wrote the reference. The Claude Code auto-memory directory is
machine-local by design per
<https://code.claude.com/docs/en/memory>, so it must never be
referenced from a committed file.

**Fix:** inline the content into the repo (HTML comments in
`CLAUDE.md` are a good place for maintainer rationale), or replace
with a link to a publicly reachable URL.

Exception: `CHANGELOG.md` may reference these paths in historical
entries describing past state. See `scripts/check-claude-structure.sh`
for the exact regex and the exclude list.

## Drift guard fails with "agents/skills missing 'name:' frontmatter"

A `.claude/agents/*.md` or `.claude/skills/*/SKILL.md` file is
missing the YAML frontmatter block or its `name:` field.

**Fix:** add the frontmatter at the top of the file:

```markdown
---
name: your-skill-name
description: What this skill does and when to use it.
---

Skill body...
```

## Drift guard fails with ".gitignore missing negation"

Someone edited `.gitignore` and accidentally removed one of the
`!.claude/rules/`, `!.claude/agents/`, or `!.claude/skills/`
negations.

**Fix:** add the missing negation line back. The bare `.claude/*`
glob hides everything under `.claude/` by default; the negations
whitelist the three directories that are meant to be version-
controlled.

## Pre-commit hook hangs on first run

The first `pre-commit run` downloads the hook environments, which can
take a minute or two on a cold cache. Subsequent runs are fast.

If it hangs for more than a few minutes, check `~/.cache/pre-commit/`
for a stuck download and `rm -rf` it, then retry.
