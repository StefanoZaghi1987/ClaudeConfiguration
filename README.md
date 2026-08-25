# ClaudeConfiguration

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

A [Claude Code](https://code.claude.com/) configuration run as a **prompt-driven knowledge-engineering project**: three generated best-practices knowledge bases, plus a live, self-maintaining harness configuration — subagents, skills, rules, and the prompts that keep improving all of it.

This repository is both the artifact and the method. Every document in it was produced by a documented, repeatable prompt lineage, and the full lineage (the prompts themselves) is preserved alongside the outputs.

---

## Repository map

```
ClaudeConfiguration/
├── CodingAgents/            # Knowledge base: Claude Code subagents best practices
│   ├── docs/                # Published best-practices documents
│   └── project/
│       ├── 1_config/        # Seed config + generation prompts
│       └── 2_knowledge/     # Generated knowledge base (Markdown + PDF)
├── CodingConfiguration/     # Knowledge base: CLAUDE.md / harness configuration
│   ├── docs/
│   └── project/
│       ├── 1_config/
│       ├── 2_knowledge/
│       └── 3_ClaudeCode/    # ★ The live harness configuration (see below)
├── CodingStandards/         # Knowledge base: universal software development standards
│   ├── docs/
│   └── project/
│       ├── 1_config/
│       └── 2_knowledge/
├── LICENSE                  # Apache License 2.0
└── README.md
```

Each knowledge project follows the same shape:

- **`1_config/`** — the seed: `ProjectDescription`, `ProjectContext`, `ProjectInstructions`, plus the prompts that drive generation.
- **`2_knowledge/`** — the generated output: extensive, citation-backed Markdown documents with PDF renders.
- **`docs/`** — the published copies of the knowledge documents (kept in sync with `project/`).

## The knowledge bases

### CodingAgents — Claude Code subagents

~32,000 lines on designing, configuring, and orchestrating Claude Code subagents.

| Document | Focus |
|---|---|
| [`ClaudeCodeAgentsBestPractices.md`](CodingAgents/docs/ClaudeCodeAgentsBestPractices.md) | The flagship: end-to-end best practices for agentic coding |
| [`ClaudeCodeAgentsConfiguration.md`](CodingAgents/docs/ClaudeCodeAgentsConfiguration.md) | Agent frontmatter, model routing, tool permissions |
| [`ClaudeCodeAgentsModularizationBestPractices.md`](CodingAgents/docs/ClaudeCodeAgentsModularizationBestPractices.md) | Decomposing work across an agent fleet |
| [`ClaudeCodeAgentsEnforcementRulesBestPractices.md`](CodingAgents/docs/ClaudeCodeAgentsEnforcementRulesBestPractices.md) | Rules and guardrails that agents actually follow |
| [`ClaudeCodeAgentsReferencingBestPractices.md`](CodingAgents/docs/ClaudeCodeAgentsReferencingBestPractices.md) | Cross-referencing between CLAUDE.md, rules, skills, prompts |

### CodingConfiguration — CLAUDE.md and harness configuration

Best practices for configuring Claude Code itself: memory files, modularization, referencing, and enforcement.

| Document | Focus |
|---|---|
| [`ClaudeCodeConfigurationBestPractices.md`](CodingConfiguration/docs/ClaudeCodeConfigurationBestPractices.md) | CLAUDE.md and settings architecture |
| [`ClaudeCodeModularizationBestPractices.md`](CodingConfiguration/docs/ClaudeCodeModularizationBestPractices.md) | Splitting configuration into maintainable units |
| [`ClaudeCodeReferencingBestPractices.md`](CodingConfiguration/docs/ClaudeCodeReferencingBestPractices.md) | How config artifacts should reference each other |
| [`ClaudeCodeEnforcementRulesBestPractices.md`](CodingConfiguration/docs/ClaudeCodeEnforcementRulesBestPractices.md) | Turning preferences into enforced rules |

### CodingStandards — universal development standards

| Document | Focus |
|---|---|
| [`UniversalSoftwareDevelopmentBestPractices.md`](CodingStandards/docs/UniversalSoftwareDevelopmentBestPractices.md) | Framework-agnostic software engineering standards (also mirrored in [CodingConfiguration](CodingConfiguration/docs/UniversalSoftwareDevelopmentBestPractices.md)) |

## The live harness: `3_ClaudeCode/`

Located under [`CodingConfiguration/project/3_ClaudeCode/`](CodingConfiguration/project/3_ClaudeCode/), this is a working configuration — not sample code — organized exactly as Claude Code expects:

```
3_ClaudeCode/
├── commands/    # Task-prompt templates
├── config/
│   ├── agents/  # Subagent definitions
│   ├── rules/   # Always-in-context rules
│   └── skills/  # Custom skills
└── prompts/     # Harness self-improvement prompts
```

### Subagents — a quality-gate pipeline

Work flows through a review chain: **architect** designs → **spec-reviewer** critiques the design → **implementation-plan-reviewer** checks the plan against the real codebase → **code-reviewer** audits the result. Model routing is deliberate: a top-tier model for design, strong critique models for the review gates.

| Agent | Role |
|---|---|
| [`architect.md`](CodingConfiguration/project/3_ClaudeCode/config/agents/architect.md) | Designs component structure, data flow, and trade-offs before planning |
| [`spec-reviewer.md`](CodingConfiguration/project/3_ClaudeCode/config/agents/spec-reviewer.md) | Critiques design specs and RFCs before implementation starts |
| [`implementation-plan-reviewer.md`](CodingConfiguration/project/3_ClaudeCode/config/agents/implementation-plan-reviewer.md) | Reviews implementation plans for sequencing, completeness, and risk |
| [`code-reviewer.md`](CodingConfiguration/project/3_ClaudeCode/config/agents/code-reviewer.md) | Reviews changed code for correctness, security, and maintainability |

### Rules

| Rule | Effect |
|---|---|
| [`effort-escalation.md`](CodingConfiguration/project/3_ClaudeCode/config/rules/effort-escalation.md) | Stay at default effort; escalate only for deep debugging, architecture trade-offs, security review, or final verification |

### Skills — self-maintenance tooling

| Skill | What it does |
|---|---|
| [`skills-resync/`](CodingConfiguration/project/3_ClaudeCode/config/skills/skills-resync/SKILL.md) | Keeps 29 vendored skills in `~/.claude/skills` synchronized with their upstream plugin marketplaces (see spotlight below) |
| [`model-config-sync/`](CodingConfiguration/project/3_ClaudeCode/config/skills/model-config-sync/SKILL.md) | Re-validates model-routing configuration (aliases, fallback chains, agent frontmatter) against current official documentation |

### Command templates

| Template | Use |
|---|---|
| [`ClaudeCode_BrainstormingPrompt.md`](CodingConfiguration/project/3_ClaudeCode/commands/ClaudeCode_BrainstormingPrompt.md) | Structured brainstorming: objective → requirements → context → constraints |
| [`ClaudeCode_PlanningMode_ExecuteTaskPrompt.md`](CodingConfiguration/project/3_ClaudeCode/commands/ClaudeCode_PlanningMode_ExecuteTaskPrompt.md) | Execute a task with plan approval before any coding |
| [`ClaudeCode_SubAgentDriven_ExecuteTaskPrompt.md`](CodingConfiguration/project/3_ClaudeCode/commands/ClaudeCode_SubAgentDriven_ExecuteTaskPrompt.md) | Dispatch a task to subagent-driven development |
| [`ClaudeCode_SubAgentDriven_PlanningMode_ExecuteTaskPrompt.md`](CodingConfiguration/project/3_ClaudeCode/commands/ClaudeCode_SubAgentDriven_PlanningMode_ExecuteTaskPrompt.md) | Combine planning mode with subagent dispatch |

### Harness self-improvement prompts

The configuration improves itself through periodic audit prompts, each requiring verification against live official documentation rather than training data:

- [`2_ImproveClaudeCodeConfiguration.md`](CodingConfiguration/project/3_ClaudeCode/prompts/2_ImproveClaudeCodeConfiguration.md) — model-routing strategy (right model per phase, tiered fallback)
- [`4_ImproveClaudeCodeHarness.md`](CodingConfiguration/project/3_ClaudeCode/prompts/4_ImproveClaudeCodeHarness.md) — full harness audit-and-align pass
- [`5_AnalyzeSkills.md`](CodingConfiguration/project/3_ClaudeCode/prompts/5_AnalyzeSkills.md) — skill/plugin audit with rubric and migration plan

## Spotlight: the skills-resync tool

The standout artifact: [`resync.sh`](CodingConfiguration/project/3_ClaudeCode/config/skills/skills-resync/scripts/resync.sh), an idempotent ~800-line bash tool that solves a real maintenance problem — **vendored skills drifting from upstream plugins whose install cache no longer updates**.

How it works:

- **Inventory + baselines** — [`inventory.tsv`](CodingConfiguration/project/3_ClaudeCode/config/skills/skills-resync/scripts/inventory.tsv) tracks 29 vendored skills from four plugin sources, each with a tree-hash baseline.
- **Drift classification** — compares local state against upstream to classify drift before touching anything.
- **Protected local edits (L1–L6)** — a documented taxonomy of local customizations that must survive re-sync.
- **Replayable patches** — 8 [patch files](CodingConfiguration/project/3_ClaudeCode/config/skills/skills-resync/scripts/patches/) capture protected edits so they re-apply cleanly after an upstream refresh.
- **Operations** — `--refresh`, `--check`, `--diff`, `--snapshot`, `--apply`, `--hash`, `--clean`, and `--self-test`.

The design split is the interesting part: **judgement lives in [`SKILL.md`](CodingConfiguration/project/3_ClaudeCode/config/skills/skills-resync/SKILL.md) (when to sync, how to classify drift); mechanics live in the script (hashing, patching, verification).**

## The prompt-lineage pattern

Every generated document in this repository preserves its full lineage as numbered prompt pairs:

- **Odd-numbered `.txt`** — the short human request (e.g. `1_WriteProjectConfigurationPrompt.txt`)
- **Even-numbered `.md`** — the expanded mega-prompt actually fed to Claude (e.g. `2_GenerateProjectConfiguration.md`), with mandatory verification steps, CHECKPOINTs, and source citations

The prompts are reusable templates in their own right — take one, adapt the seed config in `1_config/`, and reproduce the whole workflow for a new domain.

## Reusing this repository

- **Adopt the harness**: copy the agents, rules, skills, and commands from `3_ClaudeCode/config/` into `~/.claude/` (user-level) or your project's `.claude/` directory.
- **Read the knowledge bases standalone**: every document under each project's `docs/` is self-contained.
- **Reuse the method**: pick a knowledge project, study its `1_config/` seed and prompt pairs, and run the same lineage for your own domain.

## License

[Apache License 2.0](LICENSE)
