@AGENTS.md

## Claude Code overrides

The project rules live in `AGENTS.md` (imported above) and the docs it
references. This file only contains Claude-Code-specific overrides.

- **Steering budget.** Before editing `CLAUDE.md` or `AGENTS.md`, run
  `wc -l CLAUDE.md AGENTS.md` and confirm the result stays within
  Anthropic's published target of under 200 lines for `CLAUDE.md`
  (<https://code.claude.com/docs/en/memory>). New conventions go to
  `.claude/rules/*.md` with `paths:` frontmatter; new how-to content
  goes to `docs/`; multi-step procedures go to `.claude/skills/`.
- **Path-scoped rules load conditionally.** Files under `.claude/rules/`
  with a `paths:` glob only load when Claude reads files matching the
  glob. Do not duplicate their content into steering files.
- **Output-shaping skill.** `i-have-adhd` (upstream:
  <https://github.com/ayghri/i-have-adhd>, MIT) shapes replies: lead with
  the next action, number multi-step work, restate progress each turn,
  give concrete time estimates, suppress tangents. Say `i-have-adhd` or
  `adhd mode` to turn it on; it stays on until `stop adhd mode` or
  `normal mode`. It is installed at the account level, not vendored in
  `.claude/skills/`, so a fresh clone will not have it.
- **Ask, do not guess.** When the user cites "best practice" or a
  published guideline, look it up at the source before proposing
  alternatives. Anthropic's guides are at
  <https://code.claude.com/docs/en/>.

<!--
Maintainer note (stripped before context injection; costs zero tokens).

STRUCTURE RATIONALE
This project follows Anthropic's published layering:

  CLAUDE.md              thin wrapper, imports @AGENTS.md
  AGENTS.md              cross-vendor README-for-agents
                         (https://agents.md spec)
  .claude/rules/*.md     path-scoped rules with paths: frontmatter
  .claude/agents/*.md    frontmatter-driven subagent definitions
  .claude/skills/*/      slash-invokable playbooks
  docs/*.md              long-form reference
  scripts/check-claude-structure.sh
                         pre-commit drift guard (CLAUDE.md budget,
                         machine-local path leaks, frontmatter, gitignore)

Source documentation (fetch if you need context):
  https://code.claude.com/docs/en/memory
  https://code.claude.com/docs/en/best-practices
  https://code.claude.com/docs/en/features-overview
  https://code.claude.com/docs/en/skills
  https://code.claude.com/docs/en/sub-agents
  https://agents.md
  https://ampcode.com/manual

HTML comments in CLAUDE.md are stripped before context injection
(https://code.claude.com/docs/en/memory), so maintainer notes cost
zero session tokens. Use them freely for rationale that humans need
but Claude does not.

DO NOT
- Re-bloat CLAUDE.md past 200 lines. Move new content to docs/,
  .claude/rules/, or .claude/skills/ and reference via @-import or
  in-prose link.
- Reference any machine-local path (home-dir shortcuts, absolute
  /Users/ paths, Claude Code auto-memory directories). The repo is
  meant to be cloned on any machine; anything inside this tree must
  resolve without external state. The scripts/check-claude-structure.sh
  drift guard enforces this on every commit.
- Duplicate the same rule in CLAUDE.md and .claude/rules/. If you find
  yourself writing the same rule twice, one of the two homes is wrong.
-->
