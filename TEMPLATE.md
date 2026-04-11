# claude-template

A language-agnostic skeleton for new projects that want to use Claude
Code (and Amp, Codex, Aider, Cursor, Copilot, ...) without spending
an afternoon re-explaining the `.claude/` directory structure every
time.

## What you get

- **`CLAUDE.md`** — thin wrapper that imports `@AGENTS.md` and adds a
  handful of Claude-Code-specific overrides. Follows Anthropic's
  published <=200-line target
  (<https://code.claude.com/docs/en/memory>).
- **`AGENTS.md`** — vendor-neutral README-for-agents following the
  `agents.md` spec (<https://agents.md>). Any AI coding agent reads
  this.
- **`.claude/rules/`** — path-scoped rules that load only when Claude
  is editing matching files:
  - `docs.md`: markdown style, markdownlint gotchas, doc tree
  - `tests.md`: test conventions and coverage targets
- **`.claude/agents/`** — frontmatter-driven subagent definitions
  (<https://code.claude.com/docs/en/sub-agents>):
  - `code-reviewer`: read-only review of a set of changes
  - `test-writer`: fill coverage gaps without touching production code
  - `docs-writer`: public-facing prose, changelog, troubleshooting
- **`.claude/skills/`** — slash-invokable playbooks
  (<https://code.claude.com/docs/en/skills>):
  - `before-commit`: user-invocable full-validation sequence
  - `example-playbook`: delete or replace with your own
- **`docs/`** — long-form reference with stubs for ARCHITECTURE,
  CONVENTIONS, ORCHESTRATION, SETUP, TROUBLESHOOTING.
- **`scripts/check-claude-structure.sh`** — a pre-commit drift guard
  that blocks commits if `CLAUDE.md` exceeds 200 lines, if any file
  references a machine-local path, if an agent or skill is missing
  its frontmatter, or if `.gitignore` loses its `.claude/` negations.
- **`.pre-commit-config.yaml`** — generic hygiene hooks plus the
  drift guard above. No language-specific tooling; add your own
  (`go-fmt`, `ruff`, `eslint`, ...) below the comment marker.
- **`.gitignore`** — with the three `.claude/` negations baked in so
  `rules/`, `agents/`, and `skills/` stay tracked.

## How to use this template

Pick whichever method you prefer.

### Method 1: GitHub template repository (recommended)

Once you push this repo to GitHub, mark it as a template repository
under **Settings → Template repository**. Then for every new project:

```bash
gh repo create my-new-project --template <your-user>/claude-template --private
git clone git@github.com:<your-user>/my-new-project.git
cd my-new-project
scripts/bootstrap.sh "my-new-project" "Your Name" "A one-line description."
```

GitHub strips the template's git history, so your new project starts
from a clean commit.

### Method 2: Clone and reset history

```bash
git clone ~/Projects/claude-template ~/Projects/my-new-project
cd ~/Projects/my-new-project
rm -rf .git
git init
scripts/bootstrap.sh "my-new-project" "Your Name" "A one-line description."
git add .
git commit -m "Initial commit from claude-template"
```

### Method 3: Copy the pieces you need

If you only want a subset (say, the drift guard and the
`.claude/agents/code-reviewer.md`), just copy those files into your
existing project and make sure `.gitignore` allows
`.claude/agents/` and `.claude/skills/` through.

## After bootstrap

1. Edit `AGENTS.md` and replace every `{{PLACEHOLDER}}` with real
   content for your project. The bootstrap script handles the common
   ones (`PROJECT_NAME`, `OWNER_NAME`, `DESCRIPTION`); the rest
   (`BUILD_COMMAND`, `TEST_COMMAND`, etc.) you fill in as the project
   takes shape.
2. Open `.pre-commit-config.yaml` and uncomment or add the
   language-specific hooks for your stack (Go, TypeScript, Python,
   Rust, ...).
3. Replace `.claude/rules/tests.md` coverage targets with the real
   ones for your project.
4. Delete `.claude/skills/example-playbook/` once you have at least
   one real project-specific skill.
5. Run `scripts/check-claude-structure.sh` to confirm the drift guard
   is happy. If you are about to make your first commit, run
   `pre-commit install` first so the hook fires automatically.

## Why this exists

Anthropic's published guidance on Claude Code memory, skills, and
subagents is consistent but spread across five separate pages. Each
new project requires applying the same pattern:

- CLAUDE.md under 200 lines, imports AGENTS.md
- Long-form content in `docs/`
- Path-scoped rules in `.claude/rules/`
- Subagents in `.claude/agents/`
- Skills in `.claude/skills/`
- `.gitignore` negations so none of the above get silently hidden
- Pre-commit drift guard so none of the above silently regress

This template captures the pattern once, so the next project starts
with all of it already in place. The files here are designed to work
with Claude Code, Amp, Codex, Aider, Cursor, and GitHub Copilot
simultaneously via the `agents.md` cross-vendor spec.

## Keeping the template up to date

When you learn something new on a real project, decide whether it is:

- **Project-specific** (stays in that project, never back-ports here)
- **Pattern-level** (worth adding to the template so the next project
  inherits it)

Cherry-pick pattern-level improvements back into `claude-template`.
Existing projects that were scaffolded from an older version of this
template do not auto-update; you have to port the change manually.

## Credits

The structure in this template was refined while building **azemu**
(a local Azure emulator for Terraform development). The original
structural discovery came from cross-referencing Anthropic's
`code.claude.com/docs/en/` guides, the `agents.md` cross-vendor spec,
and Sourcegraph Amp's documentation at `ampcode.com/manual`.
