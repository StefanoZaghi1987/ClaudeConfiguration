# 00 — Inventario dell'harness (Fase 0, read-only)

Data rilevamento: 2026-08-01 · Host: Windows 11 Pro 10.0.22631 · CWD: `D:\ClaudeConfiguration` · branch `feat-harness`
Modello di sessione: `claude-opus-5[1m]` · effort `high` · `alwaysThinkingEnabled: true`

Ogni riga di questo documento deriva da un file letto o elencato su disco in questa sessione. Dove un
aspetto non è determinabile dai file, è scritto **ND** (non determinabile) invece di essere inferito.

---

## 0. Sintesi numerica

| Categoria | Conteggio | Evidenza |
|---|---|---|
| Skill user-level (`~/.claude/skills/`) | **26** | listing ricorsivo di `C:\Users\stefano.zaghi\.claude\skills` |
| — di cui invocabili dal modello | 21 | 5 hanno `disable-model-invocation: true` |
| Subagent user-level (`~/.claude/agents/`) | **4** | `architect.md`, `code-reviewer.md`, `implementation-plan-reviewer.md`, `spec-reviewer.md` |
| Rules auto-caricate (`~/.claude/rules/`) | **2** | `documentation-lifecycle-rules.md`, `effort-escalation.md` |
| Slash command user-level (`~/.claude/commands/`) | **0** | la directory non esiste nel listing di `~/.claude` |
| Hook definiti in `settings.json` | **0** | `~/.claude/settings.json` non ha chiave `hooks` |
| Plugin installati | **26** | `~/.claude/plugins/installed_plugins.json` |
| — di cui abilitati | **7** | `enabledPlugins` in `~/.claude/settings.json` |
| Marketplace registrati | **3** | `~/.claude/plugins/known_marketplaces.json` |
| Server MCP configurati | **2** (`backlog`, `serena`) | `~/.claude.json` → `mcpServers` |
| — di cui che espongono tool in questa sessione | **1** (`serena`) | vedi §6 |
| Skill built-in del CLI | **13** | elenco skill annunciato dall'harness |
| `CLAUDE.md` attivi con contenuto | **0** | vedi §7 |

---

## 1. Skill user-level — `~/.claude/skills/`

`INV` = invocabile dal modello (assente `disable-model-invocation`). `File` = numero di file di supporto oltre a `SKILL.md`.
Origine da `~/.claude/skills/skills-resync/SKILL.md` §"Vendored inventory" (righe 17–73), che è la mappa autoritativa di provenienza scritta dall'utente stesso.

