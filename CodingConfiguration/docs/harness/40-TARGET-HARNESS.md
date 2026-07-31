# 40 — Harness target (Fase 4)

> Harness target derivato dalla composizione **v3 confermata dall'utente** (Checkpoints 1-2): best-of-breed **Chain B per pensare (F1-6) + Chain A per eseguire (F7) + Chain C per strumenti puntuali (F10)**, con i **4 agent user-level** come backbone di review, **Backlog MD** come system of record dei task, **serena** come floor di navigazione.
>
> **Vincolo rispettato:** qui si **propongono diff** a `CLAUDE.md`/`settings.json`/plugin — non si applicano in questa sessione.

---

## 1. Pipeline — workflow principale (9 fasi)

Legenda: `→` artefatto in uscita · `⊘` gate di approvazione (bloccante) · `[path]` convenzione file.

```
F1 interview-me/idea-refine + architect
   → docs/intent/<topic>.md  (opz.)  +  design (architect)
   ⊘ intent confermato (explicit yes di interview-me)
        │
F2 spec-driven-development + architect
   → SPEC.md  (root)  [sezione: Obiettivo/Commands/Structure/Style/Testing/Boundaries/Success/Assumptions]
   ⊘ spec scritta + assunzioni surfaced
        │
F3 grilling (stress-test interattivo) + spec-reviewer (agent)   ← doubt-driven-development se alta stake
   → review report (ranked, blocking-first)
   ⊘ SPEC approvata
        │
F4 writing-plans (+ rubric dep-graph/sizing di planning-and-task-breakdown) + architect (+ wayfinder se scope>1 sessione)
   → docs/plans/<YYYY-MM-DD>-<feature>.md   [header Global Constraints + Task N: Files/Interfaces/step checkbox TDD]
   ⊘ piano scritto + self-review no-placeholder
        │
F5 implementation-plan-reviewer (agent)   ← doubt-driven-development se alta stake
   → review report (blocking + fix concrete)
   ⊘ piano approvato
        │
F6 planning-and-task-breakdown (logica dep-graph/vertical-slicing/sizing) → backlog MCP (Backlog MD)
   → task atomici in Backlog MD, ognuno con cross-ref a SPEC § + Plan Task ID
   ⊘ task creati e ordinati per dipendenza
        │
F7 using-git-worktrees (workspace isolato) → subagent-driven-development (esegue docs/plans/<plan>.md)
   ·  implementer-subagent per task + task-reviewer + final reviewer (ledger in .superpowers/sdd/<plan>/progress.md)
   ·  executing-plans (fallback se niente subagent) · ponytail (guardrail always-on)
   → commit per task (TDD: failing test → impl → verify)
   ⊘ tutti i task completati, test green, final review pulita
        │
F8 code-reviewer (agent, default locale) / code-review-and-quality (deep pre-merge) / code-review:code-review (cmd, PR GitHub cross-session)
   → review report + (su PR) commento via gh
   ⊘ review passata (Critical/Important risolti)
        │
F9 documentation-and-adrs (ADR/inline) + consolidate-specs/comments (riallineamento, se graph floor) + claude-md-improver (CLAUDE.md)
   → ADR in docs/decisions/ · SPEC/commenti realignati · CLAUDE.md aggiornato
   ⊘ documentazione allineata al codice
        │
F10-Ship finishing-a-development-branch → merge / PR / keep
```

**Transizioni con gate bloccante esplicito:** F1→F2 (intent), F3 (spec approvata), F5 (piano approvato), F7 (test green + review pulita), F8 (review passata). Le altre sono prodotti intermedi non bloccanti ma raccomandati.

---

## 2. Pipeline — workflow semplificato (bug fixing / attività brevi)

Nessun artefatto persistente: il mini-piano **vive nel contesto della sessione**. Step concettuali identici, catena corta.

