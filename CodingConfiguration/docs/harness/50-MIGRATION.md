# 50 — Piano di migrazione (Fase 5)

> Dallo stato attuale (v3 confermata ma non applicata) all'harness target (`40-TARGET-HARNESS.md`). **Tutti gli step sono reversibili.** Qui si propongono diff; l'utente li applica (o li fa applicare in sessione dedicata).
>
> Verdeti: **MANTIENI** · **MANTIENI CON MODIFICHE** · **DISABILITA** · **RIMUOVI** · **ABILITA**. Rischio: basso/medio/alto.

---

## 1. Tabella decisionale (ogni elemento dell'inventario)

### Agent user-level (`~/.claude/agents/`)
| Elemento | Verdetto | Motivo | Rischio |
|---|---|---|---|
| `architect` | **MANTIENI** | backbone F1/F2/F4 (design) | — |
| `spec-reviewer` | **MANTIENI** | F3 review spec (default) | — |
| `implementation-plan-reviewer` | **MANTIENI** | F5 review plan (default) | — |
| `code-reviewer` | **MANTIENI** | F8 review locale (default) | — |

### Skill user-level (`~/.claude/skills/`)
| Elemento | Verdetto | Motivo | Rischio |
|---|---|---|---|
| `consolidate-specs` / `consolidate-comments` | **MANTIENI CON MODIFICHE** | F9 (allineate alle documentation-lifecycle-rules); **richiedono graph floor** (serena) + slot non valorizzati (`INTAKE_PATH`, `TARGET_SET_SCRIPT`) per essere "controlled" | medio |
| `model-config-sync` | **MANTIENI** | utility user-level, neutra | basso |

### Superpowers (14)
| Skill | Verdetto | Motivo |
|---|---|---|
| `writing-plans` | **MANTIENI** | F4 (produce il piano per SDD) — critica |
| `subagent-driven-development` | **MANTIENI** | F7 motore di esecuzione |
| `executing-plans` | **MANTIENI** | F7 fallback (no subagent) |
| `using-git-worktrees` | **MANTIENI** | F7 prerequisito workspace |
| `finishing-a-development-branch` | **MANTIENI** | F10-Ship terminale SDD |
| `systematic-debugging` | **MANTIENI** | F10 debug (default) |
| `verification-before-completion` | **MANTIENI** | F10 verifica (Iron Law) |
| `dispatching-parallel-agents` | **MANTIENI** | F10 debug (problemi indipendenti) |
| `brainstorming` | **MANTIENI (opzionale)** | non in v3 (F1 usa interview-me), ma utile come hard-gate pre-impl; keep on-demand |
| `test-driven-development` | **MANTIENI** | F7 TDD (encodeato nel plan ma utile come disciplina) |
| `requesting-code-review` / `receiving-code-review` | **MANTIENI** | meccanismo dispatch/ricezione (interno a SDD / opzionale F8) |
| `using-superpowers` | **MANTIENI CON MODIFICHE** | sempre-on (skill loader); il framing EXTREMELY_IMPORTANT è costo always-on — non disabilitabile facilmente, **valutare** attenuazione |
| `writing-skills` | **MANTIENI (on-demand)** | meta; on-demand, raro |

### agent-skills / addy (24 skill + 8 cmd + 4 agent)
| Cluster | Verdetto | Motivo |
|---|---|---|
| `interview-me`, `idea-refine`, `spec-driven-development`, `planning-and-task-breakdown`, `code-review-and-quality`, `documentation-and-adrs`, `context-engineering`, `doubt-driven-development`, `security-and-hardening`, `code-simplification`, `api-and-interface-design`, `source-driven-development`, `test-driven-development` | **MANTIENI** | in v3 (F1-F10) |
| Ortogonali on-demand: `ci-cd-and-automation`, `observability-and-instrumentation`, `frontend-ui-engineering`, `performance-optimization`, `shipping-and-launch`, `deprecation-and-migration`, `browser-testing-with-devtools` | **MANTIENI (on-demand)** | dominio; si attivano a bisogno |
| cmd `/spec /plan /build /test /review /ship /code-simplify /webperf` | **MANTIENI** | entry-point; `using-agent-skills` come router |
| agent `code-reviewer/security-auditor/test-engineer/web-performance-auditor` | **MANTIENI** | subagent specializzati (F8/F10) |