| # | Nome | Tipo | Origine (vendored da) | Path | Descrizione (verbatim dal frontmatter, troncata) | Trigger dichiarato | Size (righe SKILL.md + file) | INV |
|---|---|---|---|---|---|---|---|---|
| 1 | `brainstorming` | skill | plugin `superpowers` (disabilitato) — vendored | `~/.claude/skills/brainstorming/SKILL.md` | "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation." | automatico via description, imperativo ("You MUST") | 108 + 7 file (`spec-document-reviewer-prompt.md`, `visual-companion.md`, `scripts/` ×5) | sì |
| 2 | `code-review-and-quality` | skill | plugin `agent-skills` (disabilitato) — vendored | `~/.claude/skills/code-review-and-quality/SKILL.md` | "Conducts multi-axis code review. Use before merging any change. Use when reviewing code written by yourself, another agent, or a human. Use when you need to assess code quality across multiple dimensions before it enters the main branch." | automatico via description | 291 + 0 | sì |
| 3 | `code-simplification` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/code-simplification/SKILL.md` | "Simplifies code for clarity. Use when refactoring code for clarity without changing behavior. Use when code works but is harder to read, maintain, or extend than it should be. Use when reviewing code that has accumulated unnecessary complexity." | automatico via description | 263 + 0 | sì |
| 4 | `consolidate-comments` | skill | **originale** (nessun upstream — `skills-resync` L72) | `~/.claude/skills/consolidate-comments/SKILL.md` | "Run a `comment` consolidation pass over in-code comments — classify every comment unit in a declared scope against the code, delete only what a competent stranger to the module could reconstruct from the file alone, freeze and escalate everything else. Use at feature or epic completion, or on entry into brainstorming on a previously-touched area. Never mid-implementation." | automatico via description, con esclusione esplicita ("Never mid-implementation") | 153 + 0 | sì |
| 5 | `consolidate-specs` | skill | **originale** | `~/.claude/skills/consolidate-specs/SKILL.md` | "Run a `document` or `severance` consolidation pass over specs and design docs — realign a document to the code it describes, relocate historical rationale to an ADR, hand unresolvable statements to a person through a `## To be confirmed` section, or sever inbound references to a document being excluded from retrieval. Use at feature or epic completion, on entry into brainstorming on a previously-touched area, or as phase one of an exclusion. Never mid-implementation." | automatico via description | 183 + 0 | sì |
| 6 | `context-engineering` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/context-engineering/SKILL.md` | "Optimizes agent context setup. Use when starting a new session, when agent output quality degrades, when switching between tasks, or when you need to configure rules files and context for a project." | automatico via description | 209 + 0 | sì |
| 7 | `diagnosing-bugs` | skill | plugin `mattpocock-skills` (disabilitato) — vendored | `~/.claude/skills/diagnosing-bugs/SKILL.md` | "Diagnosis loop for hard bugs and performance regressions. Use when the user says \"diagnose\"/\"debug this\", or reports something broken/throwing/failing/slow." | automatico via description + trigger verbali | 82 + 2 (`agents/openai.yaml`, `scripts/hitl-loop.template.sh`) | sì |
| 8 | `dispatching-parallel-agents` | skill | plugin `superpowers` — vendored | `~/.claude/skills/dispatching-parallel-agents/SKILL.md` | "Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies" | automatico via description | 121 + 0 | sì |
| 9 | `documentation-and-adrs` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/documentation-and-adrs/SKILL.md` | "Records decisions and documentation. Use when making architectural decisions, changing public APIs, shipping features, or when you need to record context that future engineers and agents will need to understand the codebase." | automatico via description | 218 + 0 | sì |
| 10 | `doubt-driven-development` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/doubt-driven-development/SKILL.md` | "Subjects every non-trivial decision to a fresh-context adversarial review before it stands. Use when correctness matters more than speed, when working in unfamiliar code, when stakes are high (production, security-sensitive logic, irreversible operations), or any time a confident output would be cheaper to verify now than to debug later." | automatico via description | 168 + 0 | sì |
| 11 | `executing-plans` | skill | plugin `superpowers` — vendored (edit locale L3) | `~/.claude/skills/executing-plans/SKILL.md` | "Use when you have a written implementation plan to execute in a separate session with review checkpoints" | automatico via description | 45 + 0 | sì |
| 12 | `grilling` | skill | plugin `mattpocock-skills` — vendored | `~/.claude/skills/grilling/SKILL.md` | "Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases." | trigger verbale "grill" | 8 + 1 (`agents/openai.yaml`) | sì |
| 13 | `handoff` | skill | plugin `mattpocock-skills` — vendored | `~/.claude/skills/handoff/SKILL.md` | "Compact the current conversation into a handoff document for another agent to pick up." | **solo slash command** (`disable-model-invocation: true`), `argument-hint` presente | 11 + 1 | no |
| 14 | `idea-refine` | skill | plugin `agent-skills` — vendored (edit locale L1) | `~/.claude/skills/idea-refine/SKILL.md` | "Refines raw ideas into sharp, actionable concepts through structured divergent and convergent thinking. Use when an idea is still vague, when you need to stress-test assumptions before committing to a plan, or when you want to expand options before converging on one. Triggers on \"ideate\", \"refine this idea\", or \"stress-test my plan\"." | automatico + trigger verbali | 124 + 4 (`examples.md` 20 KB, `frameworks.md`, `refinement-criteria.md`, `scripts/idea-refine.sh`) | sì |
| 15 | `incremental-implementation` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/incremental-implementation/SKILL.md` | "Delivers changes incrementally. Use when implementing any feature or change that touches more than one file. Use when you're about to write a large amount of code at once, or when a task feels too big to land in one step." | automatico via description | 175 + 0 | sì |
| 16 | `interview-me` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/interview-me/SKILL.md` | "Extracts what the user actually wants instead of what they think they should want. Achieves this through one-question-at-a-time interview until ~95% confidence about the underlying intent. Use when an ask is underspecified…, when the user explicitly invokes (\"interview me\", \"grill me\", \"are we sure?\", \"stress-test my thinking\"), or when you catch yourself silently filling in ambiguous requirements before any plan, spec, or code exists." | automatico + trigger verbali | 150 + 0 | sì |
| 17 | `model-config-sync` | skill | **originale** | `~/.claude/skills/model-config-sync/SKILL.md` | "Re-validate the model-routing configuration (settings.json aliases, fallback chain, advisor, reviewer subagents, effort rules) against the current official Claude Code docs and propose updates. Manual maintenance task." | **solo slash command**; `allowed-tools: WebFetch, Read, Glob, Grep` | 27 + 0 | no |
| 18 | `planning-and-task-breakdown` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/planning-and-task-breakdown/SKILL.md` | "Breaks work into ordered tasks. Use when you have a spec or clear requirements and need to break work into implementable tasks. Use when a task feels too large to start, when you need to estimate scope, or when parallel work is possible." | automatico via description | 168 + 0 | sì |
| 19 | `security-and-hardening` | skill | plugin `agent-skills` — vendored | `~/.claude/skills/security-and-hardening/SKILL.md` | "Hardens code against vulnerabilities. Use when handling user input, authentication, data storage, or external integrations. Use when building any feature that accepts untrusted data, manages user sessions, or interacts with third-party services." | automatico via description | 367 + 0 | sì |
| 20 | `skills-resync` | skill | **originale** | `~/.claude/skills/skills-resync/SKILL.md` | "Check the vendored user skills in ~/.claude/skills against their upstream plugin copies, report drift, and — after one explicit confirmation — re-vendor every approved skill automatically. Manual maintenance task." | **solo slash command**; `allowed-tools: Bash, Read, Glob, Grep, Edit, Write` | 113 + 0 | no |
| 21 | `spec-driven-development` | skill | plugin `agent-skills` — vendored (edit locale L2) | `~/.claude/skills/spec-driven-development/SKILL.md` | "Creates specs before coding. Use when starting a new project, feature, or significant change and no specification exists yet. Use when requirements are unclear, ambiguous, or only exist as a vague idea." | automatico via description | 148 + 0 | sì |
| 22 | `subagent-driven-development` | skill | plugin `superpowers` — vendored (edit locale L3, L4) | `~/.claude/skills/subagent-driven-development/SKILL.md` | "Use when executing implementation plans with independent tasks in the current session" | automatico via description | **406** + 7 (`code-reviewer.md`, `implementer-prompt.md`, `re-review-prompt.md`, `task-reviewer-prompt.md`, `scripts/` ×3) | sì |
| 23 | `systematic-debugging` | skill | plugin `superpowers` — vendored (edit locale L3) | `~/.claude/skills/systematic-debugging/SKILL.md` | "Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes" | automatico via description | 211 + 9 (incl. `CREATION-LOG.md`, `test-pressure-1..3.md`, `find-polluter.sh`) | sì |
| 24 | `wayfinder` | skill | plugin `mattpocock-skills` — vendored | `~/.claude/skills/wayfinder/SKILL.md` | "Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear." | **solo slash command** | 75 + 1 | no |
| 25 | `writing-great-skills` | skill | plugin `mattpocock-skills` — vendored | `~/.claude/skills/writing-great-skills/SKILL.md` | "Reference for writing and editing skills well — the vocabulary and principles that make a skill predictable." | **solo slash command** | 50 + 2 (`GLOSSARY.md` 18 KB, `agents/openai.yaml`) | no |
| 26 | `writing-plans` | skill | plugin `superpowers` — vendored (edit locale L3) | `~/.claude/skills/writing-plans/SKILL.md` | "Use when you have a spec or requirements for a multi-step task, before touching code" | automatico via description | 111 + 1 (`plan-document-reviewer-prompt.md`) | sì |