```
planning mode (read-only)
   → problema condiviso + mini-piano inline (TodoWrite, niente file)
        │
reproduce: systematic-debugging Fase 1-2  o  diagnosing-bugs (costruisci feedback loop red-capable)
        │
fix: TDD Prove-It (test di riproduzione che fallisce → fix → verde)   [superpowers:test-driven-development opz.]
        │
verify: verification-before-completion (evidence prima del claim)
        │
review: code-reviewer (agent, diff locale)
        │
commit (git-workflow-and-versioning: messaggio <fix: ...>)
```

**Skill che NON si attivano nel workflow semplificato (e perché):**
- `spec-driven-development`, `writing-plans`, `planning-and-task-breakdown` → nessun artefatto persistente richiesto; il mini-piano è in contesto.
- `subagent-driven-development` (e `dispatching-parallel-agents`) → overhead di subagent non giustificato per fix piccoli; si codifica inline.
- `wayfinder` → scope <1 sessione.
- `consolidate-specs/comments`, `documentation-and-adrs` → niente spec/commenti da consolidare; al max un commento ADR se la fix è una decisione non ovvia.
- `doubt-driven-development` → solo se il fix è ad alta stake (produzione/security/irreversibile).
- `requesting/receiving-code-review`, `code-review:code-review` (cmd) → la review locale via `code-reviewer` basta; il cmd PR solo se il fix va su PR.

**Soglia per passare dal semplificato al principale:** fix che tocca >1 modulo, o >~100 righe, o introduce branching non banale → torna al workflow principale (almeno writing-plans + SDD).

---

## 3. Contratti fra artefatti (cross-reference obbligatori)

Tracciabilità **SPEC ↔ PLAN ↔ TASK(Backlog MD) ↔ COMMIT ↔ REVIEW**. Ogni artefatto porta i riferimenti al precedente e al successivo.

| Artefatto | Path/naming | Campi obbligatori | Cross-ref obbligatori |
|---|---|---|---|
| **Intent** | `docs/intent/<topic>.md` (opz.) | Outcome · User · Why-now · Success · Constraint · **Out-of-scope** | — (radice) |
| **SPEC** | `SPEC.md` (root) o `docs/specs/<feature>.md` | Obiettivo · Commands · Structure · Style · Testing · Boundaries(A/N) · Success criteria · Assumptions · Open Q | `spec-id: <feature>` (usato da plan/task/commit) |
| **PLAN** | `docs/plans/<YYYY-MM-DD>-<feature>.md` | Header Global Constraints · Task N (Files/Interfaces/step checkbox) | `spec: <spec-id>` nell'header · ogni `Task N` cita la § di SPEC che implementa |
| **TASK (Backlog MD)** | Backlog MD task | Title · Acceptance · Verify · Dipendenze(blocked-by) | `spec: <spec-id> §x` · `plan: Task N` · `parent: <epic>` |
| **COMMIT** | git | `<type>: <desc>` + body | footer `Spec: <spec-id>` · `Task: <backlog-id>` · `Plan-Task: N` |
| **REVIEW** | output agent / commento PR | findings (Critical/Important/Minor) + verdict | `BASE..HEAD` SHAs · `Plan-Task: N` / `Backlog: <id>` |
| **ADR** | `docs/decisions/<NN>-<title>.md` | Status · Context · Decision · Alternatives · Consequences | `supersedes: <ADR-id>` · riferisce § SPEC/Task che motiva |

**Campi minimi garantiti dalla pipeline:** ogni task Backlog MD ha `spec-ref` + `plan-task-ref`; ogni commit di implementazione ha `Plan-Task` + `Backlog-id`; ogni review riferisce i task coperti. È la **catena continua** richiesta.

**Bridge Plan↔Backlog MD (il gap F6):** un task del plan (`Task N` in `docs/plans/`) ↔ un task Backlog MD. La mappatura va codificata in una regola CLAUDE.md + (opz.) uno slash command `/backlog-sync` (§5). Il task Backlog MD è l'unità che l'utente traccia nel tempo (stati, chiusura); il `Task N` del plan è l'unità che SDD esegue. **Devono riferirsi reciprocamente** (`Plan-Task: N` ↔ `Backlog: <id>`).

---

