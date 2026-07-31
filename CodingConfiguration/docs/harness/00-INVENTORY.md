# 00 — Inventario dell'harness (Fase 0, read-only)

> Audit dell'harness Claude Code di **Stefano Zaghi**. Scope: **user-level** (`~/.claude/`).
> Il progetto corrente `D:\ClaudeConfiguration` è un repo di *curation* di doc/config (sotto-dir `CodingStandards/`, `CodingAgents/`, `CodingConfiguration/` con `docs/` e `project/{1_config,2_knowledge}/prompts/`): **non contiene `.claude/` attivo**, quindi tutto l'harness sotto audit è user-level e si applica a ogni progetto.
>
> **Metodo anti-token applicato:** frontmatter + conteggio righe via `wc` per tutte le skill; corpi completi solo per la shortlist (Fase 1). Le *description* sono riportate dal registro skill caricato dall'harness (corrispondono al frontmatter on-disk); verificate verbatim per la shortlist in `10-EVIDENCE.md`.
>
> **Evidence**: ogni riga cita il path sorgente. Date `lastUsedAt` in unix-ms; `17854xxxxxxx` ≈ fine luglio 2026 (oggi).

---

## 1. Configurazione (evidence)

### 1.1 Plugin abilitati — `~/.claude/settings.json:11-38`

13 plugin abilitati (`true`), 13 disabilitati. Fonte: `C:/Users/stefano.zaghi/.claude/settings.json`.

| Plugin | Marketplace | Abilitato | Note |
|---|---|---|---|
| `superpowers` | claude-plugins-official (v6.2.0) | ✅ | spina dorsale del workflow (vedi §4) |
| `agent-skills` (addy osmani) | addy-agent-skills (7829ffd90d97) | ✅ | 24 skill + 8 cmd + 4 agent — **inusato** |
| `mattpocock-skills` | claude-plugins-official (v1.2.0) | ✅ | 22 skill dichiarate — **inusate** |
| `ponytail` | ponytail (v4.8.4) | ✅ | modalità "lazy" via SessionStart hook |
| `code-review` | claude-plugins-official | ✅ | 1 comando |
| `code-simplifier` | claude-plugins-official (v1.0.0) | ✅ | 1 agent (+cmd `simplify`?) |
| `feature-dev` | claude-plugins-official | ✅ | 1 cmd + 3 agent |
| `claude-md-management` | claude-plugins-official (v1.0.0) | ✅ | 1 skill + 1 cmd |
| `claude-code-setup` | claude-plugins-official (v1.0.0) | ✅ | 1 skill |
| `skill-creator` | claude-plugins-official | ✅ | 1 skill (meta: creare skill) |
| `mcp-server-dev` | claude-plugins-official | ✅ | 3 skill (meta: creare MCP) |
| `security-guidance` | claude-plugins-official (v2.0.6) | ✅ | guidance/hooks (+cmd `security-review`?) |
| `explanatory-output-style` | claude-plugins-official (v1.0.0) | ✅ | output style via SessionStart hook |

**Disabilitati (rumore nel cache, non consumano contesto):** `firecrawl`, `sentry`, `huggingface-skills`, `chrome-devtools-mcp`, `figma`, `playwright`, `frontend-design`, `ralph-loop`, `agent-sdk-dev`, `plugin-dev`, `playground`, `github`, `pr-review-toolkit`. Marketplaces esterni disponibili ma non abilitati: `asana`, `context7`, `discord`, `firebase`, `gitlab`, `greptile`, `imessage`, `laravel-boost`, `linear`, `serena`, `telegram`, `terraform` (in `plugins/marketplaces/...`).

### 1.2 MCP server — `~/.claude.json:2130`

| Server | Origine | Config | Tool osservati in sessione |
|---|---|---|---|
| `backlog` | user (`.claude.json:2130`, stdio `backlog mcp start`) | **Backlog MD** = task management (fase 6 workflow) | risorse backlog |
| `ide` | iniettato da estensione VS Code | n/d | getDiagnostics, executeCode |
| `web_reader` / `4_5v_mcp` | iniettato da estensione VS Code | n/d | webReader, analyze_image |