### 1.1 Nota di provenienza — divergenza rispetto al brief

Il brief di questa sessione afferma: *"ho installato molte skill e plugin scelti tra i più noti, senza mai averne letto le descrizioni"*.
L'evidenza su disco contraddice questa affermazione: `~/.claude/skills/skills-resync/SKILL.md` righe 17–137 documenta
una **selezione deliberata** — 22 skill copiate fuori dai plugin di origine, 4 edit locali protetti (L1–L4) con motivazione
scritta, ed è esplicito che *"only 6 of the plugin's 14 skills are vendored. The other 8 … were deliberately dropped,
not overlooked"* (righe 54–57). Inoltre 19 dei 26 plugin installati sono già disabilitati in `settings.json`.
L'harness attuale **non è** un accumulo non curato: è un harness già potato una volta.
Questo cambia la natura dell'audit — non c'è molto da rimuovere, c'è da verificare se la potatura ha lasciato buchi.

---

## 2. Subagent user-level — `~/.claude/agents/`

| Nome | Path | Descrizione (verbatim) | Size |
|---|---|---|---|
| `architect` | `~/.claude/agents/architect.md` | "Architecture and planning designer. Use proactively at the start of planning or architecture work, before writing an implementation plan or code, to design component structure, data flow, technology choices, and trade-offs. Produces the design that the spec-reviewer then critiques." | 13 righe; tools `Read, Grep, Glob` |
| `spec-reviewer` | `~/.claude/agents/spec-reviewer.md` | "Design-spec reviewer. Use proactively at the end of any spec-writing or design phase, before planning or implementation starts. Reviews design documents, RFCs, and architecture proposals." | 12 righe; tools `Read, Grep, Glob` |
| `implementation-plan-reviewer` | `~/.claude/agents/implementation-plan-reviewer.md` | "Implementation-plan reviewer. Use proactively after an implementation plan is written and before execution begins. Reviews step sequencing, completeness, and risk of coding plans." | 12 righe; tools `Read, Grep, Glob` |
| `code-reviewer` | `~/.claude/agents/code-reviewer.md` | "Code reviewer. Use proactively at the end of an implementation phase, after code is written or modified and before the work is declared done." | 12 righe; tools `Read, Grep, Glob, Bash` |

