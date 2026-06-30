# Harness and loop engineering

Reference for the engineering layers that sit above prompting. These concepts
inform how this template is structured and how to extend it.

## Engineering progression

The field has moved through four distinct layers since 2023:

1. **Prompt engineering** (2023): single isolated instructions to the model.
2. **Context engineering** (2024): building richer input environments --
   memory, retrieved documents, structured tool output.
3. **Harness engineering** (2025): the full environment of scaffolding,
   tools, constraints, and feedback loops that make agents reliable rather
   than merely clever.
4. **Loop engineering** (2026): designing closed, self-verifying agentic
   loops with machine-checkable success signals at every step, so the agent
   runs autonomously and the human surfaces only when it cannot proceed.

This template provides harness components (rules, skills, agents, hooks)
and loop primitives (`/goal`, `/delegate`). Use them as the foundation for
loop engineering in your project.

## Harness engineering

A harness is the full environment around an agent. Five components:

1. **Automations**: scheduled systems that identify and triage work (cron
   hooks, CI triggers, watch scripts).
2. **Worktrees**: parallel agent instances with isolated checkouts so agents
   writing different files do not conflict.
3. **Skills**: documented project conventions and multi-step procedures that
   agents invoke by name (`.claude/skills/*/SKILL.md`).
4. **Plugins and connectors**: MCP-based integrations with external tools
   (memory servers, code review bots, CI systems).
5. **Sub-agents**: specialized verifiers, reviewers, and implementers that
   run in parallel or in sequence (`./claude/agents/*.md`).

The harness enforces what instructions cannot: it runs code, not text.
Rules in `.claude/rules/` express intent; hooks and scripts enforce it.

## Loop engineering

A loop is a closed, self-verifying agentic cycle. The human defines the
goal once; the loop runs until the success evidence is met or the ceiling
is hit.

### DOER / CHECKER pattern

Every loop has two roles:

- **DOER**: the agent that implements one slice toward the goal.
- **CHECKER**: a separate verification step that runs the success evidence.
  The checker must not be the doer validating its own work.

Nothing proceeds past the checker unless the evidence passes. This is what
makes loops trustworthy rather than self-confirming.

### When to build a loop

Loops work well for **stable, repetitive goals** with consistent,
machine-checkable success criteria (tests pass, diff is empty, lint exits
0, endpoint returns 200).

Avoid loops for moving targets. A goal that changes faster than the loop
runs creates constant overhead and negates the efficiency.

### The `/goal` skill

See `.claude/skills/goal/SKILL.md`. Invoke as `/goal`. Takes an end state,
success evidence, constraints, and a hard ceiling. Structures the DOER /
CHECKER cycle and surfaces to the human on success or ceiling.

### The `/delegate` skill

See `.claude/skills/delegate/SKILL.md`. Invoke as `/delegate`. Dispatches
parallel subagents with memory context loaded, uses worktrees for file-
writing agents, collects and reviews results.

## Hermes Agent (optional complementary runtime)

Hermes Agent is an open-source self-improving agent by Nous Research
(github.com/NousResearch/hermes-agent, MIT licence).

**What it provides that Claude Code does not**:

- Always-on autonomous loops outside a developer session (cron scheduler
  built in).
- Persistent cross-session memory with self-improving skill files
  (agentskills.io standard -- compatible with the skills in this template).
- Multi-platform gateway: CLI, Telegram, Discord, Slack, WhatsApp, Signal,
  Email -- one agent, all surfaces.
- Works with any LLM provider (OpenRouter, Anthropic, OpenAI, local models,
  and 20+ others).

**When to run Hermes alongside Claude Code**:

- You need an agent that runs while you sleep (nightly reports, monitoring,
  scheduled PR triage).
- You want the same agent context accessible from a phone (Telegram) and
  your terminal.
- You want skill files generated from your own workflow patterns (Hermes
  writes its own skills from experience).

**When to stay Claude Code only**:

- In-session code work where you are actively guiding the agent.
- Projects where a single tool chain reduces cognitive overhead.

**Hermes generates skills automatically.** When Hermes detects a repeated
task pattern, it writes a skill file from the observed workflow -- no human
authoring required. These generated skills follow the agentskills.io
standard and can be imported into this template's `.claude/skills/` directory
with minimal changes. This creates a feedback loop: Claude Code executes
tasks, Hermes observes patterns, Hermes writes skill files, those skill
files improve both runtimes.

The skills format in this template (`.claude/skills/*/SKILL.md`) is
compatible with the agentskills.io standard. Skills authored here can be
loaded into Hermes; skills generated by Hermes can be adapted here.

## Further reading

- CodeRabbit loop engineering: coderabbit.ai/blog/loop-engineering
- Claude Code sub-agents: code.claude.com/docs/en/sub-agents
- Claude Code agent teams: code.claude.com/docs/en/agent-teams
- Hermes Agent docs: hermes-agent.nousresearch.com
- agentskills.io standard: agentskills.io