Nessun `mcpServers` per-progetto con contenuto (tutti `{}` in `.claude.json`). **Graphify non è un MCP attivo** (vedi §7).

### 1.3 Agenti (subagent) user-level — `~/.claude/agents/*.md`

4 agenti, model `fable`, read-only (Read/Grep/Glob; `code-reviewer` anche Bash). Formano una catena di review pulita:

| Agente | Path | Scope (dal corpo) |
|---|---|---|
| `architect` | `~/.claude/agents/architect.md` | progetta l'architettura; **produce** il design che `spec-reviewer` critica |
| `spec-reviewer` | `~/.claude/agents/spec-reviewer.md` | review spec (correctness/architecture/security/maintainability) |
| `implementation-plan-reviewer` | `~/.claude/agents/implementation-plan-reviewer.md` | review plan (sequencing/completeness/risk) |
| `code-reviewer` | `~/.claude/agents/code-reviewer.md` | review `git diff` (correctness/security/architecture/maintainability) |

Agenti forniti da plugin (in `Available agent types`): `agent-skills:{code-reviewer, security-auditor, test-engineer, web-performance-auditor}`, `feature-dev:{code-architect, code-explorer, code-reviewer}`, più i built-in (`Explore`, `Plan`, `general-purpose`, `claude-code-guide`, `code-simplifier:code-simplifier`, `statusline-setup`).

### 1.4 Istruzioni globali — `~/.claude/rules/*.md` + CLAUDE.md