## 4. Regole di precedenza per `CLAUDE.md` (testo pronto da incollare)

> `~/.claude/CLAUDE.md` è **vuoto** (evidence: 0 byte). Popolarlo con questo blocco. Le regole globali in `~/.claude/rules/` restano.

```markdown
# Workflow harness — regole di precedenza

## Catena primaria (workflow principale)
Spec → Plan → Task(Backlog MD) → Code(SDD) → Review → Doc. Una fase alla volta,
con gate di approvazione bloccante dopo: spec (spec-reviewer), plan
(implementation-plan-reviewer), implementazione (test green + review pulita).

## Skill primarie per fase (default)
- F1 Brainstorming: agent-skills:interview-me (ask vaghe) / idea-refine (variazioni) + agent architect
- F2 Spec: agent-skills:spec-driven-development + architect
- F3 Spec review: mattpocock:grilling (interattivo) + agent spec-reviewer
- F4 Plan: superpowers:writing-plans (+ planning-and-task-breakdown come rubric) + architect
- F5 Plan review: agent implementation-plan-reviewer (+ doubt-driven-development se alta stake)
- F6 Task: planning-and-task-breakdown (logica) → MCP backlog (Backlog MD)
- F7 Coding: using-git-worktrees → superpowers:subagent-driven-development (consuma docs/plans/<plan>.md); executing-plans come fallback; ponytail come guardrail
- F8 Review: agent code-reviewer (locale) / agent-skills:code-review-and-quality (deep pre-merge) / code-review:code-review (PR GitHub)
- F9 Doc: agent-skills:documentation-and-adrs + consolidate-specs/comments + claude-md-management:claude-md-improver
- F10 Ship: superpowers:finishing-a-development-branch

## Fallback / priorità
- Plan per SDD: se non esiste docs/plans/<plan>.md, NON avviare SDD; torna a writing-plans.
- Review: default = agent code-reviewer; escalation a code-review-and-quality prima del merge; code-review:code-review solo su PR GitHub aperta.
- Debug: systematic-debugging (default, auto); per bug hard passa a diagnosing-bugs (feedback loop).
- Navigazione codebase: usa serena (MCP) per symbol-graph; wayfinder è planning, non navigazione.

## Quando NON usare planning mode
- Fix/attività breve (<1 modulo, <~100 righe): workflow semplificato (mini-piano in contesto, niente artefatti). Vedi 40-TARGET-HARNESS.md §2.
- Spec/plan già approvati e in esecuzione: resta in modalità esecuzione (SDD), non rientrare in planning.

## Quando i subagent sono ammessi
- Sempre in F7 (SDD: implementer + reviewer per task). Model selection: modello meno potente che regge il ruolo (mechanical=cheap, integration=standard, architecture=capable). Specifica sempre il model nel dispatch.
- In F8/F5/F3 solo se alta stake (doubt-driven: reviewer fresh-context + cross-model).
- Mai subagent di implementazione paralleli sullo stesso task (conflitto); paralleli OK per problemi indipendenti (dispatching-parallel-agents).

## Vincoli trasversali
- Backlog MD è il system of record dei task: ogni task ha cross-ref a SPEC § + Plan Task ID; ogni commit di implementazione ha footer Plan-Task + Backlog-id.
- verification-before-completion: nessun claim "fatto/funziona/passano" senza output comando fresco.
- ponytail: sui thread trust-boundary (validazione input, error-handling anti-data-loss, security, accessibilità) non semplificare MAI.
- Regole globali in ~/.claude/rules/documentation-lifecycle-rules.md (flag, non rewrite) e effort-escalation.md restano in vigore.
```

---

## 5. Slash command da creare

Esistono già (agent-skills): `/spec`, `/plan`, `/build`, `/test`, `/review`, `/ship`, `/code-simplify`, `/webperf` + mattpocock `/grilling`, `/to-tickets` + superpowers `/feature-dev` style. **Da creare** (transizioni che oggi richiedono istruzioni manuali ripetitive):

