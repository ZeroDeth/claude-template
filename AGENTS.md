# AGENTS.md -- {{PROJECT_NAME}}

A README for any coding agent (Claude Code, Cursor, Codex, Aider, Amp,
GitHub Copilot, etc.) working on this project. See <https://agents.md>
for the spec.

## Project

**{{PROJECT_NAME}}** is {{ONE_LINE_DESCRIPTION}}.

- Module: `{{MODULE_OR_PACKAGE_NAME}}`
- Owner: {{OWNER_NAME}} ({{OWNER_HANDLE}})
- Licence: {{LICENCE}}

See `TASKS.md` for the phased plan and current status, `docs/ARCHITECTURE.md`
for the system design, and `README.md` for a public-facing overview.

## Build and test

```bash
# Replace with the project's actual build/test commands.
{{BUILD_COMMAND}}
{{TEST_COMMAND}}
{{LINT_COMMAND}}
```

For contributor onboarding (environment setup, tool versions, platform
gotchas), see `docs/SETUP.md`. For known errors and their fixes, see
`docs/TROUBLESHOOTING.md`.

## Conventions

Full reference lives in `docs/CONVENTIONS.md`. The highlights:

- **Code style**: see `docs/CONVENTIONS.md` S1. Path-scoped subsets are
  in `.claude/rules/*.md` with `paths:` frontmatter so they only load
  when Claude is editing matching files.
- **Testing strategy**: `docs/CONVENTIONS.md` S4, with coverage targets
  per package in `.claude/rules/tests.md`.
- **Documentation style** (no em-dashes, no AI-buzzword vocabulary,
  markdownlint gotchas): `.claude/rules/docs.md`.

## Branch and commit discipline

- All work on feature branches. The `no-commit-to-branch` pre-commit
  hook blocks commits to `main`.
- One logical change per commit. Do not bundle refactors with feature
  work.
- Do not skip pre-commit hooks. Fix the underlying issue instead.
- Do not push to remote unless explicitly asked.
- Do not force-push to shared branches, do not reset --hard shared
  branches, do not amend published commits.

Full before-commit sequence: the `before-commit` skill
(`.claude/skills/before-commit/SKILL.md`), invokable as `/before-commit`.

## Safety

- Do not modify dependency manifests (`package.json`, `go.mod`,
  `Cargo.toml`, `pyproject.toml`, etc.) to add dependencies without
  approval.
- Do not edit `LICENSE`, `.github/` workflows, or linter configs without
  approval.
- Do not commit secrets, tokens, private keys, or `.env*` files.
- Do not delete files or branches without explicit approval.

## Memory and harness

This project uses `{{MEMORY_MCP}}` as its persistent memory tool
(wing: `{{MEMORY_WING}}`). The protocol is in `.claude/rules/memory.md`.
If the MCP server is not configured, sessions proceed without memory.

Escalation to a reviewer model (`{{REVIEWER_TOOL}}`) is mandatory before
substantive implementation and before declaring non-trivial tasks done. The
escalation rule is in `.claude/rules/escalation.md`.

For loop engineering patterns (DOER/CHECKER, `/goal`, `/delegate`) and the
optional Hermes Agent complementary runtime, see `docs/HARNESS.md`.

## Subagents and skills

Invocable subagents live in `.claude/agents/` as frontmatter-driven
definitions. Claude auto-delegates when a task description matches, and
any tool can invoke them explicitly by name:

- `code-reviewer`: review a set of changes before merging
- `test-writer`: fill test-coverage gaps for a package
- `docs-writer`: update human-facing documentation

Invocable skills live in `.claude/skills/` as slash-invokable playbooks:

- `/before-commit`: run the full validation sequence before committing
  (user-invocable only; Claude does not auto-run it)
- `/goal`: turn a task into a self-verifying DOER/CHECKER loop; requires
  end state, machine-checkable evidence, constraints, and a turn ceiling
- `/delegate`: dispatch independent work units to parallel subagents with
  memory context loaded and results reviewed
- `/example-playbook`: remove or replace with a real multi-step
  procedure from your project

Orchestration patterns for composing multiple subagents live in
`docs/ORCHESTRATION.md`.

## Project files at a glance

| File | Purpose |
|------|---------|
| `README.md` | Public-facing intro and quickstart |
| `CHANGELOG.md` | Keep-a-changelog release history |
| `TASKS.md` | Phased implementation plan, current status |
| `TODO.md` | Known gaps and post-mortems |
| `CLAUDE.md` | Claude-Code-specific overrides (imports this file) |
| `docs/ARCHITECTURE.md` | Package layout, dependency graph, request flow |
| `docs/CONVENTIONS.md` | Full code style and testing reference |
| `docs/ORCHESTRATION.md` | Multi-agent composition patterns |
| `docs/SETUP.md` | Contributor onboarding |
| `docs/TROUBLESHOOTING.md` | Common errors and fixes |
| `.claude/agents/*.md` | Subagent role definitions (frontmatter-driven) |
| `.claude/skills/*/SKILL.md` | Slash-invokable playbooks |
| `.claude/rules/escalation.md` | When and how to escalate to `{{REVIEWER_TOOL}}` |
| `.claude/rules/memory.md` | `{{MEMORY_MCP}}` protocol for every session |
| `.claude/rules/*.md` | Path-scoped rules that load only when matching files are touched |
| `.claudeignore` | Files Claude Code should never load into context |
| `.pre-commit-config.yaml` | Generic hygiene + drift guard |
| `docs/HARNESS.md` | Harness engineering, loop engineering, Hermes Agent reference |
| `scripts/check-claude-structure.sh` | Drift guard validator (runs via pre-commit) |