- **`~/.claude/CLAUDE.md` è vuoto (0 byte).** Le istruzioni globali vivono in `~/.claude/rules/`:
  - `documentation-lifecycle-rules.md` (12 righe-budget; no-append sulle spec; flag-don't-rewrite; intake path `INTAKE_PATH` non valorizzato).
  - `effort-escalation.md` (resta a effort default; raccomanda `xhigh` solo per debug multi-file, decisioni architetturali, security review, verification pass).
- **Hooks attivi via SessionStart (iniettati in ogni sessione):** `ponytail` (full), `explanatory-output-style`. L'estensione IDE aggiunge contesto "Insight".
- `settings.json`: `model: opus[1m]`, `effortLevel: high`, `alwaysThinkingEnabled: true`, `advisorModel: fable`, `disableArtifact: true`, `disableClaudeAiConnectors: true`, `verbose: true`, `workflowSizeGuideline: medium` (`.claude.json:2849`).

---

## 2. Inventario abilitato — Skill (con dimensione)

`dimensione` = righe SKILL.md (misurate con `wc -l`) + presenza dir di supporto. **Solo il `description` è always-on nel registro; il corpo si carica on-demand all'invocazione.**

### 2.1 Skill user-level — `~/.claude/skills/`

| Skill | Righe | Supporto | Description (frontmatter) |
|---|---|---|---|
| `consolidate-comments` | n/d | — | consolidation pass su commenti in-code: classifica vs codice, cancella solo il ricostruibili, freeze+escalate il resto. Mai mid-implementation. |
| `consolidate-specs` | n/d | — | consolidation pass su spec/design doc: riallinea al codice, sposta il rationale storico in ADR, consegna a una persona via `## To be confirmed`. Mai mid-implementation. |
| `model-config-sync` | n/d | — | (skill user-level; dettagli in Fase 1 se entra in shortlist) |

### 2.2 `superpowers` (v6.2.0) — `cache/.../superpowers/6.2.0/skills/`

| Skill | Righe | Supporto | Fase workflow |
|---|---|---|---|
| `using-superpowers` | 62 | references/ | trasversale (meta: come usare le skill; **forza-iniettata EXTREMELY_IMPORTANT a ogni session start**) |
| `brainstorming` | 151 | scripts/ | 1 brainstorming |
| `writing-plans` | 168 | — | 4 implementation plan |
| `executing-plans` | 64 | — | 7 coding |
| `subagent-driven-development` | 503 | scripts/ | 7 coding (subagent) |
| `dispatching-parallel-agents` | 167 | — | 7 coding (parallelismo) |
| `requesting-code-review` | 95 | — | 8 code review |
| `receiving-code-review` | 205 | — | 8 code review |
| `systematic-debugging` | 283 | — | 10 debug |
| `test-driven-development` | 320 | — | 7/10 testing |
| `using-git-worktrees` | 167 | — | 10 isolamento |
| `finishing-a-development-branch` | 201 | — | 10 integrazione |
| `verification-before-completion` | 120 | — | 10 verifica |
| `writing-skills` | 679 | — | 10 meta (creare skill) |

### 2.3 `agent-skills` / addy (24 skill + 8 cmd + 4 agent) — `cache/addy-agent-skills/.../skills/`

| Skill | Righe | Fase workflow |
|---|---|---|
| `spec-driven-development` | 206 | 2 spec |
| `planning-and-task-breakdown` | 234 | 4 plan / 6 task |
| `test-driven-development` | 398 | 7/10 testing |
| `incremental-implementation` | 249 | 7 coding |
| `code-review-and-quality` | 396 | 8 code review |
| `code-simplification` | 331 | 8/10 semplificazione |
| `debugging-and-error-recovery` | 300 | 10 debug |
| `security-and-hardening` | 467 | 10 security |
| `performance-optimization` | 396 | 10 perf |
| `context-engineering` | 289 | 10 contesto |
| `documentation-and-adrs` | 288 | 9 doc |
| `git-workflow-and-versioning` | 355 | 10 git |
| `ci-cd-and-automation` | 390 | 10 ci/cd |
| `shipping-and-launch` | 310 | 10 ship |
| `frontend-ui-engineering` | 328 | 7 frontend |
| `api-and-interface-design` | 294 | 2/4 design API |
| `browser-testing-with-devtools` | 317 | 10 browser test |
| `observability-and-instrumentation` | 203 | 10 observability |
| `deprecation-and-migration` | 247 | 10 migration |
| `doubt-driven-development` | 243 | 3/5 review adversariale |
| `interview-me` | 225 | 1 brainstorming/requisiti |
| `idea-refine` | 178 | 1 brainstorming |
| `source-driven-development` | 194 | 10 (grounding su docs) |
| `using-agent-skills` | 191 | trasversale (meta) |
| **cmd** `build` `code-simplify` `plan` `review` `ship` `spec` `test` `webperf` | — | 2/4/7/8 (slash command) |
| **agent** `code-reviewer` `security-auditor` `test-engineer` `web-performance-auditor` | — | 8/10 (subagent) |

### 2.4 `mattpocock-skills` (v1.2.0) — 22 skill dichiarate in `plugin.json:21-44`

`plugin.json` dichiara 22 skill; **9 risultano attive nel registro di questa sessione** (discrepanza da verificare in Fase 1). Righe delle 9 attive:

| Skill (attiva) | Righe | Fase |
|---|---|---|
| `code-review` | 89 | 8 code review |
| `codebase-design` | 114 | 2/4 design moduli |
| `diagnosing-bugs` | 134 | 10 debug |
| `domain-modeling` | 74 | 2/10 domain |
| `prototype` | 26 | 1/7 prototipo |
| `research` | 12 | 10 ricerca |
| `resolving-merge-conflicts` | 14 | 10 git |
| `tdd` | 36 | 7/10 testing |
| `grilling` | 12 | 1/3/5 stress-test idee/spec/plan |

Dichiarate ma NON attive in sessione (da verificare): `ask-matt`, `grill-with-docs`, `triage`, `improve-codebase-architecture`, `setup-matt-pocock-skills`, `to-spec`, `to-tickets`, `wayfinder`, `implement`, `handoff`, `teach`, `writing-great-skills`, `grill-me`.

### 2.5 `ponytail` (v4.8.4) — modalità lazy via SessionStart

| Skill | Righe | Fase |
|---|---|---|
| `ponytail` | 120 | trasversale (forza la soluzione più lazy; sempre attivo) |
| `ponytail-review` | 57 | 8 (review solo over-engineering) |
| `ponytail-audit` | 41 | 10 (audit over-eng. whole-repo) |
| `ponytail-debt` | 44 | 10 (ledger delle scorciatoie `ponytail:`) |
| `ponytail-gain` | 50 | 10 (scoreboard impatto) |
| `ponytail-help` | 71 | 10 (reference) |

### 2.6 Altri plugin abilitati (skill/cmd singole)

| Plugin | Item | Righe | Supporto | Fase |
|---|---|---|---|---|
| `claude-md-management` | `claude-md-improver` (skill) | 179 | references/ | 9 doc |
| `claude-md-management` | `revise-claude-md` (cmd) | — | — | 9 doc |
| `claude-code-setup` | `claude-automation-recommender` | 288 | references/ | 10 (consiglia automazioni) |
| `skill-creator` | `skill-creator` | 485 | assets/+references/+scripts/ | 10 meta |
| `mcp-server-dev` | `build-mcp-server` | 221 | references/ | 10 meta (MCP) |
| `mcp-server-dev` | `build-mcp-app` | 392 | references/ | 10 meta (MCP) |
| `mcp-server-dev` | `build-mcpb` | 199 | references/ | 10 meta (MCP) |
| `code-review` | `code-review` (cmd) | — | — | 8 |
| `feature-dev` | `feature-dev` (cmd) | — | — | 2→7 (feature flow guidato) |
| `code-simplifier` | `code-simplifier` (agent) | — | — | 8/10 |

### 2.7 Comandi/skill built-in Claude Code (no path user/plugin)

`init`, `review`, `run`, `security-review`, `simplify`, `loop`, `dataviz`, `update-config`, `keybindings-help`, `fewer-permission-prompts`, `claude-api`. Origine: built-in Claude Code (non modificabili da questa config).

---

## 3. Hook / Output style

| Elemento | Origine | Meccanismo | Effetto sempre-on |
|---|---|---|---|
| `ponytail` (full) | plugin ponytail, SessionStart hook | inietta prompt "lazy senior dev" | applica la ladder a OGNI risposta |
| `explanatory` output style | plugin explanatory-output-style, SessionStart | inietta stile + blocco "Insight" | aggiunge insight educativi a ogni risposta |
| `using-superpowers` EXTREMELY_IMPORTANT | plugin superpowers, iniettato a session start | obbliga il check skill prima di ogni risposta | behavioral + token cost ogni turno |

---

## 4. Statistiche d'uso empiriche — `~/.claude.json:1859` (`skillUsage`)

**Questo è il dato più decisivo per i verdetti keep/disable.** `usageCount` reale, non installato.

| Skill/comando | usageCount | ultimo uso | Lettura |
|---|---|---|---|
| `superpowers:writing-plans` | **48** | recentissimo | **cuore del workflow** |
| `superpowers:subagent-driven-development` | **45** | recentissimo | **cuore del workflow** |
| `superpowers:brainstorming` | **41** | recentissimo | **cuore del workflow** |
| `superpowers:finishing-a-development-branch` | **30** | recentissimo | integrazione |
| `brainstorming` (bare) | 19 | medio | (voce legacy/duplicata) |
| `feature-dev:feature-dev` | 14 | medio | feature flow |
| `superpowers:systematic-debugging` | 14 | recente | debug |
| `claude-md-management:claude-md-improver` | 14 | medio | doc |
| `update-config` | 10 | recentissimo | config |
| `claude-md-management:revise-claude-md` | 9 | vecchio | doc |
| `init` | 7 | recente | onboarding |
| `graphify` | 7 | **~2 mesi fa, non più attivo** | vedi §7 |
| `context-engineering` | 2 | recente | (unica traccia di agent-skills) |
| `superpowers:executing-plans` | 4 | recente | coding |
| `superpowers:dispatching-parallel-agents` | 1 | vecchio | — |
| `superpowers:requesting-code-review` | 1 | vecchio | — |
| `superpowers:receiving-code-review` | 1 | vecchio | — |
| `superpowers:using-superpowers` | 1–2 | vecchio | — |
| `code-review` (cmd) | 1 | recente | — |
| `mattpocock-skills:setup-matt-pocock-skills` | 1 | recente | (setup, non uso produttivo) |
| `claude-code-setup:claude-automation-recommender` | 2 | vecchio | — |
| `build-mcp-server` | 1 | vecchio | — |

**Conclusione empirica — NOTA: l'uso NON è un filtro di qualità.** Le skill a uso nullo (`agent-skills`, `mattpocock`) sono state **installate di recente** (decisione utente, Checkpoint 1): uso=0 riflette la recency, non il valore. Vanno valutate sul merito, a pari condizioni con le incumbent. Le statistiche restano utili solo come **foto del workflow oggi consolidato**:
- ✅ **Superpowers è il workflow oggi consolidato** (brainstorming/writing-plans/subagent-driven-dev/finishing-branch = top 4 per uso). È l'incumbent da confrontare, non un vincolo.
- ℹ️ `agent-skills` (32 item) e `mattpocock-skills` (22): installate di recente, uso nullo atteso → **analizzate sul merito, nessuna esclusione**.
- ⚠️ Code review Superpowers a basso uso (1× ciascuna); la review avviene probabilmente via l'agente `code-reviewer` (non tracciato in `skillUsage`) o inline.

---

## 5. Plugin disabilitati nel cache (rumore su disco)

Occupano disco, **non** contesto: `firecrawl` (12 skill), `sentry` (13), `huggingface-skills` (~25), `chrome-devtools-mcp` (6 + ~18 skill vendored in `node_modules/chrome-devtools-frontend/.agents/` — **non sono skill Claude**), `figma`, `playwright`, `frontend-design`, `ralph-loop`, altri. Rumore anche da versioni multiple in cache (es. `superpowers` 6.1.1 + 6.2.0; `mcp-server-dev`/`skill-creator` con 5 hash versione ciascuno).

---

## 6. Mappa costi token (always-on vs on-demand)

- **Always-on (ogni sessione/turno):**
  1. Registro descrizioni di **~60 skill** + 4 agent user + ~10 agent plugin + ~15 comandi. Stima grezza: diverse migliaia di token solo di descrizioni.
  2. `using-superpowers` **forza-iniettato** EXTREMELY_IMPORTANT a session start (~62 righe + framing che impone skill-check ogni turno) → costo comportamentale + token.
  3. `ponytail` + `explanatory` iniettati a OGNI risposta (ladder + insight).
  4. `rules/*.md` (~60 righe) + (CLAUDE.md vuoto).
- **On-demand (all'invocazione):** corpi grandi → `writing-skills` 679, `subagent-driven-development` 503, `skill-creator` 485, `security-and-hardening` 467, `test-driven-development` 320/398.
- **Moltiplicatore subagent:** `superpowers:dispatching-parallel-agents` / `subagent-driven-development` e gli agent `feature-dev:*` / `agent-skills:*` spawnano subagent che **ri-raccoglieno contesto da zero** → costo ×N.

**Hotspot di costo identificati:** (a) registro agent-skills inusato; (b) forza-iniezione using-superpowers; (c) sovrapposizione review (più skill + agent per la stessa fase 8).

---

## 7. Flag e divergenze (flag, non risolte)

1. **Graphify — RISOLTO (decisione utente, Checkpoint 1):** l'utente conferma di aver **rimosso Graphify intenzionalmente**. Escluso dall'audit. Conseguenza: la navigazione/comprensione del codebase (fase 10) resta un **bisogno scoperto**, da coprire con alternative già presenti (`mattpocock:wayfinder`, `agent-skills:context-engineering`) o con una scelta nuova (es. `serena`/`greptile`, oggi disabilitati nei marketplace). Storico: 7 usi fino a ~2 mesi fa (`.claude.json:1968`).
2. **mattpocock 22 dichiarate vs 9 attive:** `plugin.json` elenca 22 skill; solo 9 nel registro di sessione. Da verificare (frontmatter / categoria non surfaced).
3. **`INTAKE_PATH` non valorizzato:** `documentation-lifecycle-rules.md:11` referencia uno slot `INTAKE_PATH` per l'escalation intake, "unfilled until O7 closes" → la regola di flagGING attualmente non ha una destinazione scritta.
4. **Code review frammentata:** fase 8 coperta da ≥5 entità (agente `code-reviewer`, `superpowers:requesting/receiving-code-review`, `mattpocock:code-review`, `code-review` cmd, `agent-skills:review`/`code-review-and-quality`, `feature-dev:code-reviewer`, `code-simplifier`). Uso effettivo basso → verosimilmente l'agente user-level prevale ma non è tracciato.
5. **`agent-skills` + `mattpocock` = ~30% del registro, ~0% d'uso.**

---

## 8. Shortlist proposta per la Fase 1 (skill rilevanti per ≥1 fase)

Candidate da leggere nel corpo (con confronto in Fase 2), organizzate per fase del workflow:

- **F1 Brainstorming:** `superpowers:brainstorming`, `agent-skills:interview-me`, `agent-skills:idea-refine`, `mattpocock:grilling`, agente `architect`.
- **F2 Spec:** `agent-skills:spec-driven-development`, `superpowers:brainstorming` (produce spec), `mattpocock:to-spec`*, agente `architect`.
- **F3 Spec review:** agente `spec-reviewer`, `agent-skills:doubt-driven-development`, `mattpocock:grilling`.
- **F4 Plan:** `superpowers:writing-plans`, `agent-skills:planning-and-task-breakdown`, agente `architect`.
- **F5 Plan review:** agente `implementation-plan-reviewer`, `agent-skills:doubt-driven-development`.
- **F6 Task/Backlog:** MCP `backlog`, `agent-skills:planning-and-task-breakdown`, `mattpocock:to-tickets`*.
- **F7 Coding:** `superpowers:executing-plans`, `superpowers:subagent-driven-development`, `superpowers:dispatching-parallel-agents`, `superpowers:test-driven-development`, `agent-skills:incremental-implementation`, `mattpocock:tdd`, `ponytail`.
- **F8 Code review:** agente `code-reviewer`, `superpowers:requesting-code-review`+`receiving-code-review`, `mattpocock:code-review`, `agent-skills:code-review-and-quality`, `code-review` cmd, `feature-dev:code-reviewer` (agent).
- **F9 Doc consolidation:** `consolidate-specs`, `consolidate-comments`, `agent-skills:documentation-and-adrs`, `claude-md-management:claude-md-improver`/`revise-claude-md`.
- **F10 Trasversali:** `superpowers:systematic-debugging` / `agent-skills:debugging-and-error-recovery` / `mattpocock:diagnosing-bugs` (debug); `superpowers:using-git-worktrees`+`finishing-a-development-branch` / `agent-skills:git-workflow-and-versioning` (git); `superpowers:verification-before-completion` (verifica); `agent-skills:context-engineering` (memoria); `mattpocock:wayfinder`* (navigazione); `agent-skills:security-and-hardening` + `security-guidance` (security).

*\* mattpocock: da confermare attivazione (§7.2).*

**Nessuna esclusione (decisione utente, Checkpoint 1):** tutte le skill abilitate — incluso l'intero cluster `agent-skills` non-SDLC (`ci-cd-and-automation`, `observability-and-instrumentation`, `browser-testing-with-devtools`, `frontend-ui-engineering`, `performance-optimization`, `shipping-and-launch`, `deprecation-and-migration`, `source-driven-development`), i meta-plugin (`skill-creator`, `mcp-server-dev`) e tutto `mattpocock-skills` — entrano nella Fase 1 e vengono confrontate sul merito nella Fase 2. Il verdetto finale (keep/disable) deriva dal confronto, non dalle statistiche d'uso.
