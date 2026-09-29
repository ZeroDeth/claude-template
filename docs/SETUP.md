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

**Step 3.** Turn on the advisor. It is experimental, off by default, and
only works against the Anthropic API (not Amazon Bedrock, Claude
Platform on AWS, Google Cloud's Agent Platform, or Microsoft Foundry).

```text
/advisor fable   # saved to advisorModel in your user settings
```

Or set `"advisorModel": "fable"` in your user settings, or launch once
with `claude --advisor fable`. The advisor must be at least as capable
as the main model. This template's default is Opus 5.5 as the main model
with Fable 5.1 as the advisor (`/model opus`, then `/advisor fable`):

| Main model | Advisor to use |
|------|------|
| Opus 5.5 (default) | Fable 5.1 (default), or Opus 5.5 |
| Sonnet 5.5 | Fable 5.1, Opus 5.5, or Sonnet 5.5 |

A Sonnet advisor is rejected with an Opus main model. For older models,
see the full pairing table in the advisor reference linked below.

On the Anthropic API the `sonnet` alias resolves to Sonnet 5.5, which
needs Claude Code v2.1.284 or later. On plans that bill Fable to usage
credits, run `/model fable` once to accept that before `/advisor fable`
takes effect. Subagents inherit the advisor. Setting `DISABLE_TELEMETRY`
also turns the advisor off. Full reference:
<https://code.claude.com/docs/en/advisor>.

If you use a different reviewer, update `{{REVIEWER_TOOL}}` in the
bootstrap step or manually in `.claude/rules/escalation.md`.

**Step 4 (optional).** Opus 5.5 and Sonnet 5.5 default to `medium`
effort. A top-level `effortLevel` in your user settings no longer applies
to them; set their level with `/effort` instead. An `effortLevel` in
project settings (`.claude/settings.json`) applies to every model, so
leave it out of the committed file unless the whole team wants it.

For Hermes Agent integration (always-on loops, multi-platform access), see
`docs/HARNESS.md`.

## Platform gotchas

Document any platform-specific quirks (macOS vs Linux vs Windows).
Common ones to check:

- Line endings on Windows (the `mixed-line-ending` pre-commit hook
  forces LF).
- Case-sensitive filesystems on Linux vs case-insensitive on macOS.
- Shell differences (bash vs zsh vs fish).