### mattpocock (22 dichiarate)
| Skill | Verdetto | Motivo |
|---|---|---|
| `grilling` (e `grill-me`/`grill-with-docs`), `wayfinder`, `diagnosing-bugs`, `prototype`, `research`, `codebase-design`, `domain-modeling`, `handoff` | **MANTIENI** | in v3 (F3/F4/F10) |
| `to-spec`, `to-tickets`, `resolving-merge-conflicts`, `ask-matt`, `improve-codebase-architecture`, `triage`, `teach`, `writing-great-skills`, `setup-matt-pocock-skills` | **MANTIENI (on-demand)** | utili; `disable-model-invocation` (esplicite) |
| `*` deprecate (`design-an-interface`, `qa`, `request-refactor-plan`, `ubiquitous-language`) | **RIMUOVI** (o ignora) | deprecate nel plugin |

### ponytail (6)
| Skill | Verdetto | Motivo |
|---|---|---|
| `ponytail` | **MANTIENI CON MODIFICHE** | guardrail F7 sempre-on; **default → `lite`** (off salvo `/ponytail full`) per ridurre costo every-response |
| `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help` | **MANTIENI (on-demand)** | review/debt/display one-shot |

### Altri plugin
| Plugin | Verdetto | Motivo | Rischio |
|---|---|---|---|
| `claude-md-management` (`claude-md-improver`, `revise-claude-md`) | **MANTIENI** | F9 (CLAUDE.md vuoto → alto valore) | — |
| `claude-code-setup` (`claude-automation-recommender`) | **MANTIENI (meta)** | setup on-demand | — |
| `code-review` (`code-review` cmd) | **MANTIENI** | F8 cross-session PR GitHub | — |
| `security-guidance` | **MANTIENI** | F10 hooks/policy | — |
| `explanatory-output-style` | **MANTIENI** | output style (always-on; se token-critico, disabilitabile) | basso |
| `skill-creator`, `mcp-server-dev` | **MANTIENI CON MODIFICHE** | meta; **disabilitare se non si costruiscono skill/MCP regolarmente** | nullo |
| `feature-dev` | **DISABILITA** | non in v3; chain autonoma duplica architect+SDD+code-reviewer | basso |
| `code-simplifier` | **DISABILITA** | agente duplicato di `agent-skills:code-simplification` | basso |
| `serena` (marketplace, disabilitato) | **ABILITA** | F10 navigazione + floor per consolidate-* | medio |
| Plugin disabilitati nel cache (`firecrawl`, `sentry`, `huggingface-skills`, `chrome-devtools-mcp`, `figma`, `playwright`, `frontend-design`, `ralph-loop`, `agent-sdk-dev`, `plugin-dev`, `playground`, `github`, `pr-review-toolkit`) | **MANTIENI disabilitati** (o **RIMUOVI** cache per libero disco) | non consumano contesto; solo disco | nullo |

### MCP
| Server | Verdetto | Motivo |
|---|---|---|
| `backlog` (Backlog MD) | **MANTIENI** | F6 system of record task |
| `serena` (da abilitare) | **ABILITA** | F10 nav + floor consolidate |
| `ide`, `web_reader`/`4_5v_mcp` | **MANTIENI** | iniettati da IDE, utili |

---

## 2. Sequenza di migrazione (step atomici, reversibili, ordinati per valore/rischio)

Prerequisito: **backup** di `~/.claude/settings.json`, `~/.claude.json`, `~/.claude/CLAUDE.md` (vuoto), `~/.claude/agents/`, `~/.claude/skills/` (o git-track nel repo `D:\ClaudeConfiguration`).

