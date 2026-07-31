# 20 — Confronto per fase e selezione del vincitore (Fase 2)

> Per ognuna delle 10 fasi del workflow: tabella comparativa con rubrica pesata (1-5 per criterio + **totale ponderato /500**), verdetto (1 vincitore + supporti + scartate), trade-off.
>
> **Rubrica (pesi normali, somma 100):** Copertura&generalità 15 · Efficacia sul workflow 20 · Qualità output 20 · Criticità&obiettività 15 · Efficienza token 15 · Composabilità 10 · Robustezza trigger 5.
> **Fasi con Criticità ×2 (1, 3, 5, 8):** Criticità 30, gli altri riscalati ×0.8235 → Cop 12.4 · Eff 16.5 · Qual 16.5 · Crit 30 · Tok 12.4 · Comp 8.2 · Trig 4.1.
>
> **Tema portante (deciso dall'evidence):** esistono **3 catene concorrenti** che non condividono artefatti/naming:
> - **Chain A — Superpowers (incumbente, usata 41/48/45/30×):** `brainstorming → writing-plans → subagent-driven-development → finishing-a-development-branch`; artefatti `docs/superpowers/{specs,plans}/`; review via agent user-level + `requesting-code-review`; task in **Backlog MD**.
> - **Chain B — agent-skills:** `spec-driven-development → planning-and-task-breakdown → incremental-implementation/test-driven-development`; artefatti `SPEC.md` + `tasks/{plan,todo}.md`.
> - **Chain C — mattpocock:** `to-spec → to-tickets → implement → code-review`; pubblica su **issue tracker** (allineabile a Backlog MD); quasi tutto `disable-model-invocation`.
>
> La decisione a più alto impatto è **scegliere Chain A come primaria** (incumbente + composizione end-to-end + agent backbone) e usare B/C come **fonti di disciplina** da innestare, non come catene alternative. Ogni verdetto sotto riflette questo.

---

## Fase 1 — Brainstorming / esplorazione del problema  *(Criticità ×2)*

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `superpowers:brainstorming` | 5 | 5 | 4 | 3 | 3 | 5 | 5 | **399** |
| `agent-skills:interview-me` | 3 | 3 | 5 | 5 | 3 | 3 | 4 | **397** |
| `architect` (agent) | 3 | 3 | 5 | 2 | 5 | 4 | 4 | 340 |
| `agent-skills:idea-refine` | 3 | 2 | 4 | 4 | 3 | 3 | 4 | 334 |
| `mattpocock:grilling` | 2 | 2 | 3 | 4 | 5 | 2 | 3 | 318 |

**Verdetto — quasi parità:** **vincitore `superpowers:brainstorming`** (399) su `interview-me` (397) per una manciata di punti. La scelta si decide sul **criterio "pipeline completeness"**: brainstorming copre l'intera fase 1 (domande + 2-3 approcci + design) **e** compone nella catena (`→ writing-plans`); interview-me è più puro nell'interrogazione (anti-sincotismo, want-vs-should, 95% confidence) ma si ferma al restate d'intento.
- **Supporto:** `agent-skills:interview-me` (per ask真正mente underspecified — pre-spec intent extraction), `mattpocock:grilling` (stress-test leggero), `architect` (design pre-spec).
- **Scartate:** `idea-refine` (ideazione divergente, utile ma non centra "chiedo che mi vengano poste domande"; keep come supporto opzionale per brainstorming creativo).
- **Trade-off:** scegliendo brainstorming perdi il **rigore anti-sincotismo** di interview-me → mitigazione: regola in CLAUDE.md "usa interview-me per ask vaghe; brainstorming per design".

## Fase 2 — Redazione della specifica

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `superpowers:brainstorming` (produce spec) | 4 | 5 | 4 | 3 | 3 | 5 | 5 | **405** |
| `agent-skills:spec-driven-development` | 5 | 3 | 5 | 4 | 3 | 3 | 4 | 390 |
| `architect` (agent) | 3 | 3 | 5 | 3 | 5 | 4 | 4 | 385 |
| `mattpocock:to-spec` | 3 | 2 | 4 | 2 | 4 | 3 | 2 | 295 |

**Verdetto:** **vincitore `superpowers:brainstorming`** (produce il design doc in `docs/superpowers/specs/`, compone con writing-plans). `spec-driven-development` ha il **template spec migliore** (6 aree + assumption-surfacing) ma **forca Chain B** (SPEC.md/tasks/) → frammenta gli artefatti.
- **Supporto:** rubric **6-aree + assumption-surfacing** di `spec-driven-development` da innestare nel design doc di brainstorming; `mattpocock:to-spec` se si pubblica la spec su Backlog MD (sintesi, no interview); `architect` per il design pre-spec.
- **Scartate:** nessuna (tutte utili come fonte); `spec-driven-development` come catena autonoma = **no** (conflitto artefatti).
- **Trade-off:** il design doc di brainstorming ha template più lasco di spec-driven-development → mitigazione: CLAUDE.md impone le 6 sezioni.

## Fase 3 — Review della specifica  *(Criticità ×2)*

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `spec-reviewer` (agent) | 4 | 5 | 4 | 4 | 5 | 5 | 4 | **438** |
| `agent-skills:doubt-driven-development` | 4 | 3 | 5 | 5 | 2 | 3 | 3 | 393 |
| `mattpocock:grilling` | 2 | 2 | 3 | 4 | 5 | 2 | 3 | 318 |

**Verdetto:** **vincitore `spec-reviewer` (agent)** — purpose-built, read-only, model fable, costo bassissimo (16 righe, contesto isolato), compone con la **backbone di review** (architect → spec-reviewer → implementation-plan-reviewer → code-reviewer).
- **Supporto:** `doubt-driven-development` per **spec ad alta stake** (adversarial fresh-context + cross-model Gemini/Codex); `grilling` per review interattiva.
- **Scartate:** nessuna.
- **Trade-off:** spec-reviewer è meno adversarial di doubt-driven → per security/critical spec usare doubt-driven in aggiunta.

## Fase 4 — Implementation plan

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `superpowers:writing-plans` | 4 | 5 | 5 | 3 | 3 | 5 | 5 | **425** |
| `architect` (agent) | 3 | 3 | 5 | 3 | 5 | 4 | 4 | 385 |
| `agent-skills:planning-and-task-breakdown` | 5 | 3 | 5 | 3 | 3 | 3 | 4 | 375 |
| `mattpocock:wayfinder` | 3 | 2 | 4 | 3 | 3 | 2 | 2 | 280 |

**Verdetto:** **vincitore `superpowers:writing-plans`** (incumbente, 48 usure; no-placeholder; self-review; hand-off pulito a SDD).
- **Supporto:** **dependency-graph + vertical-slicing + task-sizing (XS-XL)** di `planning-and-task-breakdown` (da innestare); `architect` (design pre-piano); `wayfinder` (scope >1 sessione, mappa su tracker).
- **Scartate:** `planning-and-task-breakdown` come catena (tasks/) = no (conflitto); keep come rubric source.
- **Trade-off:** writing-plans è **TDD-biased** e meno esplicito su dep-graph/sizing → mitigazione: innestare la rubric di planning-and-task-breakdown.

## Fase 5 — Review dell'implementation plan  *(Criticità ×2)*

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `implementation-plan-reviewer` (agent) | 4 | 5 | 4 | 4 | 5 | 5 | 4 | **438** |
| `agent-skills:doubt-driven-development` | 4 | 3 | 5 | 5 | 2 | 3 | 3 | 393 |

**Verdetto:** **vincitore `implementation-plan-reviewer` (agent)** (purpose-built, spot-check contro il codebase, basso costo, compone).
- **Supporto:** `doubt-driven-development` (alta stake / cross-model).
- **Trade-off:** meno adversarial di doubt-driven.

## Fase 6 — Decomposizione in task atomici (Backlog MD)

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| MCP `backlog` (Backlog MD) | 5 | 5 | 4 | 2 | 4 | 3 | 3 | **390** |
| `agent-skills:planning-and-task-breakdown` | 5 | 3 | 5 | 3 | 3 | 3 | 4 | 365 |
| `mattpocock:to-tickets` | 4 | 3 | 4 | 3 | 4 | 3 | 2 | 345 |
| `superpowers:writing-plans` (tasks in plan) | 3 | 4 | 4 | 3 | 3 | 3 | 5 | 330 |

**Verdetto:** **vincitore MCP `backlog` (Backlog MD)** come **system of record** — è lo strumento che l'utente usa davvero per i task. Le skill concorrenti producono task in **altri formati** (`tasks/todo.md`, `.scratch/issues/`, nel plan doc): **nessuna scrive nativamente in Backlog MD → gap di integrazione**.
- **Supporto (metodi di decomposizione da alimentare IN Backlog MD):** logica **vertical-slicing + dep-graph + sizing** di `planning-and-task-breakdown`; concetto **tracer-bullet + blocking edges** di `mattpocock:to-tickets` (il più vicino al modello task-di-Backlog-MD).
- **Scartate:** nessuna come sistema (tutte utili come metodo).
- **Trade-off/Azione:** serve un **contratto/adapter** (o regola CLAUDE.md) che imponga cross-reference spec↔plan↔task-Backlog-MD↔commit. È una delle 3 modifiche a più alto impatto (vedi `40-TARGET-HARNESS.md`).

## Fase 7 — Coding / esecuzione dei task

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `superpowers:subagent-driven-development` | 5 | 5 | 5 | 3 | 2 | 5 | 4 | **420** |
| `ponytail:ponytail` (guardrail always-on) | 4 | 5 | 4 | 4 | 3 | 4 | 5 | 410 |
| `superpowers:test-driven-development` | 4 | 4 | 4 | 3 | 3 | 4 | 5 | 375 |
| `agent-skills:test-driven-development` | 5 | 3 | 5 | 3 | 2 | 3 | 5 | 365 |
| `superpowers:executing-plans` | 3 | 4 | 3 | 3 | 4 | 4 | 4 | 365 |
| `agent-skills:incremental-implementation` | 4 | 3 | 4 | 3 | 3 | 3 | 4 | 345 |
| `superpowers:dispatching-parallel-agents` | 3 | 3 | 4 | 2 | 3 | 3 | 4 | 310 |

**Verdetto:** **vincitore `superpowers:subagent-driven-development`** (incumbente, 45 usure; ledger anti-compaction; model-selection; fix-loop a 5 round). `ponytail` è il **guardrail trasversale always-on** (YAGNI/shortest-diff) — non competitore, complemento.
- **Supporto:** `executing-plans` (task piccoli / no subagent), `dispatching-parallel-agents` (fallimenti multipli indipendenti), `incremental-implementation` (slice discipline), `ponytail` (lazy guardrail), **TDD: primario `superpowers:test-driven-development`** (compone con la chain), `agent-skills:test-driven-development` come riferimento pragmatico (Prove-It, stack-aware).
- **Scartate:** nessuna.
- **Trade-off:** SDD è **token-heavy** (N subagent × contesto) → per task piccoli usare executing-plans/inline; regola CLAUDE.md sulla soglia.

## Fase 8 — Code review (single-step e multi-step / cross-session)  *(Criticità ×2)*

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `code-reviewer` (agent, user) | 4 | 5 | 4 | 4 | 5 | 5 | 4 | **438** |
| `agent-skills:code-review-and-quality` | 5 | 3 | 5 | 5 | 2 | 3 | 4 | 410 |
| `mattpocock:code-review` | 4 | 3 | 4 | 4 | 3 | 3 | 3 | 359 |
| `superpowers:requesting-code-review` | 3 | 4 | 4 | 3 | 3 | 4 | 4 | 350 |
| `code-review:code-review` (cmd, GitHub PR) | 3 | 3 | 4 | 3 | 1 | 2 | 3 | 284 |

**Verdetto:** **vincitore `code-reviewer` (agent user-level)** per review **single-step su diff locale** (conciso, low-cost, compone con la backbone). La fase 8 ha **due modalità** con vincitori diversi:
- **single-step locale** → `code-reviewer` agent (default) / `code-review-and-quality` (deep 5-assi pre-merge).
- **multi-step / cross-session PR GitHub** → `code-review:code-review` cmd (pipeline Haiku+Sonnet che posta commenti; molto costosa).
- **Supporto:** `mattpocock:code-review` (split Standards+Spec), `receiving-code-review` (disciplina ricezione), `requesting-code-review` (meccanismo dispatch dentro SDD).
- **Scartate:** `feature-dev:code-reviewer`, `agent-skills:code-reviewer` (agent duplicati del code-reviewer user-level → ridondanza, vedi `30-CONFLICTS.md`).
- **Trade-off:** code-reviewer agent è meno approfondito di code-review-and-quality → pre-merge usare code-review-and-quality.

## Fase 9 — Consolidamento della documentazione

| Skill | Cop | Eff | Qual | Crit | Tok | Comp | Trig | **Totale** |
|---|---|---|---|---|---|---|---|---|
| `claude-md-management:claude-md-improver` | 4 | 5 | 4 | 4 | 3 | 4 | 4 | **405** |
| `consolidate-specs`/`consolidate-comments` (user) | 5 | 3 | 5 | 5 | 1 | 4 | 3 | 380 |
| `agent-skills:documentation-and-adrs` | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 370 |

**Verdetto — condizionale:** **vincitore `consolidate-specs`/`consolidate-comments` (user)** per lo **scopo specifico** (riallineare spec/commenti al codice, allineate alle `documentation-lifecycle-rules.md`) — **MA sono attualmente non-shippable as controlled**: dipendono da un **knowledge-graph floor (Graphify, rimosso)** e da slot non valorizzati (`INTAKE_PATH`, `TARGET_SET_SCRIPT`). Senza graph degradano a self-report.
- **Vincitore operativo (works-now):** `claude-md-improver` (CLAUDE.md user-level è **vuoto** → alto valore immediato) + `documentation-and-adrs` (ADR/docs).
- **Azione gating:** decidere se ripristinare un graph floor (serena/greptile disabilitati nei marketplace, o un MCP leggero) per sbloccare consolidate-*, oppure accettare la modalità degradata e usarle come **checklist manuale**.
- **Trade-off:** consolidate-* sono le più rigorose (flag-don't-rewrite, escalate) ma inutilizzabili al 100% oggi.

## Fase 10 — Trasversali

Sotto-fase per sotto-fase (vincitore + supporti):

| Bisogno trasversale | Vincitore | Supporto |
|---|---|---|
| **Debug** | `superpowers:systematic-debugging` (incumbente, 14×, auto-trigger) | `mattpocock:diagnosing-bugs` (disciplina feedback-loop per bug hard), `agent-skills:debugging-and-error-recovery` (Stop-the-Line/checklist) |
| **Git / isolamento** | `superpowers:using-git-worktrees` + `finishing-a-development-branch` (compongono, incumbent) | `agent-skills:git-workflow-and-versioning` (commit/semver/changelog), `mattpocock:resolving-merge-conflicts` |
| **Verifica** | `superpowers:verification-before-completion` (Iron Law, pre-claim) | — |
| **Contesto/memoria** | `agent-skills:context-engineering` (gerarchia, anti-flooding) | `mattpocock:handoff` (cross-session) |
| **Security** | `agent-skills:security-and-hardening` (STRIDE, OWASP) + `security-guidance` (hooks) | `security-auditor` (agent), `security-review` (cmd) |
| **Semplificazione** | `agent-skills:code-simplification` (Chesterton's fence) | `code-simplifier` (agent), `ponytail:ponytail-review` |
| **Design moduli/API** | `agent-skills:api-and-interface-design` (Hyrum, contract-first) | `mattpocock:codebase-design` (deep modules), `mattpocock:domain-modeling` (glossary) |
| **Navigazione codebase** | ⚠ **GAP** (Graphify rimosso) | `mattpocock:wayfinder` (è planning, non nav), `context-engineering` (parziale). **Azione:** colmare (serena/greptile) o accettare |
| **Prototipo/research** | `mattpocock:prototype` / `mattpocock:research` (background agent) | — |
| **Ship** | `agent-skills:shipping-and-launch` (checklist, rollout) | `superpowers:finishing-a-development-branch` (integrazione) |
| **Frontend / perf / CI / observability** | `frontend-ui-engineering` / `performance-optimization` / `ci-cd-and-automation` / `observability-and-instrumentation` (tutti agent-skills, ortogonali) | si attivano a bisogno |

---

## Riepilogo vincitori per fase (→ CHECKPOINT 2)

| Fase | Vincitore | Supporto chiave |
|---|---|---|
| 1 Brainstorming | `superpowers:brainstorming` | `interview-me` (ask vaghe), `grilling`, `architect` |
| 2 Spec | `superpowers:brainstorming` (design doc) | rubric 6-aree di `spec-driven-development`, `to-spec` (→Backlog MD) |
| 3 Spec review | `spec-reviewer` (agent) | `doubt-driven-development` (alta stake) |
| 4 Plan | `superpowers:writing-plans` | dep-graph/sizing di `planning-and-task-breakdown`, `architect`, `wayfinder` |
| 5 Plan review | `implementation-plan-reviewer` (agent) | `doubt-driven-development` |
| 6 Task (Backlog MD) | MCP `backlog` (SoR) | metodi di `planning-and-task-breakdown` + `to-tickets` → adapter Backlog MD |
| 7 Coding | `superpowers:subagent-driven-development` | `ponytail` (guardrail), `executing-plans`, TDD, `dispatching-parallel-agents` |
| 8 Code review | `code-reviewer` (agent) locale; `code-review:code-review` (PR GitHub) | `code-review-and-quality` (deep), `mattpocock:code-review`, `receiving-code-review` |
| 9 Doc consolidation | `consolidate-specs/comments` (condizionale al graph) | `claude-md-improver` + `documentation-and-adrs` (works-now) |
| 10 Trasversali | systematic-debugging / worktrees+finishing / verification / context-engineering / security-and-hardening | vedi tabella |

**3 decisioni a più alto impatto (anticipo):**
1. **Adottare Chain A (Superpowers) come primaria**, innestando le rubric di Chain B/C — elimina la frammentazione artefatti.
2. **Chiudere il gap Backlog MD** (F6): contratto/CLAUDE.md che impone cross-reference spec↔plan↔task↔commit dentro Backlog MD.
3. **Risolvere il blocco consolidate-** (F9): decidere graph floor (serena/greptile) o accettare degrado + **valorizzare CLAUDE.md user-level (vuoto)** con claude-md-improver.