I quattro agent sono read-only (nessuno ha `Edit`/`Write`) e coprono esattamente i gate 3, 5 e 8 del workflow principale
più la fase di design. Copie identiche versionate in `D:\ClaudeConfiguration\CodingConfiguration\project\3_ClaudeCode\config\agents\`.

Agent aggiuntivi visibili nella sessione ma **non** su disco a user-level (built-in del CLI): `claude`, `claude-code-guide`,
`Explore`, `general-purpose`, `Plan`, `statusline-setup`. Path non ispezionabile (§5).

---

## 3. Rules auto-caricate — `~/.claude/rules/`

| Nome | Path | Contenuto | Size |
|---|---|---|---|
| `documentation-lifecycle-rules.md` | `~/.claude/rules/documentation-lifecycle-rules.md` | 12 regole numerate sul ciclo di vita di spec / plan / ADR / commenti; regola 10 vieta di risolvere autonomamente divergenze doc↔codice; regola 11 impone l'append a `~/.claude/escalations.md`; regola 12 rimanda a `~/.claude/documentation-lifecycle.md` (**102 195 byte**) da leggere per sezioni. | 1 212 B |
| `effort-escalation.md` | `~/.claude/rules/effort-escalation.md` | Politica di escalation dell'effort: restare al default, raccomandare `xhigh` solo per 4 casi; per esplorazione bulk delegata a subagent preferire il modello `haiku`. | 503 B |

Entrambi risultano iniettati in contesto in questa sessione. Copie versionate in
`…\project\3_ClaudeCode\config\rules\`.

**Anomalia rilevata:** `~/.claude/escalations.md` **non esiste** nel listing di `~/.claude`, pur essendo il target
obbligatorio della regola 11. La regola non ha un sink su disco.

---

## 4. Plugin installati — `~/.claude/plugins/`

Fonte: `installed_plugins.json` + `enabledPlugins` in `~/.claude/settings.json`. Conteggi componenti da listing filesystem
di `~/.claude/plugins/cache/<marketplace>/<plugin>/<versione>/`.

### 4.1 Plugin ABILITATI (7)

| Plugin | Versione | Marketplace | Skill | Agent | Cmd | Hook | MCP | Componenti (nome · descrizione verbatim troncata · size) |
|---|---|---|---|---|---|---|---|---|
| `ponytail` | 4.8.4 | `ponytail` (github `DietrichGebert/ponytail`) | 6 | 0 | 6 | 3 eventi | – | **skill:** `ponytail` (95 righe) "Forces the laziest solution that actually works… Supports intensity levels: lite, full (default), ultra. Use on ANY coding task: writing, adding, refactoring, fixing, reviewing, or designing code" · `ponytail-audit` (31) · `ponytail-debt` (31) · `ponytail-gain` (38) · `ponytail-help` (50) · `ponytail-review` (40). **cmd:** `/ponytail`, `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`, `/ponytail-help` (file `.toml`, 515–1152 B). **hook** (`hooks/claude-codex-hooks.json`): `SessionStart` (matcher `startup\|resume\|clear\|compact` → `ponytail-activate.js`), `SubagentStart` (→ `ponytail-subagent.js`), `UserPromptSubmit` (→ `ponytail-mode-tracker.js`), timeout 5 s ciascuno. Stato corrente: `~/.claude/.ponytail-active` = `full`. |
| `claude-code-setup` | 1.0.0 | official | 1 | 0 | 0 | 0 | – | `claude-automation-recommender` (211 righe) "Analyze a codebase and recommend Claude Code automations (hooks, subagents, skills, plugins, MCP servers)…" |
| `claude-md-management` | 1.0.0 | official | 1 | 0 | 1 | 0 | – | skill `claude-md-improver` (131) "Audit and improve CLAUDE.md files in repositories…" · cmd `/claude-md-management:revise-claude-md` (37) "Update CLAUDE.md with learnings from this session" |
| `code-review` | unknown (sha `20a5a1f`) | official | 0 | 0 | 1 | 0 | – | cmd `/code-review:code-review` "Code review a pull request" |
| `mcp-server-dev` | unknown | official | 3 | 0 | 0 | 0 | – | `build-mcp-server` (140) · `build-mcp-app` (300) · `build-mcpb` (146) |
| `skill-creator` | unknown | official | 1 | 0 | 0 | 0 | – | `skill-creator` (327) "Create new skills, modify and improve existing skills, and measure skill performance…" |
| `explanatory-output-style` | 1.0.0 | official | 0 | 0 | 0 | 1 | – | `hooks/hooks.json` + `hooks-handlers/session-start.sh`. Effetto osservato: inietta l'output style "explanatory" con obbligo di blocchi `★ Insight`. |

### 4.2 Plugin DISABILITATI (19) — presenti in cache, inerti

| Plugin | Ver | Skill | Agent | Cmd | Hook | MCP | Rilevanza per il workflow |
|---|---|---|---|---|---|---|---|
| `superpowers` | 6.2.0 | 14 | 0 | 0 | 1 | – | **Alta.** 6/14 skill già vendored a user-level. Le 8 non vendored: `finishing-a-development-branch` (143), `receiving-code-review` (155), `requesting-code-review` (70), `test-driven-development` (247), `using-git-worktrees` (112), `using-superpowers` (43), `verification-before-completion` (94), `writing-skills` (487). Hook `SessionStart` che inietterebbe `using-superpowers` per intero in ogni sessione. |
| `agent-skills` (addy) | `7829ffd9` | 24 | 4 | 8 | 9 file | – | **Alta.** 11/24 skill vendored. Le 13 non vendored includono `test-driven-development` (300), `api-and-interface-design` (226), `debugging-and-error-recovery` (231), `git-workflow-and-versioning` (259), `source-driven-development` (143), `performance-optimization` (315), `observability-and-instrumentation` (150), `shipping-and-launch` (241), `deprecation-and-migration` (178), `ci-cd-and-automation` (318), `frontend-ui-engineering` (257), `browser-testing-with-devtools` (239), `using-agent-skills` (146). Agent: `code-reviewer`, `security-auditor`, `test-engineer`, `web-performance-auditor`. Cmd: `/build /code-simplify /plan /review /ship /spec /test /webperf`. Hook: `sdd-cache-pre/post.sh`, `simplify-ignore.sh`, `session-start.sh`. |
| `mattpocock-skills` | 1.2.0 | 6 | 0 | 0 | 0 | – | **Media.** 5/6 skill vendored; 1 non vendored (ND quale — non enumerata in questa fase). |
| `pr-review-toolkit` | unknown | 0 | 6 | 1 | 0 | – | Media (code review multi-agente). Agent non enumerati in Fase 0. |
| `code-simplifier` | 1.0.0 | 0 | 1 | 0 | 0 | – | Bassa — sovrapposto a `code-simplification` + `ponytail-review`. |
| `feature-dev` | unknown | 0 | 3 | 1 | 0 | – | Media — pipeline feature alternativa. |
| `security-guidance` | 2.0.6 | 0 | 0 | 0 | 20 file | – | Media — hook di sicurezza, sovrapposto a `security-and-hardening`. |
| `plugin-dev` | unknown | 7 | 3 | 1 | 0 | – | Bassa (meta-tooling). |
| `agent-sdk-dev` | unknown | 0 | 2 | 1 | 0 | – | Bassa. |
| `ralph-loop` | 1.0.0 | 0 | 0 | 3 | 2 | – | Bassa — sovrapposto a `/loop` built-in. |
| `chrome-devtools-mcp` | 1.6.0 | 6 | 0 | 0 | 0 | – | Bassa — sovrapposto a `claude-in-chrome` MCP attivo. |
| `playwright` | unknown | 0 | 0 | 0 | 0 | sì | Bassa. |
| `github` | unknown | 0 | 0 | 0 | 0 | sì | Media se si usa `gh` per PR. |
| `figma` | 2.2.87 | 12 | 0 | 0 | 0 | sì | Nulla per questo workflow. |
| `firecrawl` | 1.0.9 | 10 | 0 | 1 | 0 | – | Nulla. |
| `huggingface-skills` | 1.0.20 | 25 | 0 | 0 | 0 | sì | Nulla. |
| `sentry` | 1.2.0 | 12 | 0 | 0 | 0 | – | Nulla. |
| `frontend-design` | unknown | 1 | 0 | 0 | 0 | – | Nulla. |
| `playground` | unknown | 1 | 0 | 0 | 0 | – | Nulla. |

### 4.3 Residui in cache non riferiti da `known_marketplaces.json`

| Path (relativo a `~/.claude/plugins/cache/`) | Contenuto |
|---|---|
| `sorbh/interview-me/` | 1 skill. Marketplace `sorbh` **non** registrato → cache orfana. |
| `temp_git_1785151907095_udtf5u/`, `temp_git_1785152311891_anpy8x/`, `temp_git_1785482250046_i8wiz2/` | 4 directory temporanee di clone git, nessun componente riconoscibile. Residui di installazione. |

---

## 5. Skill built-in del CLI (13)

Path non ispezionabile: l'installazione è nativa (`C:\Users\stefano.zaghi\.local\bin\claude.exe`, versioni in
`~/.local\share\claude\versions`) e le skill built-in sono compilate nel binario, non presenti come file `.md`.
Descrizioni riportate **verbatim dall'elenco skill annunciato dall'harness** in questa sessione — questa è l'unica
fonte disponibile localmente.

| Nome | Descrizione (verbatim, troncata) | Fase workflow |
|---|---|---|
| `init` | "Initialize a new CLAUDE.md file with codebase documentation" | doc consolidation / setup |
| `review` | "Review a GitHub pull request; for your working diff use /code-review" | code review |
| `security-review` | "Complete a security review of the pending changes on the current branch" | code review |
| `simplify` | "Review the changed code for reuse, simplification, efficiency, and altitude cleanups, then apply the fixes. Quality only — it does not hunt for bugs; use /code-review for that." | code review |
| `update-config` | "Use this skill to configure the Claude Code harness via settings.json. Automated behaviors … require hooks configured in settings.json…" | cross-cutting (config) |
| `fewer-permission-prompts` | "Scan your transcripts for common read-only Bash and MCP tool calls, then add a prioritized allowlist to project .claude/settings.json…" | cross-cutting (token/friction) |
| `keybindings-help` | "…customize keyboard shortcuts, rebind keys, add chord bindings…" | nessuna |
| `loop` | "Run a prompt or slash command on a recurring interval…" | cross-cutting |
| `schedule` | "Create, update, list, or run scheduled cloud agents (routines)…" | cross-cutting |
| `claude-api` | "Reference for the Claude API / Anthropic SDK — model ids, pricing, params, streaming, tool use, MCP, agents, caching, token counting, model migration." + TRIGGER/SKIP obbligatori | cross-cutting |
| `claude-in-chrome` | "Automates your Chrome browser… Always invoke BEFORE attempting to use any mcp__claude-in-chrome__* tools." | testing |
| `run` | "Launch and drive this project's app to see a change working…" | coding / verifica |
| `dataviz` | "Use this skill whenever you are about to create ANY chart, graph, plot, dashboard, or data visualization…" | nessuna |

---

## 6. Server MCP

| Server | Config | Comando | Tool esposti in questa sessione | Note |
|---|---|---|---|---|
| `serena` | `~/.claude.json` → `mcpServers.serena` (scope user, globale) | `uvx --from git+https://github.com/oraios/serena serena start-mcp-server` | **29** (`find_symbol`, `find_referencing_symbols`, `get_symbols_overview`, `replace_symbol_body`, `search_for_pattern`, `write_memory`/`read_memory`/`list_memories`, `execute_shell_command`, `onboarding`, `initial_instructions`, …) | Istruzioni server: *"CRITICAL: Before starting to work on a coding task, call the `initial_instructions` tool"*. Copre navigazione simbolica del codebase e una memoria propria per progetto. |
| `backlog` | `~/.claude.json` → `mcpServers.backlog` (scope user, globale) | `backlog mcp start` (CLI presente: `C:\Users\stefano.zaghi\AppData\Roaming\npm\backlog.ps1`, **v1.45.1**) | **0** | Le istruzioni del server sono iniettate nel system prompt (*"At the beginning of each session, list the available resources…"*) ma **nessun tool `mcp__backlog__*` risulta disponibile**. Nessuna directory `backlog/` esiste in `D:\ClaudeConfiguration`. Il progetto non è inizializzato con Backlog MD e in questa sessione il server non espone strumenti. |
| `claude-in-chrome` | Estensione Chrome, non in `mcpServers` | – | **22** | `hasCompletedClaudeInChromeOnboarding: true` in `~/.claude.json`. |
| `ide` | Integrazione IDE, non in `mcpServers` | – | **2** (`executeCode`, `getDiagnostics`) | – |