| # | Step | Valore | Rischio | Criterio di verifica | Rollback |
|---|---|---|---|---|---|
| 1 | **Popola `~/.claude/CLAUDE.md`** con il blocco `40-TARGET-HARNESS.md §4` | alto | basso | nuova sessione: il modello cita la catena primaria e i gate senza prompt | ripristina CLAUDE.md vuoto dal backup |
| 2 | **Disabilita `feature-dev` + `code-simplifier`** in `settings.json:enabledPlugins` → `false` | medio (token) | basso | `/context` mostra meno skill nell'elenco; `feature-dev:*`/`code-simplifier:*` non compare negli agent type | riabilita a `true` |
| 3 | **Abilita `serena`** (come plugin `serena@claude-plugins-official:true`, oppure MCP in `.claude.json:mcpServers.serena`) | alto (nav+consolidate) | medio | nuova sessione: tool serena disponibili; `consolidate-specs` vede un graph floor | disabilita/rimuovi serena |
| 4 | **`ponytail` default → `lite`** (SessionStart hook param, o CLAUDE.md "default lite salvo /ponytail full") | medio (token) | basso | `/ponytail` riporta `lite`; ladder non enforced ogni risposta | `/ponytail full` |
| 5 | **Crea i 5 slash command** (`/backlog-sync`, `/spec-review`, `/dev`, `/bugfix`, `/consolidate`) in `~/.claude/commands/` | medio | basso | ogni command risponde e compie la transizione attesa | rimuovi i file `.md` |
| 6 | **Wire del bridge Plan↔Backlog MD** (regola CLAUDE.md §4 + `/backlog-sync`): su un plan pilota, mappa `Task N` → task Backlog MD con cross-ref bidirezionali | alto (chiude gap F6) | basso | un task Backlog MD ha `Plan-Task: N`; il plan ha `Backlog: <id>`; SDD trova i task coerenti | rimuovi la regola + non usare /backlog-sync |
| 7 | **Risolvi il floor di `consolidate-*`**: decidi se serena soddisfa `TARGET_SET_SCRIPT`; se sì, valorizza gli slot (`INTAKE_PATH`, `RECORD_PATH`, ecc.); se no, usa consolidate-* come **checklist manuale** e reliance su `documentation-and-adrs`+`claude-md-improver` | medio | medio | una pass `consolidate-specs` su una spec dirty completa con record + gate (o, in degrado, flagga esplicitamente "no graph floor") | disabilita consolidate-*, fallback a documentation-and-adrs |
| 8 | **(Opzionale) disabilita meta** (`skill-creator`, `mcp-server-dev`, `claude-code-setup`) se non si costruiscono skill/MCP | basso | nullo | non compaiono nel registro | riabilita |
| 9 | **(Opzionale) pulizia cache** dei plugin disabilitati per libero disco | basso | nullo | `du` della cache ridotto | re-install via marketplace |
| 10 | **Git-track della config** nel repo `D:\ClaudeConfiguration` (la "curation" esiste già) | alto (ripristinabilità) | basso | `git status` mostra settings/CLAUDE.md/agents versionati | — |

**Ordine consigliato:** 1 → 2 → 4 → 5 → 6 → 3 → 7 → 10 (→ 8/9 opzionali). I primi a basso rischio/alto valore per primi; serena(3) e consolidate(7) dopo aver dato direzione (1) e ridotto rumore (2).

---

## 3. Task Backlog MD (migrazione)

> ⚠ **Formato Backlog MD da confermare.** Non ho ispezionato il formato esposto dal MCP `backlog` (resource `backlog` non letta in questa sessione). Sotto un **formato proposto** derivato dalla convenzione `to-tickets` + Backlog MD; **conferma o correggi** prima della creazione. Ogni task ha cross-ref a `40-TARGET-HARNESS.md` / `50-MIGRATION.md`.

