# TASKS.md -- {{PROJECT_NAME}} Implementation Plan

Version: 0.1
Last updated: {{DATE}}
Status: Scaffolded, no work started.

---

## Phase 0: Bootstrap

Goal: the project compiles, the test suite runs, the linter is happy,
and the pre-commit drift guard passes on a fresh clone.

| # | Task | Status | Notes |
|---|------|--------|-------|
| 0.1 | Replace every `{{PLACEHOLDER}}` in `AGENTS.md`, `README.md`, `docs/*.md`, `.claude/rules/tests.md`, and `.claude/skills/before-commit/SKILL.md` | TODO | |
| 0.2 | Wire language-specific pre-commit hooks in `.pre-commit-config.yaml` | TODO | See the commented examples in that file |
| 0.3 | Run `pre-commit install` and verify `pre-commit run --all-files` exits 0 | TODO | |
| 0.4 | Run `scripts/check-claude-structure.sh` and verify it exits 0 | TODO | |
| 0.5 | Delete `.claude/skills/example-playbook/` and replace with one real project-specific skill (or remove if not needed) | TODO | |

Acceptance: `pre-commit run --all-files` passes, the drift guard
passes, and the README describes the project accurately.

---

## Phase 1: First feature

Replace this section with the project's first real milestone.

| # | Task | File(s) | Status | Notes |
|---|------|---------|--------|-------|
| 1.1 | | | TODO | |

Acceptance: describe the behaviour that proves Phase 1 is done.

---

## How to use this file

1. Work through tasks in order within a phase.
2. Mark tasks DONE as they complete.
3. Do not start the next phase until the current phase's acceptance
   criteria are met.
4. If a task reveals new work, add it to the current phase with the
   next available number.
5. Keep this file updated. It is the single source of truth for
   project progress.
