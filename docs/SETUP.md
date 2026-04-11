# Setup -- {{PROJECT_NAME}}

Contributor onboarding guide.

## Prerequisites

Replace with the project's actual toolchain requirements:

- {{LANGUAGE_RUNTIME}} version X.Y or later
- {{PACKAGE_MANAGER}}
- {{OPTIONAL_TOOLS}}
- `pre-commit` (installed automatically by the steps below)

## Clone and bootstrap

```bash
git clone {{REPO_URL}}
cd {{PROJECT_NAME}}

# Install dependencies
{{INSTALL_COMMAND}}

# Install pre-commit hook (runs on every git commit)
pre-commit install
```

## First-run checks

Verify the toolchain is wired up correctly before making changes:

```bash
{{TEST_COMMAND}}
{{LINT_COMMAND}}
{{BUILD_COMMAND}}
scripts/check-claude-structure.sh
```

All of these must exit 0. If any fails, check
`docs/TROUBLESHOOTING.md` for known errors and fixes.

## Environment variables

Document required environment variables here. For each:

- Variable name
- What it controls
- Default value (if any)
- Whether it is required for local dev, tests, production, or all

Example file for local dev: `.env.example` (if present).

## Platform gotchas

Document any platform-specific quirks (macOS vs Linux vs Windows).
Common ones to check:

- Line endings on Windows (the `mixed-line-ending` pre-commit hook
  forces LF).
- Case-sensitive filesystems on Linux vs case-insensitive on macOS.
- Shell differences (bash vs zsh vs fish).
