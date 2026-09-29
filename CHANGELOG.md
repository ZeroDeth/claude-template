<!-- markdownlint-disable MD024 -->
<!--
  MD024 (no-duplicate-heading) is disabled for this file because the
  Keep a Changelog format reuses the same section names ("Added",
  "Changed", "Fixed", ...) under each release. The duplication is
  intentional.
-->

# Changelog

All notable changes to {{PROJECT_NAME}} will be documented in this
file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `docs/AUTO-MODE.md`: configuration guide for Claude Code auto mode --
  trusted infrastructure via `autoMode.environment`, human-checkpoint
  `permissions.ask` recipe, block/allow rule overrides with `"$defaults"`,
  `classifyAllShell`, the `claude auto-mode` inspection subcommands, and
  denial review. Condensed from
  <https://code.claude.com/docs/en/auto-mode-config>.

### Changed

- `scripts/bootstrap.sh`: discovers its target files at runtime instead of
  hand-listing them. The static list silently skipped every doc added to the
  template after the list was written, shipping raw `{{PLACEHOLDER}}` markers
  into generated projects (`docs/AUTO-MODE.md` was the first casualty). Uses
  `find` rather than `git ls-files` because TEMPLATE.md's Method 2 runs the
  script against a freshly initialised, empty index, and a `while read` loop
  rather than `mapfile` for bash 3.2 on macOS. It also reports the
  placeholders that remain after substitution instead of carrying a
  hand-maintained list in its header, which had drifted to the point of
  omitting 21 of the 42 placeholders actually present in the scaffold.
- `scripts/check-claude-structure.sh`: two new drift checks -- every
  `docs/*.md` must be registered in the `AGENTS.md` and `.claude/rules/docs.md`
  tables, and `bootstrap.sh` must not regress to a hand-maintained file list.
- `.claude/rules/docs.md`: registered `docs/HARNESS.md` (missing since 0.2.0)
  and `.claude/commands/*.md` (missing since 0.3.0) in the doc-tree table.
- `AGENTS.md` and `.claude/rules/docs.md`: added `docs/AUTO-MODE.md` to the
  project files tables.
- `TEMPLATE.md`: refreshed the "What you get" inventory, which had not been
  updated since 0.1.0. It now covers `.claude/commands/`, the `/goal` and
  `/delegate` skills, the escalation and memory rules, `docs/HARNESS.md`,
  `docs/AUTO-MODE.md`, `scripts/bootstrap.sh`, the new drift checks, and the
  fourth `.gitignore` negation.
- `docs/SETUP.md`: added an "Auto mode (optional)" section noting that the
  classifier reads `autoMode` from user settings only, not from
  `.claude/settings.local.json`.
- `docs/SETUP.md`: the advisor step no longer claims it needs no
  configuration. It now covers `/advisor`, `advisorModel`, the pairing
  rules for Opus 5.5 and Sonnet 5.5 main models (default: Opus 5.5
  with a Fable 5.1 advisor), the Fable usage-credits step, and the 5.5
  effort defaults.
- `.claude/rules/escalation.md`: describes how the advisor is enabled,
  names the `code-reviewer` fallback where it is unavailable, and drops
  instructions the advisor already follows on its own.
- `docs/ORCHESTRATION.md`: documents which model the bundled subagents
  run on and how to pin one.

## [0.3.0] - 2026-06-30

### Added

- `.claude/commands/build.md`: `/build` command -- runs `{{BUILD_COMMAND}}` and
  reports errors with file and line references.
- `.claude/commands/test.md`: `/test` command -- runs `{{TEST_COMMAND}}` and
  reports failing test names and broken assertions.
- `.claude/commands/lint.md`: `/lint` command -- runs `{{LINT_COMMAND}}` and
  lists issues grouped by severity.
- `.claude/commands/run.md`: `/run` command -- starts the project with
  `{{RUN_COMMAND}}` and confirms the listening address.

### Changed

- `.gitignore`: added `!.claude/commands/` negation so custom slash commands
  are tracked alongside rules, agents, and skills.
- `scripts/check-claude-structure.sh`: drift guard now checks for the
  `!.claude/commands/` negation.
- `AGENTS.md`: added "Custom slash commands" section and `commands/` row in
  the project files table.
- `scripts/bootstrap.sh`: registered new command files for placeholder
  substitution.

## [0.2.0] - 2026-06-30

### Added

- `.claude/rules/escalation.md`: global rule for escalating to `{{REVIEWER_TOOL}}`
  before substantive implementation and before declaring non-trivial tasks done.
- `.claude/rules/memory.md`: global protocol rule for `{{MEMORY_MCP}}` -- wake-up
  status check, pre-response search, post-session diary write, fact invalidation.
- `docs/HARNESS.md`: reference covering harness engineering, loop engineering
  (DOER/CHECKER pattern, `/goal` primitive), and Hermes Agent as an optional
  complementary runtime.
- `.claude/skills/goal/SKILL.md`: `/goal` skill -- structures multi-step tasks as
  self-verifying DOER/CHECKER loops with end state, evidence, constraints, and
  a turn ceiling.
- `.claude/skills/delegate/SKILL.md`: `/delegate` skill -- dispatches parallel
  subagents with memory context, worktree isolation for file writers, and a
  mandatory review pass.
- Three new placeholders: `{{MEMORY_MCP}}`, `{{MEMORY_WING}}`, `{{REVIEWER_TOOL}}`.
  `bootstrap.sh` substitutes `{{MEMORY_WING}}` from the project name; the others
  are filled in manually after bootstrap.

### Changed

- `docs/ORCHESTRATION.md`: added DOER/CHECKER principle, `/goal` loop pattern,
  and `/delegate` with memory pattern.
- `AGENTS.md`: added "Memory and harness" section pointing to the new rules and
  `docs/HARNESS.md`; added `/goal` and `/delegate` to the skills list; added new
  files to the project-files table.
- `docs/SETUP.md`: added "Memory and escalation wiring" section with hook setup
  instructions for the reference stack.
- `scripts/bootstrap.sh`: registered new files in the placeholder-substitution
  list; added `{{MEMORY_MCP}}`, `{{MEMORY_WING}}`, `{{REVIEWER_TOOL}}` to the
  manual-placeholder reference; substitutes `{{MEMORY_WING}}` automatically.

## [0.1.0] - Initial release

### Added

- Initial project scaffold from `claude-template`.
