---
paths:
  - "**/*.md"
---

# Documentation rules

Loaded only when Claude is reading or editing markdown files.

## Style

- No em-dashes (`—`). Use commas, semicolons, or restructure the sentence.
- No AI-buzzword vocabulary: avoid "leverage", "robust", "comprehensive",
  "streamline", "cutting-edge", "deep dive", "synergy", "holistic",
  "delve".
- Technical terms must be exact. Write the actual name of the library,
  framework, or tool, not a generic description.
- Code examples must be copy-pasteable. If you write a bash block, run
  it before committing.

## Steering files (CLAUDE.md, AGENTS.md)

Before editing `CLAUDE.md` or `AGENTS.md`, see the rules in `CLAUDE.md`
itself. Anthropic targets under 200 lines for `CLAUDE.md`
(<https://code.claude.com/docs/en/memory>). The pre-commit drift guard
at `scripts/check-claude-structure.sh` enforces this automatically.

New conventions go to `.claude/rules/*.md` with `paths:` frontmatter;
new how-to content goes to `docs/`; multi-step procedures go to
`.claude/skills/`.

## Markdownlint

Pre-commit runs markdownlint with `--disable MD013 MD033 MD041`. Common
gotchas the remaining rules catch:

- **MD024 (no-duplicate-heading):** each heading must be unique within
  its parent. `CHANGELOG.md` uses an inline
  `<!-- markdownlint-disable MD024 -->` directive because
  keep-a-changelog reuses "### Added" / "### Changed" / "### Fixed" per
  release.
- **MD036 (no-emphasis-as-heading):** bold paragraphs are not a
  workaround for duplicate headings. Use real headings or rename one.
- **MD040 (fenced-code-block-language):** code blocks need a language
  tag (use `text` for non-language content like ASCII diagrams).
- **MD056 (table-column-count):** literal `|` characters inside table
  cells are counted as column separators. Escape with `\|` or rephrase.

## HTML comments

Block-level HTML comments (`<!-- ... -->`) in CLAUDE.md and AGENTS.md
are stripped before injection into Claude's context
(<https://code.claude.com/docs/en/memory>). They cost zero context
tokens. Use them freely for maintainer notes that humans should see but
Claude does not need. Comments inside fenced code blocks are preserved.

## Doc tree structure

| File | Purpose |
|------|---------|
| `README.md` | Public-facing project intro and quickstart |
| `CHANGELOG.md` | Keep-a-changelog release history |
| `TASKS.md` | Phased implementation plan, current status |
| `TODO.md` | Known gaps and post-mortems |
| `CLAUDE.md` | Steering for Claude Code (thin, imports AGENTS.md) |
| `AGENTS.md` | README for any coding agent (cross-vendor <https://agents.md> spec) |
| `docs/ARCHITECTURE.md` | Package layout, dependency graph, request flow |
| `docs/CONVENTIONS.md` | Full code style and testing reference |
| `docs/HARNESS.md` | Harness engineering, loop engineering, Hermes Agent reference |
| `docs/ORCHESTRATION.md` | Multi-agent composition patterns |
| `docs/SETUP.md` | Contributor onboarding |
| `docs/TROUBLESHOOTING.md` | Common errors and fixes |
| `.claudeignore` | Files Claude Code should never load into context |
| `.claude/agents/*.md` | Subagent role definitions (frontmatter-driven) |
| `.claude/skills/*/SKILL.md` | Slash-invokable playbooks |
| `.claude/commands/*.md` | Custom slash commands (`/build`, `/test`, `/lint`, `/run`) |
| `.claude/rules/*.md` | Path-scoped rules (this directory) |
