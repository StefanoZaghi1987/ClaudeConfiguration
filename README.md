# Claude Configuration

**Prompt-generated best-practices knowledge bases for Claude** — universal coding standards, CLAUDE.md / Claude Code configuration, and Claude Code agents guidance, with the full prompt lineage included so every document can be audited, regenerated, or adapted.

Each knowledge base in this repository was built through a documented two-stage prompt workflow and is packaged twice: as readable markdown for browsing, and as an upload-ready bundle for a [claude.ai Project](https://claude.ai/projects). Nothing here executes; the repo is pure reference material — roughly 57,000 lines of curated guidance.

## What's inside

| Package | Focus | Key documents |
|---|---|---|
| [`CodingStandards/`](CodingStandards/docs/) | Universal, framework- and language-agnostic software development practices: code quality, architecture, testing, documentation, security, performance, VCS, CI/CD | [Universal Software Development Best Practices](CodingStandards/docs/UniversalSoftwareDevelopmentBestPractices.md) (~4,400 lines) |
| [`CodingConfiguration/`](CodingConfiguration/docs/) | Writing optimal `CLAUDE.md` files and Claude Code configuration | [Configuration Best Practices](CodingConfiguration/docs/ClaudeCodeConfigurationBestPractices.md) (~5,300) · [Modularization](CodingConfiguration/docs/ClaudeCodeModularizationBestPractices.md) (~4,400) · [Enforcement Rules](CodingConfiguration/docs/ClaudeCodeEnforcementRulesBestPractices.md) (~2,100) · [Referencing](CodingConfiguration/docs/ClaudeCodeReferencingBestPractices.md) (~3,500) |
| [`CodingAgents/`](CodingAgents/docs/) | Claude Code agents: subagents, memory, hooks, MCP, permissions, token optimization | [Agents Best Practices](CodingAgents/docs/ClaudeCodeAgentsBestPractices.md) (~9,000) · [Configuration](CodingAgents/docs/ClaudeCodeAgentsConfiguration.md) (~6,500) · [Modularization](CodingAgents/docs/ClaudeCodeAgentsModularizationBestPractices.md) (~6,300) · [Enforcement Rules](CodingAgents/docs/ClaudeCodeAgentsEnforcementRulesBestPractices.md) (~5,300) · [Referencing](CodingAgents/docs/ClaudeCodeAgentsReferencingBestPractices.md) (~2,600) |

Each package also carries its own `ProjectContext.md` and `ProjectInstructions.md`, which define the scope and behavior of the resulting Claude Project.

## How each package is structured

All three packages share the same layout:

```
<Package>/
├── docs/                  # Readable copy of everything — browse this on GitHub
│
└── project/
    ├── 1_config/          # Upload-ready project setup: ProjectContext, ProjectDescription,
    │   │                  #   ProjectInstructions (.md + .pdf)
    │   └── prompts/       # Prompts that generated the project configuration itself
    │
    └── 2_knowledge/       # The knowledge base (.md + .pdf artifacts)
        └── prompts/       # Prompts that generated each knowledge document
```

Two things are deliberate, not accidental:

- **`docs/` duplicates `project/` markdown.** `docs/` exists for reading and linking; `project/` is the exact bundle to upload into a claude.ai Project. PDFs live only under `project/`, as generated artifacts.
- **Every document ships with its prompt lineage.** Each generation used two stages: a numbered `N_Write…Prompt.txt` meta-prompt asking Claude to author the best possible generation prompt, and the resulting `N_Generate….md` prompt that produced the documents as downloadable artifacts.

## How to use

1. **Read** — browse any [`*/docs/`](#what-s-inside) markdown directly on GitHub.
2. **Upload as a Claude Project** — create a project on claude.ai and add the files from `<Package>/project/1_config/` and `<Package>/project/2_knowledge/` (skip the `prompts/` subfolders).
3. **Regenerate or adapt** — take the generation prompts from any `prompts/` folder, adjust scope or emphasis, and produce your own version of a knowledge base with the same rigor.

## Repository layout

```
├── CodingStandards/       # Universal software development best practices
├── CodingConfiguration/   # CLAUDE.md / Claude Code configuration best practices
├── CodingAgents/          # Claude Code agents configuration & best practices
├── LICENSE                # Apache License 2.0
└── README.md
```

## License

Released under the [Apache License 2.0](LICENSE).