```markdown
# MIGR-01 — Popolare ~/.claude/CLAUDE.md con le regole di precedenza
**What to build:** il blocco "Workflow harness — regole di precedenza" (40-TARGET-HARNESS.md §4) incollato in ~/.claude/CLAUDE.md (oggi vuoto).
**Blocked by:** None
**Spec:** docs/harness/40-TARGET-HARNESS.md §4
**Plan:** 50-MIGRATION.md step 1
**Acceptance:**
- [ ] ~/.claude/CLAUDE.md non vuoto, contiene il blocco §4
- [ ] nuova sessione: il modello rispetta chain primaria + gate senza prompt esplicito
- [ ] backup del vecchio CLAUDE.md preservato

# MIGR-02 — Disabilitare feature-dev e code-simplifier
**What to build:** enabledPlugins.feature-dev e .code-simplifier → false in settings.json.
**Blocked by:** None
**Spec:** 40-TARGET-HARNESS.md §6.3 · Plan: 50-MIGRATION.md step 2
**Acceptance:**
- [ ] settings.json aggiornato
- [ ] agent type feature-dev:*/code-simplifier:* non più disponibili
- [ ] nessuna regressione nei workflow v3 (entrambi non usati)

# MIGR-03 — Abilitare serena (navigazione + floor consolidate)
**What to build:** serena come plugin abilitato o MCP server; verificare symbol-graph operativo.
**Blocked by:** None (ma dopo MIGR-01)
**Spec:** 40 §6.1/6.2 · Plan: 50 step 3
**Acceptance:**
- [ ] tool serena disponibili in sessione
- [ ] architect/SDD riescono a navigare il codebase via serena
- [ ] consolidate-specs vede un floor (o flagga degrado esplicito)

# MIGR-04 — ponytail default lite
**What to build:** SessionStart hook ponytail avvia in `lite`; CLAUDE.md documento che `/ponytail full` opt-in.
**Blocked by:** None
**Spec:** 40 §7 (intervento 2) · Plan: 50 step 4
**Acceptance:**
- [ ] /ponytail riporta lite di default
- [ ] guardrail YAGNI preservato via regola CLAUDE.md dove critico (trust boundary)

# MIGR-05 — Creare slash command (/backlog-sync, /spec-review, /dev, /bugfix, /consolidate)
**What to build:** 5 file .md in ~/.claude/commands/ (corpi in 40 §5).
**Blocked by:** MIGR-01
**Spec:** 40 §5 · Plan: 50 step 5
**Acceptance:**
- [ ] ogni command risponde e compie la transizione
- [ ] /bugfix attiva SOLO la catena corta (niente SDD/spec-driven)

# MIGR-06 — Wire bridge Plan↔Backlog MD
**What to build:** regola CLAUDE.md + /backlog-sync che mappa Task N (plan) ↔ task Backlog MD con cross-ref bidirezionali.
**Blocked by:** MIGR-01, MIGR-05
**Spec:** 40 §3 (contratti) · Plan: 50 step 6
**Acceptance:**
- [ ] su plan pilota, ogni Task N ha corrispettivo Backlog MD con Plan-Task:N
- [ ] SDD esegue task coerenti con il plan

# MIGR-07 — Risolvere floor consolidate-specs/comments
**What to build:** decidere serena come TARGET_SET_SCRIPT (valorizzare slot) o usare consolidate-* come checklist manuale.
**Blocked by:** MIGR-03
**Spec:** 40 §1 F9 · Plan: 50 step 7
**Acceptance:**
- [ ] una pass consolidate-specs completa con record+gate, oppure degrado flaggato esplicitamente
- [ ] INTAKE_PATH valorizzato (chiude anche il riferimento pendente nelle documentation-lifecycle-rules.md:11)
```

---

## 4. Rollback (come tornare allo stato attuale)

- **Config plugin:** `settings.json:enabledPlugins` → ripristina i valori pre-migrazione dal backup (feature-dev/code-simplifier a `true`, serena assente).
- **CLAUDE.md:** svuota o ripristina (era vuoto).
- **Commands:** rimuovi i 5 `.md` da `~/.claude/commands/`.
- **ponytail:** `/ponytail full`.
- **serena MCP:** rimuovi `mcpServers.serena`.
- **consolidate-*:** disabilita (fallback a `documentation-and-adrs` + `claude-md-improver`, sempre operativi).
- **Git:** se la config è versionata nel repo `D:\ClaudeConfiguration` (step 10), `git revert`/`git checkout` dei commit di migrazione.

**Stato "sicuro" minimo garantito in ogni momento:** anche se serena/consolidate-* non funzionano, il workflow principale (F1-F8) è operativo (Chain B-pensare + A-eseguire + agent backbone + Backlog MD), perché non dipende dal graph floor.