| Command | Scopo | Corpo (sintesi) |
|---|---|---|
| `/backlog-sync` | **Bridge Plan↔Backlog MD (gap F6).** Mappa ogni `Task N` di `docs/plans/<plan>.md` a un task Backlog MD con cross-ref bidirezionali, ordine per dipendenza. | Legge il plan; per ogni Task N crea/aggiorna un task Backlog MD (title dall'intent, acceptance dal plan, blocked-by dalle Interfaces/Consumes); scrive `Plan-Task: N` nel task e `Backlog: <id>` nel plan. |
| `/spec-review` | Transizione F2→F3→F4: lancia `spec-reviewer` (agent) sulla SPEC, poi se approved invita a writing-plans. | Dispatch spec-reviewer su SPEC.md; raccoglie findings; se blocking → loop; se clean → "SPEC approvata, pronto per writing-plans". |
| `/dev <feature>` | **Entry point del workflow principale**: orchestra F1→F2 con interview-me/idea-refine + architect, produce intent + SPEC. | Alias guidato: interview-me (se ask vaga) → architect (design) → spec-driven-development (SPEC.md). |
| `/bugfix <descr>` | **Entry point del workflow semplificato**: planning mode → reproduce (systematic-debugging/diagnosing-bugs) → mini-piano inline → fix Prove-It → code-reviewer. | Attiva SOLO la catena corta (§2); disabilita esplicitamente spec-driven/writing-plans/SDD. |
| `/consolidate` | Transizione F9: valuta se serve consolidate-specs/comments (feature completata?) o solo claude-md-improver. | Gate: se dirty diff su spec/commenti → consolidate-*; sempre → offri claude-md-improver su CLAUDE.md. |

---

## 6. Modifiche di configurazione (diff proposti, non applicati)

### 6.1 `~/.claude/settings.json` — `enabledPlugins`
```diff
  "enabledPlugins": {
    ...
+   "serena@claude-plugins-official": true,        // Navigazione codebase (F10) + floor per consolidate-*
    "feature-dev@claude-plugins-official": false,   // NON usato in v3 (chain a sé, ridondante vs SDD+architect)
    "code-simplifier@claude-plugins-official": false, // ridondante vs agent-skills:code-simplification
    ...
  }
```
> `serena` è oggi in `plugins/marketplaces/.../external_plugins/serena` (disabilitato). Abilitandolo diventa MCP attivo. **Verificare** che il marketplace `claude-plugins-official` esponga serena come plugin abilitabile (altrimenti aggiungere come MCP server in `~/.claude.json` → `mcpServers.serena`).

### 6.2 `~/.claude.json` — `mcpServers` (se serena non è plugin-MCP)
```diff
  "mcpServers": {
    "backlog": { ... },
+   "serena": { "<config serena MCP>" }   // symbol-graph per navigazione + floor consolidate-*
  }
```

### 6.3 Plugin da **disabilitare** (non usati in v3 → riducono registro always-on)
- `feature-dev` — chain end-to-end autonoma (code-architect/explorer/reviewer) che duplica architect + SDD + code-reviewer. Rischio: basso.
- `code-simplifier` — agente duplicato di `agent-skills:code-simplification`. Rischio: basso.
- (Valutare) `skill-creator`, `mcp-server-dev`, `claude-code-setup` — meta; **mantenere** se si costruiscono skill/MCP, altrimenti disabilitabili. Rischio: nullo (on-demand).

### 6.4 Spostamenti user↔project
- **Tutto resta user-level** (l'harness si applica a ogni progetto). Nessuno spostamento obbligatorio.
- `consolidate-specs`/`consolidate-comments` (user skills) → **mantenere user-level** ma sono legate a `documentation-lifecycle.md`; documentare che richiedono graph floor (serena) per essere "controlled".

### 6.5 `~/.claude/CLAUDE.md`
- **Popolare** (oggi vuoto) con il blocco §4. È l'azione a più alto valore immediato (dà al modello la mappa della catena senza doverla inferire).

---

## 7. Strategia token

### Dove si concentra il consumo (pipeline target)
1. **Always-on (ogni turno, latente):**
   - `using-superpowers` EXTREMELY_IMPORTANT forza-iniettata (obbliga skill-check ogni risposta) — ~62 righe + framing comportamentale.
   - `ponytail` (SessionStart hook, full) — inietta la ladder a OGNI risposta (~120 righe di prompt).
   - `explanatory` output style (SessionStart) — blocco "Insight" per risposta.
   - `security-guidance` (hooks, se policy always-on).
   - **Registro descrizioni** di ~60 skill + 4 agent user + ~12 agent plugin + ~15 cmd = alcune migliaia di token latenti.
2. **On-demand (all'invocazione):** corpi grandi — `writing-skills` 679, `subagent-driven-development` 503, `skill-creator` 486, `security-and-hardening` 468, `code-review-and-quality` 396, `TDD` 320/398.
3. **Moltiplicatore subagent (il più insidioso):** SDD (implementer + reviewer per task + final reviewer, ognuno ri-raccoglie contesto da zero), `doubt-driven` (reviewer fresh-context + cross-model CLI), `dispatching-parallel-agents` (N paralleli), `code-review:code-review` cmd (Haiku×4 + Sonnet×5).

### Interventi che riducono il consumo
| # | Intervento | Risparmio | Costo/perdita |
|---|---|---|---|
| 1 | **Disabilitare `feature-dev` + `code-simplifier`** (§6.3) | -registro ~5 entità | nullo (non in v3) |
| 2 | **`ponytail` → `lite` di default** (o off salvo `/ponytail full`) | -ladder enforced ogni risposta | perdi guardrail automatico YAGNI (mitiga con regola CLAUDE.md) |
| 3 | **SDD model-selection rigoroso** (cheap per task mechanical) | - costo subagent | nessuno (è già nella skill) |
| 4 | **Evitare `doubt-driven` di default** (solo alta stake) | -subagent fresh-context + CLI | perdi adversarial su task a bassa stake (accettabile) |
| 5 | **`code-review:code-review` cmd solo su PR reali** | -Haiku×4+Sonnet×5 | nullo (è GitHub-specific) |
| 6 | **Non caricare corpi meta** (writing-skills/skill-creator/mcp-server-dev) salvo necessità | -on-demand pesante | nullo (invocazione rara) |
| 7 | **Backlog MD come SoR** riduce storia di task dispersa | -contesto di coordinamento | nullo |

### Come lo verifichi empiricamente (ambienti disponibili)
- **`/context`** (Claude Code): mostra la ripartizione del contesto (skill descriptions vs system vs tools) — verifica il peso del registro.
- **`/cost`** e metriche per-sessione: `.claude.json` registra `lastTotalInputTokens`, `lastTotalCacheReadInputTokens`, `lastTotalCacheCreationInputTokens`, `lastModelUsage`, `lastCost` per progetto (evidence: `~/.claude.json:835-871`). Confronta una sessione "prima" (ponytail full + feature-dev on) vs "dopo" (lite + disabilitati) a parità di task.
- **Cache hit ratio**: prompt-cache TTL 5 min; `ponytail`/`explanatory` sempre-on tengono il cache caldo ma se saturano il contesto forzano re-read. Osserva `lastTotalCacheReadInputTokens` crescere.
- **`skillUsage`** (`.claude.json:1859`): dopo N settimane, skill ancora a uso 0 = candidate a disabilitazione (ma ricorda: uso=0 può essere recency di installazione).
- **Ledger SDD** (`.superpowers/sdd/<plan>/progress.md`): misura quante task/subagent per plan → stima del moltiplicatore reale.

### 3 modifiche a più alto impatto token (anticipo per `50-MIGRATION.md`)
1. Disabilitare `feature-dev` + `code-simplifier` (ridondanze) → -registro, rischio basso.
2. `ponytail` default `lite` (off salvo esplicito) → -ladder ogni risposta.
3. Popolare `~/.claude/CLAUDE.md` (vuoto) → +direzione esplicita riduce tentativi/sviluppi errati (risparmio indiretto maior del risparmio diretto).
