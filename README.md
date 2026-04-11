# {{PROJECT_NAME}}

{{ONE_LINE_DESCRIPTION}}

**Status:** {{STATUS}}

## What it does

Replace this paragraph with a short, public-facing description of
what the project does and who it is for.

## Quick start

```bash
git clone {{REPO_URL}}
cd {{PROJECT_NAME}}
{{INSTALL_COMMAND}}
{{RUN_COMMAND}}
```

## Development

See `docs/SETUP.md` for the full contributor onboarding guide.

```bash
{{TEST_COMMAND}}
{{LINT_COMMAND}}
{{BUILD_COMMAND}}
pre-commit run --all-files
```

## Project structure

```text
{{PROJECT_NAME}}/
├── CLAUDE.md                       -- AI agent steering (thin wrapper, imports AGENTS.md)
├── AGENTS.md                       -- README for any coding agent (cross-vendor spec)
├── TASKS.md                        -- phased implementation plan
├── TODO.md                         -- known gaps and post-mortems
├── CHANGELOG.md                    -- keep-a-changelog history
├── .pre-commit-config.yaml         -- hygiene + drift guard
├── .claude/
│   ├── rules/                      -- path-scoped conventions
│   ├── agents/                     -- subagent role definitions
│   └── skills/                     -- slash-invokable playbooks
├── docs/                           -- long-form reference
└── scripts/
    └── check-claude-structure.sh   -- drift guard validator
```

## Documentation

- `docs/ARCHITECTURE.md` — system design and package layout
- `docs/CONVENTIONS.md` — code style and testing strategy
- `docs/SETUP.md` — contributor onboarding
- `docs/TROUBLESHOOTING.md` — common errors and fixes

## Licence

{{LICENCE}}