Nessun riferimento a **Graphify** esiste da nessuna parte: ricerca `*graphify*` ricorsiva su `~/.claude` → 0 risultati;
ricerca directory su `D:\` → 0 risultati; non compare in `mcpServers`, in `installed_plugins.json`, né nei tool esposti.

---

## 7. `CLAUDE.md`, settings e configurazione di progetto

| Elemento | Stato | Evidenza |
|---|---|---|
| `~/.claude/CLAUDE.md` | **esiste ma è vuoto (0 byte)** | listing `~/.claude` |
| `D:\ClaudeConfiguration\CLAUDE.md` | **non esiste** | ricerca ricorsiva `CLAUDE.md` su tutto il repo (esclusa `.git`) → 1 solo risultato |
| `D:\ClaudeConfiguration\.claude\` | **non esiste** | ricerca ricorsiva directory `.claude` → 1 solo risultato, sotto `CodingConfiguration\project\3_ClaudeCode\config\` |
| `…\project\3_ClaudeCode\config\.claude\CLAUDE.md` | esiste, **0 byte** (template versionato vuoto) | `Get-Item .Length` = 0 |
| `.claude/settings.json` / `settings.local.json` di progetto | **non esistono** | listing progetto |
| `~/.claude/settings.json` | 64 righe. `model: opus[1m]`, `fallbackModel: [opus, sonnet, haiku]`, `effortLevel: high`, `advisorModel: fable`, `alwaysThinkingEnabled: true`, `permissions: {}` (vuoto), `disableClaudeAiConnectors: true`, `disableArtifact: true`, `verbose: true`, `tui: fullscreen`, `skipWorkflowUsageWarning: true`, `remoteControlAtStartup: true`. **Nessuna chiave `hooks`.** | file letto |
| `~/.claude.json` → `projects["D:/ClaudeConfiguration"]` | `mcpServers: {}`, `hasTrustDialogAccepted`, `allowedTools`, `enabledMcpjsonServers`/`disabled` vuoti | letto come hashtable |

Conseguenza: **tutte** le istruzioni persistenti dell'utente arrivano da `~/.claude/rules/*.md` (2 file, ~1,7 KB) e
da nessun `CLAUDE.md`. Il repo `D:\ClaudeConfiguration` **non ha istruzioni di progetto proprie**: quando si lavora
in questo repo, l'agente opera senza contesto di progetto oltre a quello che scopre da sé.

### 7.1 Il repo come sorgente di verità versionata

`D:\ClaudeConfiguration` non è un progetto software: è il repo di documentazione + configurazione. Contiene copie
versionate della config installata:

| Path nel repo | Corrisponde a | Stato |
|---|---|---|
| `CodingConfiguration\project\3_ClaudeCode\config\agents\*.md` (4 file) | `~/.claude/agents/` | 4/4 presenti |
| `CodingConfiguration\project\3_ClaudeCode\config\rules\*.md` (2 file) | `~/.claude/rules/` | 2/2 presenti |
| `CodingConfiguration\project\3_ClaudeCode\config\skills\model-config-sync\`, `skills-resync\`, `skills-resync_backup_202608\` | `~/.claude/skills/` | solo 3 delle 26 skill installate sono versionate (le 2 originali + 1 backup). Le 22 vendored e `consolidate-*` **non** sono nel repo. |
| `CodingConfiguration\project\3_ClaudeCode\commands\*.md` (4 file) | **nessuna installazione** | 4 prompt template (`ClaudeCode_BrainstormingPrompt.md` 12 righe, `ClaudeCode_PlanningMode_ExecuteTaskPrompt.md` 16, `ClaudeCode_SubAgentDriven_ExecuteTaskPrompt.md` 15, `ClaudeCode_SubAgentDriven_PlanningMode_ExecuteTaskPrompt.md` 18). `~/.claude/commands/` non esiste → **non sono slash command attivi**, sono testo da copiare a mano. |

`consolidate-comments` e `consolidate-specs` — le due skill originali che implementano le regole in
`documentation-lifecycle-rules.md` — **non sono versionate in nessun repo**. Esistono solo in `~/.claude/skills/`.

---

## 8. Hook attivi in questa sessione

| Evento | Sorgente | Effetto osservato |
|---|---|---|
| `SessionStart` (startup) | `ponytail` plugin → `hooks/ponytail-activate.js` | Iniezione di ~90 righe di istruzioni "PONYTAIL MODE ACTIVE — level: full": ladder YAGNI/stdlib/native, regole su deletion-over-addition, obbligo di commenti `ponytail:`, obbligo di un self-check runnable per logica non banale. |
| `SessionStart` | `explanatory-output-style` plugin → `hooks-handlers/session-start.sh` | Attivazione output style "explanatory": obbligo di blocchi `★ Insight` prima e dopo la scrittura di codice. |
| `SubagentStart` | `ponytail` → `ponytail-subagent.js` | Propagazione della modalità ponytail ai subagent. |
| `UserPromptSubmit` | `ponytail` → `ponytail-mode-tracker.js` | Tracking/switch di livello a ogni prompt (costo per turno). |

Nessun hook definito dall'utente. Nessun hook `PreToolUse`/`PostToolUse` attivo → nessun gate automatico su scrittura
di file, test, o lint.

---

## 9. Shortlist proposta per la Fase 1

Criterio: la skill/agent/command è **disponibile ora** (non appartiene a un plugin disabilitato) **e** copre almeno una
fase del workflow. I componenti di plugin disabilitati sono esclusi dalla shortlist ma trattati in Fase 2 come
*opzioni di riattivazione* e in Fase 3/5 come decisioni.

| Fase workflow | Candidati in shortlist (dossier da produrre) |
|---|---|
| 1 · Brainstorming | `brainstorming`, `interview-me`, `grilling`, `idea-refine`, `wayfinder` |
| 2 · Spec | `spec-driven-development`, `brainstorming` (fase spec), `architect` (agent) |
| 3 · Spec review | `spec-reviewer` (agent), `brainstorming/spec-document-reviewer-prompt.md`, `doubt-driven-development`, `grilling` |
| 4 · Implementation plan | `writing-plans`, `planning-and-task-breakdown`, `architect` (agent) |
| 5 · Plan review | `implementation-plan-reviewer` (agent), `writing-plans/plan-document-reviewer-prompt.md`, `doubt-driven-development` |
| 6 · Task atomiche / Backlog MD | `planning-and-task-breakdown`, `wayfinder`, CLI `backlog` v1.45.1 (+ MCP non funzionante, §6) |
| 7 · Coding | `subagent-driven-development`, `executing-plans`, `incremental-implementation`, `dispatching-parallel-agents`, `ponytail`, `run` (built-in) |
| 8 · Code review | `code-review-and-quality`, `code-reviewer` (agent), `ponytail-review`, `code-simplification`, `security-and-hardening`, `simplify` (built-in), `security-review` (built-in), `review`/`/code-review` (built-in + plugin), `doubt-driven-development` |
| 9 · Doc consolidation | `consolidate-specs`, `consolidate-comments`, `documentation-and-adrs`, `claude-md-improver`, `/revise-claude-md`, `init` (built-in) |
| 10 · Cross-cutting | `serena` MCP, `context-engineering`, `systematic-debugging`, `diagnosing-bugs`, `handoff`, `skills-resync`, `model-config-sync`, `writing-great-skills`, `skill-creator`, `claude-automation-recommender`, `update-config`, `fewer-permission-prompts`, `claude-api`, `loop` |

**Fuori shortlist, con motivo in una riga:**

- `figma`, `firecrawl`, `huggingface-skills`, `sentry`, `frontend-design`, `playground`, `playwright`, `chrome-devtools-mcp` — nessuna fase del workflow, tutti già disabilitati.
- `mcp-server-dev` (3 skill), `skill-creator`, `plugin-dev`, `agent-sdk-dev` — meta-tooling: si attivano solo quando l'oggetto di lavoro *è* un MCP/skill/plugin. Rilevanti per questo repo specifico, non per il workflow generale; trattati in Fase 3 solo per rischio di trigger spurio.
- `dataviz`, `keybindings-help`, `schedule`, `claude-in-chrome` (skill) — nessuna fase.
- `ralph-loop`, `code-simplifier`, `feature-dev`, `security-guidance`, `pr-review-toolkit`, `github` — disabilitati e sovrapposti a componenti già in shortlist; ricompaiono in Fase 5 come `REMOVE`.

### 9.1 Strategia di campionamento per la Fase 1 (richiesta dal vincolo ~30 letture)

La shortlist richiede **28 letture di corpo completo**: 21 skill user-level invocabili + 4 skill user-level
slash-only (`handoff`, `wayfinder`, `skills-resync`✓, `model-config-sync`✓, `writing-great-skills`) + `ponytail`
+ 2 skill plugin abilitati (`claude-md-improver`, `claude-automation-recommender`), più 8 file di supporto piccoli
(4 agent da 12–13 righe, 2 reviewer-prompt da ~1,7 KB, 4 prompt di `subagent-driven-development`).

Per rientrare nel vincolo propongo:

1. **Leggere per intero** i 21 corpi delle skill invocabili + `ponytail` + i 4 agent + i 2 reviewer-prompt = **28 file**, di cui 6 già letti in Fase 0.
2. **Non leggere** i file di reference voluminosi, sostituendoli con il solo elenco: `idea-refine/examples.md` (20 KB), `writing-great-skills/GLOSSARY.md` (18 KB), `systematic-debugging/test-pressure-*.md` + `CREATION-LOG.md`, `brainstorming/visual-companion.md` (13 KB) + `brainstorming/scripts/*` (49 KB), `~/.claude/documentation-lifecycle.md` (102 KB). Compaiono nel dossier come costo token, non come contenuto.
3. **Leggere solo `implementer-prompt.md` e `task-reviewer-prompt.md`** di `subagent-driven-development` (decisivi per stimare il moltiplicatore subagent); `code-reviewer.md` e `re-review-prompt.md` solo elencati.
4. **Non leggere** i corpi dei plugin disabilitati. Conseguenza dichiarata: per `test-driven-development`, `verification-before-completion`, `requesting-code-review`, `source-driven-development`, `api-and-interface-design` il dossier riporterà **ND** sul contenuto e li tratterà solo come *gap noti* con nome, path e conteggio righe.
5. `claude-md-improver` e `claude-automation-recommender` (131 + 211 righe): letti solo se emergono come candidati reali in Fase 2 §9; altrimenti dossier ridotto a frontmatter + verdetto.

Questo tiene le letture di Fase 1 a ~28 file per ~3 500 righe di corpo.
