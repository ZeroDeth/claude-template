# Auto mode configuration -- {{PROJECT_NAME}}

How to configure Claude Code's auto mode for projects built from this
template. This is a condensed, template-specific companion to the
upstream reference at
<https://code.claude.com/docs/en/auto-mode-config>; when the two
disagree, the upstream page wins.

## What auto mode is

[Auto mode](https://code.claude.com/docs/en/permission-modes#eliminate-prompts-with-auto-mode)
lets Claude Code run without routine permission prompts by routing tool
calls through a classifier that blocks anything irreversible,
destructive, or aimed outside your environment. Deny and explicit ask
rules from the [permissions system](https://code.claude.com/docs/en/permissions)
are evaluated before the classifier and still block or prompt.

The `autoMode` settings block tells the classifier which repos, buckets,
and domains you trust, so it stops blocking routine internal operations.
By default, the classifier trusts only the working directory and the
current repo's configured remotes.

Auto mode allows pushes to any branch of the repository you are working
in, including the default branch, and pull request creation by default
(Claude Code v2.1.211 and later; earlier versions restricted pushes to
your working branch, branches Claude created, and routine pushes to the
default branch). A branch whose name marks it as a deploy target, such
as `production`, `release`, or `gh-pages`, is judged on its own terms.
Force pushes, secrets entering commits, and content that would leak
secrets through CI stay blocked regardless.

## Add a human checkpoint

This template's `AGENTS.md` already instructs agents not to push without
being asked. To make that boundary mechanical instead of instructional,
add `permissions.ask` rules in your settings. Content-scoped ask rules
are evaluated before the classifier and always force a prompt, even in
auto mode:

```json
{
  "permissions": {
    "ask": [
      "Bash(git push *)",
      "Bash(gh pr create *)"
    ]
  }
}
```

Pick the mechanism by how firm the boundary needs to be:

| Boundary | Mechanism | Behavior in auto mode |
|------|------|------|
| Prompt before the action | `permissions.ask` | Always prompts; the classifier cannot auto-approve a matching action |
| Never run the action | `permissions.deny` | Blocks before the classifier; nothing overrides it |
| One-off boundary for this session | State it in conversation | The classifier honors it, but context compaction can drop it; use an ask or deny rule for a durable guarantee |

## Where the classifier reads configuration

The classifier reads the same `CLAUDE.md` content Claude itself loads,
so behavioral rules in this template's steering files (for example the
branch discipline in `AGENTS.md`, which `CLAUDE.md` imports) steer both
Claude and the classifier at once. Start there for project conventions.

For rules that apply across projects, use the `autoMode` settings block
in these scopes:

| Scope | File | Use for |
|------|------|------|
| One developer | `settings.json` in the user-level Claude directory (`$HOME/.claude/settings.json`) | Personal trusted infrastructure |
| Organization-wide | [Managed settings](https://code.claude.com/docs/en/server-managed-settings) | Trusted infrastructure for all developers |
| `--settings` flag or Agent SDK | Inline JSON | Per-invocation overrides for automation |

The classifier does **not** read `autoMode` from project settings in
`.claude/settings.json` or `.claude/settings.local.json` (a checked-in
repo or build step could otherwise inject its own allow rules). This
matters for this template: the operator-local hooks that
`docs/SETUP.md` and `.claude/rules/memory.md` place in
`.claude/settings.local.json` still work, but any `autoMode` block
there is ignored and belongs in your user settings instead.

Entries from each scope are combined additively. A developer can extend
the lists but cannot remove entries that managed settings provide. For
actions that must never run regardless of classifier configuration, use
`permissions.deny` in managed settings.

## Define trusted infrastructure

For most setups, `autoMode.environment` is the only field you need. It
is an array of prose entries, not regex or tool patterns; write them the
way you would describe your infrastructure to a new engineer. Include
the literal string `"$defaults"` to keep the built-in entries alongside
yours.

A starting template; fill in the bracketed fields and delete lines that
do not apply:

```json
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Organization: {COMPANY_NAME}. Primary use: {PRIMARY_USE_CASE}",
      "Source control: {SOURCE_CONTROL, e.g. GitHub org github.example.com/acme-corp}",
      "Cloud provider(s): {CLOUD_PROVIDERS, e.g. AWS, GCP, Azure}",
      "Trusted cloud buckets: {TRUSTED_BUCKETS, e.g. s3://acme-builds}",
      "Trusted internal domains: {TRUSTED_DOMAINS, e.g. *.internal.example.com}",
      "Key internal services: {SERVICES, e.g. Jenkins at ci.example.com}",
      "Additional context: {EXTRA, e.g. regulated industry, compliance requirements}"
    ]
  }
}
```

The upstream defaults define three kinds of entry (run
`claude auto-mode defaults` to print them):

- **Context slots**: organization, primary use, cloud providers,
  repository visibility, secrets management, CI/CD deploy targets, and
  similar background the classifier reads the other rules against.
- **Trust slots**: what counts as inside your boundary (trusted repo,
  source control, internal domains, cloud buckets, key internal
  services, internal package registry). Only the working repository and
  its remotes are trusted until you add more.
- **Sensitivity slots**: what the protective rules treat as high-risk
  (sensitive data locations and audiences, sensitive remote targets,
  protected IaC scopes). Each defaults to a broad heuristic, such as
  treating any host whose name carries `prod` as sensitive, until you
  name concrete targets.

A reasonable rollout: start with the defaults, add your source-control
org and key internal services first (this resolves the most common
false positives), then trusted domains and buckets, then the rest as
blocks come up.

## Override the block and allow rules

Three more fields replace the classifier's built-in rule lists, each an
array of prose descriptions:

- `autoMode.hard_deny`: unconditional security boundaries.
- `autoMode.soft_deny`: destructive actions that user intent can clear.
- `autoMode.allow`: exceptions to soft block rules.

Precedence inside the classifier, in order: `hard_deny` blocks
unconditionally; `soft_deny` blocks next; `allow` rules override
matching `soft_deny` rules; explicit user intent overrides remaining
soft blocks. Intent must be specific: "clean up the repo" does not
authorize a force push, "force-push this branch" does.

Example that keeps the defaults and adds project-specific rules, in the
spirit of this template's safety section in `AGENTS.md`:

```json
{
  "autoMode": {
    "soft_deny": [
      "$defaults",
      "Never modify dependency manifests to add dependencies without approval",
      "Never edit LICENSE, .github/ workflows, or linter configs without approval"
    ],
    "hard_deny": [
      "$defaults",
      "Never send repository contents to third-party code-review APIs"
    ]
  }
}
```

**Warning**: setting any of `environment`, `allow`, `soft_deny`, or
`hard_deny` without `"$defaults"` replaces the entire default list for
that section, discarding built-in protections such as the force-push
and `curl | bash` soft blocks or the data-exfiltration hard block. Only
omit `"$defaults"` when you intend to own the full list; print the
built-ins with `claude auto-mode defaults` first. Each section is
evaluated independently, so setting one leaves the others' defaults
intact.

## Route all shell commands through the classifier

By default, narrow Bash allow rules such as `Bash(npm test)` resolve
before the classifier runs, so an unanticipated argument can slip
through. Set `autoMode.classifyAllShell` to `true` (Claude Code v2.1.193
or later) to suspend every Bash and PowerShell allow rule while auto
mode is active, so the classifier evaluates every shell command. This
trades latency for coverage. The setting only applies while auto mode
is active.

```json
{
  "autoMode": {
    "classifyAllShell": true
  }
}
```

## Inspect and reset

```bash
# Print the built-in environment, allow, soft_deny, and hard_deny rules
claude auto-mode defaults

# Print one rule's full wording (v2.1.208+)
claude auto-mode defaults --label 'Git Destructive'

# Print the effective config with your settings applied
claude auto-mode config

# Get AI feedback on custom allow/soft_deny/hard_deny rules
claude auto-mode critique

# Remove the autoMode section from user settings (v2.1.212+)
claude auto-mode reset
```

Run `claude auto-mode config` after saving settings to confirm your
entries took effect, with `"$defaults"` expanded in place. `reset` only
touches your user settings; managed settings and `--settings` overrides
still apply.

## Review denials

Open `/permissions` and select the **Recently denied** tab to review
actions the classifier blocked. Press `r` on a denial to mark it for
retry. Pick the fix from what the blocked call was trying to reach:

- A destination needed throughout the task (package registry, internal
  domain, repo host): add it to `autoMode.environment`.
- A command you want unreviewed from now on: add an `allow` rule.
- A one-off action you did intend: state that intent in your next
  message and let Claude retry.

Repeated denials for the same destination usually mean the classifier
is missing context; add the destination to `autoMode.environment` and
confirm with `claude auto-mode config`. To react to denials
programmatically, use the
[`PermissionDenied` hook](https://code.claude.com/docs/en/hooks#permissiondenied).

## See also

- [Configure auto mode](https://code.claude.com/docs/en/auto-mode-config):
  the full upstream reference this page condenses, including version
  requirements for individual features
- [Permission modes](https://code.claude.com/docs/en/permission-modes#eliminate-prompts-with-auto-mode):
  what auto mode blocks by default and which sessions start in it
- [Settings reference](https://code.claude.com/docs/en/settings-reference#automode):
  every `autoMode` settings key
