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

## Memory and escalation wiring (optional)

The template includes rules for persistent memory (`{{MEMORY_MCP}}`) and
escalation to a reviewer model (`{{REVIEWER_TOOL}}`). These are placeholder-
gated: without the MCP server wired, the rules are no-ops.

To wire the reference stack (MemPalace + Claude Code advisor):

**Step 1.** Ensure the MemPalace MCP server is configured in Claude Code
settings.

**Step 2.** Add the SessionStart hook to `.claude/settings.local.json`
(not committed):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory active: call mcp__claude_ai_MemPalace__status on first turn'"
          }
        ]
      }
    ]
  }
}
```

**Step 3.** The `advisor` tool is built into Claude Code, no configuration
needed. If you use a different reviewer, update `{{REVIEWER_TOOL}}` in the
bootstrap step or manually in `.claude/rules/escalation.md`.

For Hermes Agent integration (always-on loops, multi-platform access), see
`docs/HARNESS.md`.

## Auto mode (optional)

To run Claude Code in auto mode (no routine permission prompts, with a
classifier blocking destructive or external actions), configure the
`autoMode` block in your user settings. The classifier ignores
`autoMode` in project settings, including `.claude/settings.local.json`,
so it cannot be wired through this repo. See `docs/AUTO-MODE.md` for the
configuration guide, including a `permissions.ask` recipe that keeps a
human checkpoint before pushes and pull requests.

## Platform gotchas

Document any platform-specific quirks (macOS vs Linux vs Windows).
Common ones to check:

- Line endings on Windows (the `mixed-line-ending` pre-commit hook
  forces LF).
- Case-sensitive filesystems on Linux vs case-insensitive on macOS.
- Shell differences (bash vs zsh vs fish).
