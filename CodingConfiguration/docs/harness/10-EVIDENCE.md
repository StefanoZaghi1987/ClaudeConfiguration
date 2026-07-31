# 10 — Dossier per skill (Fase 1)

> Un dossier per ogni skill/agent in shortlist, derivato dal **corpo del file su disco** (path citato). Campi vuoti/non determinabili dichiarati esplicitamente. Costo token: **Basso** <50 righe · **Medio** 50-200 · **Alto** 200-400 · **Molto alto** >400 (corpo on-demand; il `description` è sempre nel registro always-on).
>
> **Convenzione mattpocock:** i file con `disable-model-invocation: true` **non si auto-attivano** mai via description — solo invocazione esplicita (slash/`/skill`). Rilevante per il criterio "robustezza del trigger".

---

## Fase 1 — Brainstorming / esplorazione del problema

### `superpowers:brainstorming`  · plugin superpowers
- **Cosa fa:** trasforma un'idea in design/spec tramite dialogo collaborativo. Esplora il contesto, fa domande una alla volta, propone 2-3 approcci con trade-off, presenta il design a sezioni, scrive la spec, fa self-review, poi **invoca writing-plans**.
- **Attivazione:** description `You MUST use this before any creative work…`; auto-trigger su "creating features/building components/adding functionality/modifying behavior".
- **Procedura:** **prescrittiva forte**. `<HARD-GATE>`: niente codice/skill di implementazione prima dell'approvazione del design. Checklist di 9 step obbligatori ("You MUST create a task for each").
- **Artefatti in → out:** contesto progetto (file/docs/commits) → `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` (committato).
- **Subagent:** nessuno diretto; visual companion opzionale (browser, "token-intensive").
- **Interrogazione utente:** una domanda per messaggio; multiple choice preferite; approvazione per sezione di design + gate di review della spec scritta.
- **Directive forti:** HARD-GATE pre-implementation; "The ONLY skill you invoke after brainstorming is writing-plans"; YAGNI ruthless; ogni progetto (anche "semplice") passa per il processo.
- **Costo token:** **Medio** (151 righe) + visual companion opzionale può essere alto.
- **Fasi:** 1 brainstorming, 2 spec (produce il design doc), transizione a 4.
- **Path:** `cache/.../superpowers/6.2.0/skills/brainstorming/SKILL.md`

### `agent-skills:interview-me`  · plugin agent-skills
- **Cosa fa:** estrae l'intento reale (vs quello che l'utente *pensa* di volere) con un'intervista **una-domanda-per-volta**, ognuna con una **GUESS** allegata, fino a ~95% di confidenza. Output: statement d'intento confermato.
- **Attivazione:** description; trigger "interview me/grill me/are we sure?/stress-test my thinking" o ask underspecified.
- **Procedura:** prescrittiva (5 step + stop condition "predict next 3 questions"); **vietata in contesti non-interattivi** (CI/`/loop`/autonomous).
- **Artefatti in → out:** ask → `docs/intent/[topic].md` (opzionale, solo su conferma).
- **Subagent:** nessuno.
- **Interrogazione utente:** una alla volta con guess; anti-sincotismo (accetta "whatever you think" come NON-risposta); gate = "yes" esplicito; probe "what would you actually want if you didn't have to justify it?".
- **Directive forti:** una domanda per messaggio; "Out of scope" non negoziabile nel restate; niente spec/plan/prima del yes esplicito.
- **Costo token:** **Alto** (225 righe).
- **Fasi:** 1 brainstorming (pre-spec); hand-off a idea-refine/spec-driven-development.
- **Path:** `cache/addy.../skills/interview-me/SKILL.md`

### `agent-skills:idea-refine`  · plugin agent-skills
- **Cosa fa:** divergenza→convergenza: restate come "How Might We", 3-5 domande, genera 5-8 variazioni (lenti: inversion, constraint removal, audience shift, 10x…), stress-test di 2-3 direzioni, surface assunzioni, produce un one-pager.
- **Attivazione:** description; trigger "ideate/refine this idea/stress-test my plan".
- **Procedura:** consultativa-prescrittiva (3 fasi); usa **AskUserQuestion** (batch) per le domande.
- **Artefatti in → out:** idea → `docs/ideas/[idea-name].md` (one-pager: Problem/Direction/Assumptions/MVP/Not Doing).
- **Subagent:** nessuno.
- **Interrogazione utente:** 3-5 domande (batch via AskUserQuestion); "be honest, not supportive" (non yes-machine).
- **Directive forti:** max 5-8 variazioni (no 20+); surface assunzioni prima di convergere; "Not Doing" list obbligatoria.
- **Costo token:** **Alto** (178 righe) + riferimenti (`frameworks.md`, `refinement-criteria.md`, `examples.md`).
- **Fasi:** 1 brainstorming; hand-off a spec-driven-development.
- **Path:** `cache/addy.../skills/idea-refine/SKILL.md`

### `mattpocock:grilling` (+ `grill-me`, `grill-with-docs`)  · plugin mattpocock
- **Cosa fa:** "interview me relentlessly" su ogni aspetto di un piano/decisione/idea, scendendo ogni ramo dell'albero decisionale una domanda alla volta, con risposta raccomandata allegata. `grill-me`/`grill-with-docs` sono thin wrapper (quest'ultimo crea anche ADR+glossary via domain-modeling).
- **Attivazione:** `grilling` è auto-invocabile (trigger 'grill'); `grill-me`/`grill-with-docs` hanno `disable-model-invocation: true` → **solo espliciti**.
- **Procedura:** prescrittiva minimalista (12 righe per `grilling`).
- **Artefatti in → out:** conversazione → understanding condiviso (no file di default; grill-with-docs → ADR/glossary).
- **Subagent:** nessuno.
- **Interrogazione utente:** una alla volta, attende feedback, raccomandazione allegata; "i fatti li cerco, le decisioni sono tue".
- **Directive forti:** una domanda alla volta; non agire finché non c'è understanding condiviso.
- **Costo token:** **Basso** (7-12 righe).
- **Fasi:** 1 brainstorming, 3/5 review adversariale (stress-test di spec/plan).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/productivity/grilling/SKILL.md`

---

## Fase 2 — Redazione della specifica

### `agent-skills:spec-driven-development` (+ cmd `/spec`)  · plugin agent-skills
- **Cosa fa:** workflow **gated a 4 fasi** (SPECIFY→PLAN→TASKS→IMPLEMENT, ciascuna con human review). Surface delle assunzioni prima di scrivere; spec su 6 aree (Objective/Commands/Project Structure/Code Style/Testing/Boundaries Always-Ask-Never); riformula requisiti vaghi come success criteria. Defers a planning-and-task-breakdown per plan/tasks.
- **Attivazione:** description (new project/feature, requisiti ambigui); cmd `/spec`.
- **Procedura:** **prescrittiva**; gate umano ad ogni fase.
- **Artefatti in → out:** requisiti → `SPEC.md` (root, cmd `/spec`) o `tasks/plan.md`+`tasks/todo.md`.
- **Subagent:** nessuno diretto (fase 4 → incremental-implementation/test-driven-development/context-engineering).
- **Interrogazione utente:** clarifying questions; "Correct me now or I'll proceed".
- **Directive forti:** "Do not advance until validated"; surface assunzioni subito; niente codice senza spec.
- **Costo token:** **Alto** (206 righe).
- **Fasi:** 2 spec, 4 plan, 6 task, 7 implement (intera catena).
- **Path:** `cache/addy.../skills/spec-driven-development/SKILL.md`; cmd `cache/addy.../.claude/commands/spec.md`

### `mattpocock:to-spec`  · plugin mattpocock
- **Cosa fa:** **nessuna interview** — sintetizza la conversazione/gli ADR/glossary esistenti in una spec (PRD) e la **pubblica sull'issue tracker** con label `ready-for-agent`. Usa il glossario di dominio e rispetta gli ADR. Template: Problem/Solution/User Stories/Implementation Decisions/Testing/Out of Scope.
- **Attivazione:** `disable-model-invocation: true` → **solo esplicita**.
- **Procedura:** prescrittiva (5 step); richiede `/setup-matt-pocock-skills` (tracker config).
- **Artefatti in → out:** conversazione → spec pubblicata su tracker.
- **Subagent:** nessuno.
- **Interrogazione utente:** conferma solo sui "seams" di test; niente interview.
- **Directive forti:** "Do NOT interview"; no path/codice specifici nei ticket (diventano stale); usa glossario+ADR.
- **Costo token:** **Medio** (75 righe).
- **Fasi:** 2 spec (filosofia **sintesi**, complementare a brainstorming/interview).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/to-spec/SKILL.md`

### `superpowers:brainstorming` (produce design doc = spec) — vedi Fase 1.

---

## Fase 3 — Review della specifica

### Agente `spec-reviewer`  · user-level
- **Cosa fa:** review della spec su 4 assi (Correctness/Architecture/Security/Maintainability); legge solo il necessario per verificare le claim contro il codebase; ritorna ranked list (blocking prima, poi improvements) con rationale + fix concreto.
- **Attivazione:** description "Use proactively at the end of any spec-writing phase".
- **Procedura:** consultativa-read-only; model `fable`; tools Read/Grep/Glob.
- **Artefatti in → out:** spec → ranked review (no file).
- **Subagent:** è un subagent (contesto isolato).
- **Interrogazione utente:** nessuna (produce report).
- **Directive forti:** "Read only what you need"; "Do not restate the spec".
- **Costo token:** **Basso** (16 righe) → contesto isolato, riavvia da zero.
- **Fasi:** 3 spec review.
- **Path:** `~/.claude/agents/spec-reviewer.md`

### `agent-skills:doubt-driven-development`  · plugin agent-skills
- **Cosa fa:** review **adversariale in-flight** (non post-hoc): per ogni decisione non-triviale, isola ARTIFACT+CONTRACT (NON il CLAIM), spawna un reviewer fresh-context con prompt "find issues", RECONCILE i finding (contract-misread/actionable/trade-off/noise), loop ≤3 cicli. Offre **cross-model** (Gemini/Codex) ogni ciclo.
- **Attivazione:** description (correctness>sprint, codice non familiare, stakes alti).
- **Procedura:** **prescrittiva forte** (5 step); pensata per main-session orchestrator (non nested in subagent).
- **Artefatti in → out:** decisione → finding classificati + fix.
- **Subagent:** **sì** — reviewer fresh-context (isolato) ogni ciclo; opz. cross-model via CLI esterna.
- **Interrogazione utente:** offre cross-model ogni ciclo (scelta utente).
- **Directive forti:** "Pass ARTIFACT+CONTRACT only, NOT the CLAIM"; prompt deve essere adversariale; bounded 3 cicli; "doubt theater" come red flag; niente nested persona.
- **Costo token:** **Molto alto** (243 righe + spawn subagent + opz. CLI esterna).
- **Fasi:** 3 spec review, 5 plan review, 7 coding (in-flight), trasversale ad alta stake.
- **Path:** `cache/addy.../skills/doubt-driven-development/SKILL.md`

> **Nota cross-fase:** per F3/F5 l'utente ha l'agente `spec-reviewer`/`implementation-plan-reviewer` (read-only, concisi). `doubt-driven` è più pesante ma adversariale e cross-model. `grilling` è l'opzione leggera interattiva.

---

## Fase 4 — Implementation plan

### `superpowers:writing-plans`  · plugin superpowers
- **Cosa fa:** piano di implementazione per un ingegnere a contesto zero: mappa file/interfacce, task right-sized (una task = un ciclo di test + gate di reviewer), step bite-sized (2-5 min), TDD-oriented, niente placeholder, self-review contro la spec. Hand-off a subagent-driven-development (consigliato) o executing-plans.
- **Attivazione:** description ("spec/requirements per multi-step task, before touching code"); terminal state di brainstorming.
- **Procedura:** **prescrittiva** (header obbligatorio, struttura task, no-placeholder, self-review).
- **Artefatti in → out:** spec → `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`.
- **Subagent:** nessuno diretto; hand-off a subagent-driven-development/executing-plans.
- **Interrogazione utente:** offerta scelta di esecuzione (subagent vs inline) alla fine.
- **Directive forti:** ogni step deve contenere il contenuto reale (no "TBD/handle edge cases"); announce "I'm using writing-plans".
- **Costo token:** **Alto** (168 righe).
- **Fasi:** 4 plan (hand-off a 7).
- **Path:** `cache/.../superpowers/6.2.0/skills/writing-plans/SKILL.md`

### `agent-skills:planning-and-task-breakdown` (+ cmd `/plan`)  · plugin agent-skills
- **Cosa fa:** decomposizione in task: enter plan mode (read-only), mappa **dependency graph**, **vertical slicing** (una path completa per task, non strati orizzontali), task sizing (XS–XL, XL va spezzato), checkpoint ogni 2-3 task, parallelizzazione (safe/sequential/coordination).
- **Attivazione:** description (spec→task, task troppo grande, parallelismo); cmd `/plan`.
- **Procedura:** consultativa-prescrittiva.
- **Artefatti in → out:** spec → `tasks/plan.md` + `tasks/todo.md` (convention attesa da `/build`).
- **Subagent:** nessuno diretto.
- **Interrogazione utente:** human review del piano.
- **Directive forti:** "Do NOT write code during planning"; no task >5 file; checkpoint obbligatori.
- **Costo token:** **Alto** (234 righe) + riferimenti (`definition-of-done.md`).
- **Fasi:** 4 plan, 6 task decomposition.
- **Path:** `cache/addy.../skills/planning-and-task-breakdown/SKILL.md`; cmd `cache/addy.../.claude/commands/plan.md`

### Agente `architect`  · user-level
- **Cosa fa:** progetta l'architettura/approach: ground nel codice reale (moduli/convenzioni/pattern), component boundaries + data flow + dove atterra il codice, 1-2 alternative con trade-off, security/failure modes, sequenza di build che mantiene verde. Produce il design che `spec-reviewer` critica.
- **Attivazione:** description "Use proactively at the start of planning/architecture, before writing a plan or code".
- **Procedura:** consultativa-read-only; model `fable`; tools Read/Grep/Glob.
- **Artefatti in → out:** task → design conciso (no step-by-step); hand-off a implementation-plan-reviewer.
- **Subagent:** è un subagent (contesto isolato).
- **Interrogazione utente:** nessuna (produce design).
- **Directive forti:** "Investigate the real codebase before proposing"; "Do not invent structure that ignores what is already there"; preferire estendere pattern esistenti.
- **Costo token:** **Basso** (17 righe) → contesto isolato.
- **Fasi:** 2 design, 4 plan (pre-piano).
- **Path:** `~/.claude/agents/architect.md`

---

## Fase 5 — Review dell'implementation plan

### Agente `implementation-plan-reviewer`  · user-level
- **Cosa fa:** review del piano contro il codebase reale su 4 assi (Correctness: file/API esistenti, ordine che mantiene verde; Completeness: migrations/config/tests/docs/rollout; Architecture: rispetto pattern; Risk: step irreversibili/security/coupling). Spot-check leggendo i file referenziati.
- **Attivazione:** description "Use proactively after a plan is written, before execution".
- **Procedura:** consultativa-read-only; model `fable`; tools Read/Grep/Glob.
- **Artefatti in → out:** plan → blocking issues prima + fix concrete, poi optional.
- **Subagent:** è un subagent (contesto isolato).
- **Interrogazione utente:** nessuna.
- **Directive forti:** spot-check delle claim del piano contro i file.
- **Costo token:** **Basso** (16 righe) → contesto isolato.
- **Fasi:** 5 plan review.
- **Path:** `~/.claude/agents/implementation-plan-reviewer.md`

*(Vedi anche `doubt-driven-development` in F3 per review adversariale/cross-model dei piani.)*

---

## Fase 6 — Decomposizione in task atomici (Backlog MD)

### `mattpocock:to-tickets`  · plugin mattpocock
- **Cosa fa:** spezza piano/spec/conversazione in ticket **tracer-bullet** (vertical slice completa × livello), ciascuno con i propri **blocking edges**; gestisce wide-refactor come expand–contract; pubblica su tracker reale (native blocking links) o locale (`.scratch/<feature>/issues/<NN>-<slug>.md`); lavora la **frontier** (ticket con blocker risolti). Quiz utente su granularità/edges.
- **Attivazione:** `disable-model-invocation: true` → **solo esplicita**; richiede `/setup-matt-pocock-skills`.
- **Procedura:** prescrittiva (5 step).
- **Artefatti in → out:** piano → ticket pubblicati (tracker o file locali con blocking edges).
- **Subagent:** nessuno.
- **Interrogazione utente:** quiz su granularità + correttezza dei blocking edges; itera fino ad approvazione.
- **Directive forti:** ogni slice = path COMPLETA attraverso tutti i layer; no path/codice specifici nei ticket; "Do NOT close/modify parent issue".
- **Costo token:** **Medio** (105 righe).
- **Fasi:** 6 task decomposition.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/to-tickets/SKILL.md`

### `agent-skills:planning-and-task-breakdown` (fase Tasks di spec-driven-development) — vedi F4.
### MCP `backlog` — task management persistente (Backlog MD), §1.2 inventario.

> **Tensione chiave F6:** l'utente usa **Backlog MD** (MCP) per i task. `to-tickets` e `planning-and-task-breakdown` producono task in formati propri (`.scratch/issues/`, `tasks/todo.md`) **diversi** da Backlog MD → richiede integrazione/contratto (Fase 4).

---

*(F10 rimanenti: git, security, nav, simplify, design, non-SDLC, meta; dossier a seguire.)*

### `mattpocock:diagnosing-bugs`  · plugin mattpocock
- **Cosa fa:** debug **centrato sul feedback loop**: "the skill IS building a tight pass/fail signal". 10 modi per costruire un loop (failing test, curl, CLI, headless browser, replay, throwaway harness, fuzz, bisect, differential, HITL). Poi: tighten il loop, 6 fasi (loop→reproduce+minimise→3-5 hypotheses→instrument→fix+regression→cleanup+post-mortem). Tag debug log `[DEBUG-xxxx]`. Hand-off a improve-codebase-architecture.
- **Attivazione:** description ("diagnose/debug this", broken/throwing/failing/slow).
- **Procedura:** prescrittiva (6 fasi, "no loop, no Phase 2").
- **Artefatti in → out:** bug → loop red-capable + regression test + post-mortem.
- **Subagent:** opz. (research subagent); usa scripts (`hitl-loop.template.sh`).
- **Interrogazione utente:** mostra 3-5 hypothesis ranked prima di testare.
- **Directive forti:** "Refuse to give up" nel costruire il loop; niente hypothesis prima del loop; per bug non-deterministici alza la reproduction rate.
- **Costo token:** **Alto** (134 righe).
- **Fasi:** 10 debug.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/diagnosing-bugs/SKILL.md`

### `superpowers:using-git-worktrees`  · plugin superpowers
- **Cosa fa:** garantisce workspace isolato: **detect isolation first** (linked worktree vs submodule), poi native tools (EnterWorktree/`/worktree`), fallback `git worktree add` solo se nessun tool nativo; project setup auto; verify clean baseline. "Never fight the harness".
- **Attivazione:** description (feature work needing isolation, before executing plans).
- **Procedura:** prescrittiva (Step 0-3).
- **Costo token:** **Medio** (167 righe).
- **Fasi:** 10 isolamento (prerequisito di SDD/executing-plans).
- **Path:** `cache/.../superpowers/6.2.0/skills/using-git-worktrees/SKILL.md`

### `superpowers:finishing-a-development-branch`  · plugin superpowers
- **Cosa fa:** integrazione del lavoro: verify tests → detect env → **present 3 options** (merge locale / push+PR / keep) → execute → cleanup worktree. Discard solo su richiesta esplicita + typed "discard". Per detached HEAD 2 opzioni (no merge). Usata 30× (4ª skill Superpowers più usata).
- **Attivazione:** description (implementation complete, tests pass, decide integration).
- **Procedura:** prescrittiva (6 step, menu fisso).
- **Costo token:** **Alto** (201 righe).
- **Fasi:** 10 integrazione (terminale di SDD/executing-plans).
- **Path:** `cache/.../superpowers/6.2.0/skills/finishing-a-development-branch/SKILL.md`

### `agent-skills:git-workflow-and-versioning`  · plugin agent-skills
- **Cosa fa:** disciplina git+versioning: trunk-based dev (branch 1-3gg), commit atomici, messaggi `<type>:` (feat/fix/refactor/test/docs/chore), worktree per agent paralleli, save-point pattern, pre-commit hygiene, **semver + tag + changelog** umano.
- **Attivazione:** description (any code change; commit/branch/conflict/release/version).
- **Procedura:** consultativa-prescrittiva.
- **Costo token:** **Molto alto** (355 righe).
- **Fasi:** 10 git/versioning (trasversale).
- **Path:** `cache/addy.../skills/git-workflow-and-versioning/SKILL.md`

### `mattpocock:wayfinder`  · plugin mattpocock
- **Cosa fa:** pianifica **lavori enormi** (>1 sessione) come **mappa condivisa di decision-ticket** sull'issue tracker: destination, frontier, blocking nativo, fog-of-war, ticket HITL/AFK (research/prototype/grilling/task), ≤1 ticket/session. "Plan, don't do". Usa grilling/domain-modeling/research.
- **Attivazione:** `disable-model-invocation: true` → solo esplicita; richiede `/setup-matt-pocock-skills`.
- **Procedura:** prescrittiva (chart / work-through).
- **Costo token:** **Alto** (128 righe).
- **Fasi:** 1/4/6 planning per scope giganti (complementare, non concorrente diretto del plan quotidiano).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/wayfinder/SKILL.md`

### `agent-skills:code-simplification` (+ agente `code-simplifier`)  · plugin agent-skills / code-simplifier
- **Cosa fa:** semplifica codice preserving behavior: 5 principi (preserve behavior, follow conventions, clarity>cleverness, maintain balance, scope to what changed); **Chesterton's fence** (capisci prima perché esiste); pattern strutturali/naming/redundancy; Rule of 500 (sopra → automation); esempi TS/Python/React. L'agente `code-simplifier` fa la stessa cosa su recently-modified code.
- **Attivazione:** description (refactor for clarity, accumulated complexity); l'agente via Agent tool.
- **Procedura:** prescrittiva (4-step).
- **Costo token:** **Molto alto** (331 righe).
- **Fasi:** 10 semplificazione (review/refactor).
- **Path:** `cache/addy.../skills/code-simplification/SKILL.md`

### `mattpocock:domain-modeling`  · plugin mattpocock
- **Cosa fa:** costruisce/affila il **domain model**: `CONTEXT.md` glossary (solo terminologia, zero implementazione), challenge termini fuzzy, scenari edge-case, cross-ref con codice, ADR **parsimoniosi** (solo se hard-to-reverse + sorprendente + reale trade-off).
- **Attivazione:** description (pin down terminology, ubiquitous language, record decision).
- **Procedura:** consultativa.
- **Costo token:** **Medio** (74 righe).
- **Fasi:** 2/10 domain modeling (supporto trasversale).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/domain-modeling/SKILL.md`

### `mattpocock:codebase-design`  · plugin mattpocock
- **Cosa fa:** vocabolario per **deep modules** (Ousterhout rivisto): module/interface/implementation/depth/seam/adapter/leverage/locality; deep vs shallow; deletion test; interface=test surface; "one adapter = hypothetical seam, two = real"; design-it-twice (sub-agent paralleli). Supporta altre skill (to-spec, code-review, improve-codebase-architecture).
- **Attivazione:** description (design/improve module interface, deepening, seam placement, testability).
- **Procedura:** consultativa (glossary + principi).
- **Costo token:** **Alto** (114 righe).
- **Fasi:** 2/4 design moduli (supporto).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/codebase-design/SKILL.md`

---

## Long-tail (ortogonali / meta / periferiche)

> Dossier dei cluster ortogonali (agent-skills verticali), meta-plugin (skill-creator, mcp-server-dev), ponytail-aux, feature-dev, agent di plugin e mattpocock rimanenti. Estratti da **lettura on-disk** (path citato); formato compatto. Queste skill **non competono** per i vincitori di fase del workflow SDLC — sono strumenti di dominio o meta — ma sono analizzate per il piano di migrazione (keep/disable).

### Ortogonali agent-skills (dominio)

### `agent-skills:security-and-hardening`  · ortogonale (security)
- **Cosa fa:** security-first: ogni input esterno ostile, ogni segreto sacro; **threat modeling STRIDE** prima dell'hardening; prevenzione OWASP Top 10 (injection, XSS, SSRF, broken auth), gestione secret, triage dipendenze. Sistema Always/Ask First/Never.
- **Attivazione:** auto-invocabile. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Molto alto (~468). **Fasi:** ortogonale (coding constraint).
- **Path:** `cache/addy.../skills/security-and-hardening/SKILL.md`

### `agent-skills:api-and-interface-design`  · ortogonale (design API)
- **Cosa fa:** progetta interfacce/API stabili e difficili da usare male: Hyrum's Law, Contract-First, One-Version Rule, error semantics consistenti, validazione ai boundary, pattern REST/TS (branded types, discriminated unions).
- **Attivazione:** auto. **Procedura:** consultativa. **Subagent:** no. **Costo:** Alto (~295). **Fasi:** spec/plan (il contratto precede l'implementazione).
- **Path:** `cache/addy.../skills/api-and-interface-design/SKILL.md`

### `agent-skills:source-driven-development`  · ortogonale (grounding docs)
- **Cosa fa:** obbliga ogni decisione framework-specific a basarsi su **docs ufficiali** (non memoria): ciclo DETECT→FETCH→IMPLEMENT→CITE; divieto blog/Stack Overflow; citazione con URL completo.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Medio (~195). **Fasi:** coding (framework-specific).
- **Path:** `cache/addy.../skills/source-driven-development/SKILL.md`

### `agent-skills:ci-cd-and-automation`  · ortogonale (CI/CD)
- **Cosa fa:** automatizza quality gate (lint/typecheck/test/build/audit) via GitHub Actions; deployment strategies (feature flag, staged rollout, rollback), environment management, CI optimization. "No gate can be skipped".
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto (~391). **Fasi:** ortogonale (enforcement trasversale).
- **Path:** `cache/addy.../skills/ci-cd-and-automation/SKILL.md`

### `agent-skills:observability-and-instrumentation`  · ortogonale (observability)
- **Cosa fa:** strumenta codice (logging strutturato, metriche RED/USE, tracing OTel, alerting su sintomi) per rendere visibile il comportamento in produzione; regole su correlation ID, cardinalità, no secret nei log.
- **Attivazione:** auto. **Procedura:** prescrittiva (7 step). **Subagent:** no. **Costo:** Alto (~204). **Fasi:** coding (strumentazione con la feature).
- **Path:** `cache/addy.../skills/observability-and-instrumentation/SKILL.md`

### `agent-skills:frontend-ui-engineering`  · ortogonale (frontend)
- **Cosa fa:** UI production-quality accessibili/responsive, evita "AI aesthetic" (palette viola, gradienti, rounded-2xl); component architecture, state management, design system, **WCAG 2.1 AA**, loading/empty/error states.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto (~329). **Fasi:** coding (UI).
- **Path:** `cache/addy.../skills/frontend-ui-engineering/SKILL.md`

### `agent-skills:performance-optimization`  · ortogonale (perf)
- **Cosa fa:** ottimizza con workflow **measure-first** (MEASURE→IDENTIFY→FIX→VERIFY→GUARD); fix anti-pattern (N+1, bundle, re-render, caching), target Core Web Vitals; regola "neutral = revert".
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto (~397). **Fasi:** coding/review (su evidenza misurata).
- **Path:** `cache/addy.../skills/performance-optimization/SKILL.md`

### `agent-skills:shipping-and-launch`  · ortogonale (ship)
- **Cosa fa:** pre-launch checklist (quality/security/perf/a11y/infra/doc), feature flag strategy, staged rollout con soglie avanzare/tenere/rollback, post-launch verification.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto (~311). **Fasi:** ship/lancio.
- **Path:** `cache/addy.../skills/shipping-and-launch/SKILL.md`

### `agent-skills:deprecation-and-migration`  · ortogonale (lifecycle)
- **Cosa fa:** gestisce rimozione/migrazione di sistemi/API legacy; decisioni deprecation (advisory vs compulsory), pattern migrazione (Strangler, Adapter, feature flag), migrazioni DB expand/contract con down path testato.
- **Attivazione:** auto. **Procedura:** consultativa-prescrittiva. **Subagent:** no. **Costo:** Alto (~248). **Fasi:** ortogonale (lifecycle).
- **Path:** `cache/addy.../skills/deprecation-and-migration/SKILL.md`

### `agent-skills:browser-testing-with-devtools`  · ortogonale (browser test)
- **Cosa fa:** usa Chrome DevTools MCP (screenshot, DOM, console, network, perf trace, a11y tree); security boundary (profile isolation, contenuto browser untrusted, JS exec read-only); workflow debug UI/network/perf. **Richiede MCP chrome-devtools configurato.**
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto (~318). **Fasi:** coding/review (verifica runtime browser).
- **Path:** `cache/addy.../skills/browser-testing-with-devtools/SKILL.md`

### Meta-plugin + MCP-authoring

### `superpowers:using-superpowers`  · meta (always-on, forza-iniettata)
- **Cosa fa:** regola "invoca skill rilevanti **PRIMA** di ogni risposta/azione (incluse domande di chiarimento)"; priorità tra skill di processo e implementazione. **EXTREMELY_IMPORTANT, iniettata a ogni session start.**
- **Attivazione:** sempre-on. **Procedura:** prescrittiva fortissima. **Subagent:** no. **Costo:** Basso (~62) ma **always-on comportamentale**. **Fasi:** meta/trasversale.
- **Path:** `cache/.../superpowers/6.2.0/skills/using-superpowers/SKILL.md`

### `agent-skills:using-agent-skills`  · meta
- **Cosa fa:** meta-skill di scoperta: mappa fase-di-sviluppo → skill corretta (interview-me→spec→plan→implement→test→review→ship); fissa 6 comportamenti (surface assumptions, push-back, verify).
- **Attivazione:** auto. **Procedura:** consultativa. **Subagent:** no. **Costo:** Medio (~192). **Fasi:** meta.
- **Path:** `cache/addy.../skills/using-agent-skills/SKILL.md`

### `superpowers:writing-skills`  · meta (authoring skill)
- **Cosa fa:** crea/modifica skill applicando **TDD alla documentazione**: scrivi test di pressione, osserva baseline failure, scrivi la skill per chiudere ogni loophole; SDO, bulletproofing, RED-GREEN-REFACTOR.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Molto alto (~680). **Fasi:** meta.
- **Path:** `cache/.../superpowers/6.2.0/skills/writing-skills/SKILL.md`

### `skill-creator:skill-creator`  · meta (authoring + eval skill)
- **Cosa fa:** workflow authoring skill: cattura intent, scrive SKILL.md, lancia **test case paralleli** (with-skill vs baseline) via subagent, valuta con benchmark, itera, ottimizza la description di triggering.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** **sì** (test case, grading, blind comparison). **Costo:** Molto alto (~486). **Fasi:** meta.
- **Path:** `cache/.../skill-creator/unknown/skills/skill-creator/SKILL.md`

### `claude-code-setup:claude-automation-recommender`  · meta (setup harness)
- **Cosa fa:** analizza la codebase (read-only) e raccomanda automazioni Claude Code (hooks, subagent, skill, plugin, MCP) con 1-2 suggerimenti per categoria basati sui segnali del progetto.
- **Attivazione:** auto. **Procedura:** consultativa. **Subagent:** no. **Costo:** Alto (~289). **Fasi:** meta/setup.
- **Path:** `cache/.../claude-code-setup/1.0.0/skills/claude-automation-recommender/SKILL.md`

### `mcp-server-dev:build-mcp-server` / `build-mcp-app` / `build-mcpb`  · dominio (MCP)
- **Cosa fa:** entry point per costruire un MCP server (interroga caso d'uso, raccomanda deployment remote/MCPB/stdio, sceglie tool-design pattern); `build-mcp-app` aggiunge UI widget interattivi (iframe, SDK ext-apps); `build-mcpb` pacchettizza con runtime (manifest, build pipeline, sicurezza onere sul dev).
- **Attivazione:** auto. **Procedura:** prescrittiva. **Subagent:** no. **Costo:** Alto/Alto/Medio (~222/393/200). **Fasi:** dominio MCP / ship.
- **Path:** `cache/.../mcp-server-dev/unknown/skills/{build-mcp-server,build-mcp-app,build-mcpb}/SKILL.md`

### Ponytail-aux

### `ponytail:ponytail-review` / `ponytail-audit`  · review over-engineering
- **Cosa fa:** review **solo over-engineering**: `ponytail-review` sul diff (un finding/riga: tag delete/stdlib/native/yagni/shrink, chiude con `net: -N lines possible`); `ponytail-audit` **repo-wide** (ranked, biggest cut first). One-shot, non applicano fix.
- **Attivazione:** auto. **Procedura:** prescrittiva. **Costo:** Basso/Medio (~58/42). **Fasi:** review/trasversale.
- **Path:** `cache/ponytail/.../skills/{ponytail-review,ponytail-audit}/SKILL.md`

### `ponytail:ponytail-debt` / `ponytail-gain` / `ponytail-help`  · debt/display
- **Cosa fa:** `ponytail-debt` harvest dei commenti `ponytail:` in un debt ledger (flagga marker senza upgrade path); `ponytail-gain` scoreboard ASCII dell'impatto misurato; `ponytail-help` quick-reference card. One-shot.
- **Attivazione:** esplicita/deutiche. **Costo:** Basso/Medio. **Fasi:** trasversale.
- **Path:** `cache/ponytail/.../skills/{ponytail-debt,ponytail-gain,ponytail-help}/SKILL.md`

### feature-dev (cmd + agent) e agent di plugin

### `feature-dev:feature-dev` (cmd)  · flow end-to-end guidato
- **Cosa fa:** guida sviluppo feature in 7 fasi (Discovery→Exploration con code-explorer→Clarifying Q→Architecture con code-architect→Implementation→Quality Review→Summary) con TodoWrite + attesa approvazione. **Chain a sé** (usa i 3 agent feature-dev).
- **Attivazione:** solo esplicita (`/feature-dev`). **Procedura:** prescrittiva. **Subagent:** **sì** (code-explorer/code-architect/code-reviewer paralleli, sonnet). **Costo:** Medio (~126). **Fasi:** define→plan→build→review.
- **Path:** `cache/.../feature-dev/unknown/commands/feature-dev.md`

### `feature-dev:code-architect` / `code-explorer` / `code-reviewer` (agent)
- **code-architect:** blueprint architetturale decisionista (file create/modificare, design componenti, data flow, build sequence). **code-explorer:** traccia implementazione feature esistente (entry point→storage, flow + file essenziali). **code-reviewer:** review diff con confidence scoring 0-100, solo issue ≥80 (Critical/Important + fix).
- **Attivazione:** subagent (sonnet). **Costo:** Basso/Medio/Basso (~35/52/47). **Fasi:** plan/discovery/review.
- **Path:** `cache/.../feature-dev/unknown/agents/{code-architect,code-explorer,code-reviewer}.md`

### `agent-skills:code-reviewer` / `security-auditor` / `test-engineer` / `web-performance-auditor` (agent)
- **code-reviewer:** review 5-dimensioni (correctness/readability/architecture/security/performance), output Critical/Important/Suggestion + verdict. **security-auditor:** security review pratica (input/auth/data/infra/terze parti/AI), OWASP+LLM Top 10, PoC per Critical/High. **test-engineer:** QA (copertura, test al livello giusto, Prove-It per bug). **web-performance-auditor:** audit CWV (Quick source-scan / Deep Lighthouse+CrUX+DevTools MCP).
- **Attivazione:** subagent. **Costo:** Medio (~98/113/96/185). **Fasi:** review/security/verify/perf.
- **Path:** `cache/addy.../agents/{code-reviewer,security-auditor,test-engineer,web-performance-auditor}.md`

### `code-simplifier:code-simplifier` (agent)
- **Cosa fa:** semplifica codice **recentemente modificato** preservando funzionalità, applicando standard di progetto; opera autonomamente post-edit.
- **Attivazione:** subagent (opus). **Costo:** Medio (~53). **Fasi:** review/refactor.
- **Path:** `cache/.../code-simplifier/1.0.0/agents/code-simplifier.md`

### agent-skills commands (thin wrappers)

### `/build` · `/test` · `/ship` · `/code-simplify` · `/webperf`  · agent-skills
- **`/build`:** invoca incremental-implementation + TDD; default = prossimo task (RED→GREEN→regression→build→commit), `/build auto` = intero piano con un checkpoint.
- **`/test`:** invoca TDD (feature: RED-GREEN-refactor; bug: Prove-It) + browser-testing per problemi browser.
- **`/ship`:** orchestratore **fan-out parallelo** (code-reviewer + security-auditor + test-engineer) → decisione GO/NO-GO + rollback plan obbligatorio.
- **`/code-simplify`:** invoca code-simplification su codice recentemente modificato.
- **`/webperf`:** spawna web-performance-auditor (Quick/Deep).
- **Attivazione:** solo esplicita. **Costo:** Basso/Medio (~45/20/73/23/33). **Fasi:** build/verify/ship/refactor/perf.
- **Path:** `cache/addy.../.claude/commands/{build,test,ship,code-simplify,webperf}.md`

### mattpocock rimanenti

### `mattpocock:ask-matt`  · router/meta
- **Cosa fa:** router/indice su tutti gli skill del repo; descrive il "main flow" idea→ship, gli on-ramps (triage, diagnosing-bugs, wayfinder), la codebase health e gli skill standalone.
- **Attivazione:** solo esplicita. **Procedura:** consultativa. **Costo:** Medio (~79). **Fasi:** supporto (mappa).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/ask-matt/SKILL.md`

### `mattpocock:improve-codebase-architecture`  · architecture upkeep
- **Cosa fa:** scansiona la codebase per "deepening opportunities" (shallow→deep); produce report HTML visuale, poi grilla il candidato scelto.
- **Attivazione:** solo esplicita. **Procedura:** prescrittiva (Explore→HTML report→grilling). **Subagent:** sì (Explore; invoca grilling/domain-modeling/codebase-design). **Costo:** Medio (~72). **Fasi:** codebase health.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/improve-codebase-architecture/SKILL.md`

### `mattpocock:setup-matt-pocock-skills`  · setup (precondition)
- **Cosa fa:** scaffolding una-tantum della config per-repo (issue tracker, label triage, layout domain docs) che gli altri skill engineering assumono. **Prerequisito** da runnare prima del primo flow.
- **Attivazione:** solo esplicita. **Procedura:** prescrittiva (5 fasi). **Costo:** Medio (~117). **Fasi:** setup/precondition.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/setup-matt-pocock-skills/SKILL.md`

### `mattpocock:triage`  · issue management
- **Cosa fa:** muove issue (ed eventuali PR esterne) attraverso una state machine di ruoli triage (2 category + 5 state) fino a brief agent-ready o chiusura.
- **Attivazione:** solo esplicita. **Procedura:** prescrittiva. **Costo:** Medio (~113). **Fasi:** issue management (on-ramp).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/triage/SKILL.md`

### `mattpocock:prototype`  · prototyping
- **Cosa fa:** codice throwaway che risponde a una domanda di design — branch LOGIC (state machine terminale) o UI (variazioni su una route).
- **Attivazione:** auto. **Procedura:** consultativa. **Costo:** Basso (~27). **Fasi:** prototyping/exploration.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/prototype/SKILL.md`

### `mattpocock:research`  · research (background)
- **Cosa fa:** delega legwork di lettura a un background agent che indaga una domanda su fonti primarie e salva i risultati in un file Markdown citato nel repo.
- **Attivazione:** auto. **Procedura:** prescrittiva (3 step al subagent). **Subagent:** sì (background). **Costo:** Basso (~13). **Fasi:** supporto (research).
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/research/SKILL.md`

### `mattpocock:resolving-merge-conflicts`  · git
- **Cosa fa:** risolve conflitti merge/rebase in corso: ispeziona stato, risale alle fonti primarie di ogni hunk, risolve preservando gli intent, runna i check. Mai `--abort`.
- **Attivazione:** auto. **Procedura:** prescrittiva (5 step). **Costo:** Basso (~15). **Fasi:** git.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/resolving-merge-conflicts/SKILL.md`

### `mattpocock:handoff` / `teach` / `writing-great-skills`  · supporto
- **handoff:** compatta la conversazione in un doc di handoff (OS temp) per far ripartire un nuovo agent, suggerendo gli skill da invocare. **teach:** insegna un concetto su più sessioni usando la cwd come workspace stateful (MISSION.md, lessons, records). **writing-great-skills:** reference per scrivere/modificare skill (information hierarchy, leading words, pruning, failure modes).
- **Attivazione:** solo esplicita. **Costo:** Basso/Medio/Medio (~17/141/84). **Fasi:** cross-session / teaching / meta-reference.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/productivity/{handoff,teach,writing-great-skills}/SKILL.md`

### `agent-skills:code-review-and-quality` (+ cmd `/review`)  · plugin agent-skills
- **Cosa fa:** review **a 5 assi** (Correctness/Readability/Architecture/Security/Performance) con **quality gate pre-merge "no exceptions"**; approval standard = "migliora la code health anche se non perfetto"; **structural remedies** (proponi la mossa, non solo il problema); change sizing (~100/300/1000 linee, file size); severity label (Critical/Required/Nit/Optional/FYI); multi-model review pattern; dead-code hygiene; **dependency discipline** (std lib prima, una dep per change, leggi changelog); honesty (no rubber-stamp, no sycophancy). Il più **approfondito** dei review locali.
- **Attivazione:** description (before merge, review code by self/agent/human); cmd `/review` (invoca la skill su staged/recent).
- **Procedura:** prescrittiva (5-step review + checklist).
- **Artefatti in → out:** change → review strutturata con `file:line` + fix + verdict Approve/Request changes.
- **Subagent:** opzionale (multi-model review pattern).
- **Interrogazione utente:** chiede prima di deletare dead code.
- **Directive forti:** "Don't accept 'I'll clean it up later'"; lead with what matters; refactoring deve ridurre complessità non rilocarla; una dep per change.
- **Costo token:** **Molto alto** (396 righe) + riferimenti (`security-checklist.md`, `performance-checklist.md`).
- **Fasi:** 8 code review.
- **Path:** `cache/addy.../skills/code-review-and-quality/SKILL.md`; cmd `cache/addy.../.claude/commands/review.md`

### `code-review:code-review` (cmd)  · plugin code-review
- **Cosa fa:** **pipeline multi-agente per review di PR GitHub**: Haiku per eligibility (chiuso/draft/già-reviewato) → Haiku per CLAUDE.md rilevanti → Haiku per summary → **5 Sonnet paralleli** (CLAUDE.md compliance / bug scan / git blame-history / PR precedenti / commenti nel codice) → Haiku confidence-scoring 0-100 per ogni issue → **filtra <80** → re-check eligibility → **commenta sulla PR via `gh`**. Format fisso, citazioni con full SHA.
- **Attivazione:** slash command `/code-review` (PR-specific).
- **Procedura:** **prescrittiva fortissima** (8 step, 5+ agent paralleli).
- **Artefatti in → out:** PR GitHub → commento di review postato sulla PR.
- **Subagent:** **sì, molti** (Haiku ×4 + Sonnet ×5 paralleli + Haiku ×N scoring) → **costo alto**.
- **Interrogazione utente:** nessuna (pipeline automatica).
- **Directive forti:** filtra issue con confidence <80; non buildare/typecheckare (lo fa la CI); niente emoji; citazione obbligatoria.
- **Costo token:** **Molto alto** (8+ agent, anche se Haiku economici × molti).
- **Fasi:** 8 code review (PR GitHub, cross-session).
- **Path:** `cache/.../code-review/unknown/commands/code-review.md`

> **Mappa F8 (5 entità, sovrapposizione forte):**
> - **diff locale, conciso/read-only** → agente user-level `code-reviewer`.
> - **diff locale, 5-assi approfondito** → `agent-skills:code-review-and-quality`.
> - **diff locale, 2-assi (Standards+Spec) sub-agent paralleli** → `mattpocock:code-review`.
> - **meccanismo dispatch (integrato in SDD)** → `superpowers:requesting-code-review` (+ `receiving-code-review` per la ricezione).
> - **PR GitHub, pipeline multi-agente che posta commenti** → `code-review:code-review` (cmd).
> - (agent `feature-dev:code-reviewer`, `agent-skills:code-reviewer`, `code-simplifier` — vedi long-tail).

---

## Fase 9 — Consolidamento della documentazione

### `consolidate-specs` (user)  · `~/.claude/skills/`
- **Cosa fa:** "consolidation pass" **formale** (`document`/`severance`) su spec/design doc: riallinea il documento al codice, ricolloca il rationale storico in ADR, consegna le asserzioni non risolvibili a una persona via sezione `## To be confirmed`, o recide i riferimenti inbound a un documento escluso. 6 dispositions + precedenza; gate (coverage/scope/bound/removal-authorization); tier assignment (code-verifiable/intent-ambiguous/external→escalate). **Mai mid-implementation.**
- **Attivazione:** description (feature/epic completion, entry in brainstorming su area toccata, phase-one di exclusion).
- **Procedura:** **prescrittiva fortissima** (10-step, gate che bloccano).
- **Artefatti in → out:** spec/design doc + code → documento realignato + ADR + `## To be confirmed` + record nel review unit + intake.
- **Subagent:** nessuno (mai parallelizzato, nemmeno cross-unit).
- **Interrogazione utente:** l'arbitration è un atto umano asincrono (la persona "rule" nell'intake).
- **Directive forti:** "edit the sentence; never append a revision"; "Never resolve a doc-vs-code divergence yourself" (l'agent osserva, non risolve — allinea alle `documentation-lifecycle-rules.md`); freezing whole-unit.
- **⚠ Dipendenze non soddisfatte:** richiede un **codebase knowledge graph come floor** (slot `TARGET_SET_SCRIPT`) e slot non valorizzati (`INTAKE_PATH`/`INTAKE_FORMAT`, `RECORD_PATH`, ecc. = "O7/O10 unfilled"). Senza graph → "declared scope degrades to self-report". Il graph era **Graphify (ora rimosso)**. **Skill non shippable as controlled** (placeholder caps).
- **Costo token:** **Molto alto** (procedura + gate mentali; ~295 righe).
- **Fasi:** 9 doc consolidation (spec/design).
- **Path:** `~/.claude/skills/consolidate-specs/SKILL.md`

### `consolidate-comments` (user)  · `~/.claude/skills/`
- **Cosa fa:** "consolidation pass" sui **commenti in-code**: classifica ogni unit contro il codice, cancella solo ciò che un estraneo competente ricostruirebbe dal solo file (regenerability test), freeze+escalate tutto il resto (contraddizioni, non verificabili, storici→ADR). Nessun marker nel sorgente.
- **Attivazione:** description (feature/epic completion, entry brainstorming su area toccata). **Mai mid-implementation.**
- **Procedura:** **prescrittiva fortissima** (7 dispositions + precedenza, gate).
- **Artefatti in → out:** commenti → removals autorizzate + record + intake; **nessun marker nel file sorgente**.
- **Subagent:** nessuno.
- **Interrogazione utente:** human spot-check dei removed lines.
- **Directive forti:** "delete only what a competent stranger could reconstruct from the file alone"; "Never resolve a comment-vs-code divergence" (laundering di bug in doc); no in-file carrier.
- **⚠ Stesse dipendenze non soddisfatte** di consolidate-specs (graph floor + slot unfilled). Non shippable as controlled.
- **Costo token:** **Molto alto** (~247 righe).
- **Fasi:** 9 doc consolidation (commenti).
- **Path:** `~/.claude/skills/consolidate-comments/SKILL.md`

### `agent-skills:documentation-and-adrs`  · plugin agent-skills
- **Cosa fa:** documenta decisioni (non codice): **ADR** (match-existing-convention prima: location/numbering/headings; template Context/Decision/Alternatives/Consequences; lifecycle PROPOSED→ACCEPTED→SUPERSEDED, non cancellare), inline docs (commenta il *why*), API docs (types/OpenAPI), README, changelog.
- **Attivazione:** description (architectural decision, public API change, shipping feature).
- **Procedura:** consultativa-prescrittiva (template).
- **Artefatti in → out:** decisione → ADR (`docs/decisions/`) + inline/API/README docs.
- **Subagent:** nessuno.
- **Interrogazione utente:** nessuna.
- **Directive forti:** "Don't delete old ADRs"; match existing convention, surface conflict; commenta why non what.
- **Costo token:** **Alto** (288 righe).
- **Fasi:** 9 doc consolidation (decisioni/ADR).
- **Path:** `cache/addy.../skills/documentation-and-adrs/SKILL.md`

### `claude-md-management:claude-md-improver` (+ cmd `revise-claude-md`)  · plugin
- **Cosa fa:** audita e migliora i file **CLAUDE.md**: discovery di tutti i CLAUDE.md, quality assessment (6 criteri: commands/architecture/non-obvious/conciseness/currency/actionability; grade A-F), quality report, poi targeted updates con approvazione (show diff). `revise-claude-md` = cmd per aggiornare CLAUDE.md con i learnings di sessione.
- **Attivazione:** description ("check/audit/update/improve CLAUDE.md", "CLAUDE.md maintenance").
- **Procedura:** prescrittiva (5 fasi; **scrive su CLAUDE.md dopo approvazione**).
- **Artefatti in → out:** CLAUDE.md files → quality report + diff applicati.
- **Subagent:** nessuno; tools Read/Glob/Grep/Bash/Edit.
- **Interrogazione utente:** conferma prima di applicare update.
- **Directive forti:** report BEFORE update; targeted additions only; keep minimal; show diff.
- **Costo token:** **Alto** (179 righe) + riferimenti (`quality-criteria.md`, `templates.md`).
- **Fasi:** 9 doc consolidation (CLAUDE.md); rilevante perché il **CLAUDE.md user-level è vuoto**.
- **Path:** `cache/.../claude-md-management/1.0.0/skills/claude-md-improver/SKILL.md`

---

## Fase 10 — Trasversali (debug, verifica, contesto)

### Debug

### `superpowers:systematic-debugging`  · plugin superpowers
- **Cosa fa:** debug sistematico: Iron Law "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"; 4 fasi (Root Cause Investigation→Pattern Analysis→Hypothesis→Implementation); bisection; trace data flow; **3+ fix fallite → questiona l'architettura** (non fix #4). Usato 14× (2° skill Superpowers più usata).
- **Attivazione:** description ("any bug/test failure/unexpected behavior, before proposing fixes").
- **Procedura:** **prescrittiva fortissima** (Iron Law, fasi obbligatorie).
- **Artefatti in → out:** bug → root cause + failing test + fix.
- **Subagent:** nessuno (riferimenti `root-cause-tracing.md`, `defense-in-depth.md`).
- **Interrogazione utente:** discuti prima di fix #4 se 3+ falliti.
- **Directive forti:** Iron Law; niente fix multipli contemporanei; 3+ fallimenti = problema architetturale.
- **Costo token:** **Molto alto** (283 righe).
- **Fasi:** 10 debug.
- **Path:** `cache/.../superpowers/6.2.0/skills/systematic-debugging/SKILL.md`

### `agent-skills:debugging-and-error-recovery`  · plugin agent-skills
- **Cosa fa:** debug con **Stop-the-Line** + triage checklist (Reproduce→Localize→Reduce→Fix root cause→Guard with test→Verify); pattern per tipo (test/build/runtime failure); **tratta error output come untrusted data** (prompt-injection aware); git bisect; safe fallbacks; instrumentation guidelines.
- **Attivazione:** description (tests fail/build breaks/behavior mismatch/unexpected error).
- **Procedura:** prescrittiva (Stop-the-Line + checklist).
- **Artefatti in → out:** errore → root cause fix + regression test.
- **Subagent:** nessuno.
- **Interrogazione utente:** nessuna.
- **Directive forti:** Stop-the-Line (non pushare oltre un test fallito); fix root cause non sintomo; regression test obbligatorio; error output = data non istruzioni.
- **Costo token:** **Molto alto** (300 righe).
- **Fasi:** 10 debug.
- **Path:** `cache/addy.../skills/debugging-and-error-recovery/SKILL.md`

> `mattpocock:diagnosing-bugs` (134 righe) è il terzo competitor debug (da leggere nel batch long-tail).

### Verifica

### `superpowers:verification-before-completion`  · plugin superpowers
- **Cosa fa:** Iron Law "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"; gate function (IDENTIFY→RUN→READ→VERIFY→CLAIM); tabella claim/requires/not-sufficient; banditi "should/probably/seems" e satisfaction pre-verifica; verifica i report di successo dei subagent via VCS diff.
- **Attivazione:** description ("about to claim work complete/fixed/passing, before commit/PR").
- **Procedura:** **prescrittiva fortissima** (Iron Law, always).
- **Artefatti in → out:** claim → evidence (output comando).
- **Subagent:** nessuno; ma verifica i subagent via diff.
- **Interrogazione utente:** nessuna.
- **Directive forti:** Iron Law; "spirit over letter"; niente claim senza comando fresh; niente fiducia nei report subagent.
- **Costo token:** **Medio** (120 righe).
- **Fasi:** 10 verifica (trasversale, pre-claim/commit).
- **Path:** `cache/.../superpowers/6.2.0/skills/verification-before-completion/SKILL.md`

### Contesto / memoria

### `agent-skills:context-engineering`  · plugin agent-skills
- **Cosa fa:** ottimizza il contesto dell'agent: gerarchia (rules file→spec→source→error→history); strategie di packing (brain dump/selective include/hierarchical summary); confusion management (surface, non scegliere in silenzio); anti-pattern (context **starvation** vs **flooding** >5000 linee); MCP per contesto. Stima <2000 linee/task.
- **Attivazione:** description (new session, quality degrades, switching tasks, setup project).
- **Procedura:** consultativa.
- **Artefatti in → out:** progetto → CLAUDE.md/rules + contesto curato per task.
- **Subagent:** nessuno.
- **Interrogazione utente:** surface ambiguity (A/B/C options).
- **Directive forti:** "more context is NOT always better"; <2000 linee/task; scrivi le regole (se non è scritto non esiste); external data = untrusted.
- **Costo token:** **Alto** (289 righe).
- **Fasi:** 10 contesto/memoria (trasversale; **direttamente rilevante per la strategia token**).
- **Path:** `cache/addy.../skills/context-engineering/SKILL.md`

---

## Fase 7 — Coding / esecuzione dei task

### `superpowers:executing-plans`  · plugin superpowers
- **Cosa fa:** esecuzione inline di un piano in sessione separata con checkpoint: load+review critica del piano, esegui task seguendo gli step bite-sized, verifica, poi **finishing-a-development-branch**. Consiglia subagent-driven-development se il harness li supporta.
- **Attivazione:** description ("written plan to execute in a separate session with review checkpoints"); alternativa inline a subagent-driven-development.
- **Procedura:** prescrittiva (3 step).
- **Artefatti in → out:** plan file → implementazione + hand-off a finishing-a-development-branch.
- **Subagent:** nessuno (esecuzione inline); richiede worktree.
- **Interrogazione utente:** stop e chiedi su blocker/ambiguità; "ask rather than guess".
- **Directive forti:** "Never start implementation on main/master without explicit consent"; stop on blocker, non forzare.
- **Costo token:** **Medio** (64 righe).
- **Fasi:** 7 coding.
- **Path:** `cache/.../superpowers/6.2.0/skills/executing-plans/SKILL.md`

### `superpowers:subagent-driven-development`  · plugin superpowers
- **Cosa fa:** orchestrazione pesante: **fresh implementer subagent per task** + task-reviewer (spec compliance + quality) + final whole-branch reviewer. **Ledger** file (`.superpowers/sdd/<plan>/progress.md`) che sopravvive alla compaction; **model selection** (modello meno potente che regge il ruolo — mechanical=cheap, integration=standard, architecture=capable); **fix-loop max 5 round** (R1-3 resume implementer, R4-5 fresh+capable); "breaker" a R5 (adjudicate o STOP). Script `task-brief`/`review-package`/`sdd-workspace`.
- **Attivazione:** description ("executing plans with independent tasks in the current session").
- **Procedura:** **prescrittiva forte**; **continuous execution** (no check-in tra task).
- **Artefatti in → out:** plan → implementazione + ledger + review packages.
- **Subagent:** **sì, molti** (implementer + reviewer + final reviewer) → **moltiplicatore di contesto ×N**.
- **Interrogazione utente:** solo su conflitti plan-vs-finding e BLOCKED; batched.
- **Directive forti:** "Never dispatch multiple implementation subagents in parallel"; "Always specify the model explicitly"; hand artifacts come file (non paste); controller non fixa mai inline.
- **Costo token:** **Molto alto** (503 righe + N subagent + script).
- **Fasi:** 7 coding (motore di esecuzione principale di Superpowers).
- **Path:** `cache/.../superpowers/6.2.0/skills/subagent-driven-development/SKILL.md`

### `superpowers:dispatching-parallel-agents`  · plugin superpowers
- **Cosa fa:** un agent per dominio-problema indipendente (es. file di test falliti con root cause diverse), dispatch parallelo nello stesso messaggio, prompt focused/self-contained/specific-output, poi review+integrate. Per fallimenti MULTIPLI INDIPENDENTI.
- **Attivazione:** description ("2+ independent tasks without shared state or sequential dependencies").
- **Procedura:** prescrittiva (4 step).
- **Artefatti in → out:** fallimenti multipli → fix integrati.
- **Subagent:** **sì, paralleli** (uno per dominio).
- **Interrogazione utente:** nessuna.
- **Directive forti:** "Dispatch one agent per independent problem domain"; niente agent sovrapposti su shared state.
- **Costo token:** **Medio** (167 righe) + N subagent paralleli.
- **Fasi:** 7 coding (parallelismo), 10 debug.
- **Path:** `cache/.../superpowers/6.2.0/skills/dispatching-parallel-agents/SKILL.md`

### `agent-skills:incremental-implementation` (+ cmd `/build`)  · plugin agent-skills
- **Cosa fa:** slice verticali sottili: implement→test→verify→commit per increment; strategie di slicing (vertical/contract-first/risk-first); Rule 0 Simplicity First; Rule 0.5 Scope Discipline (nota, non fixare out-of-scope); feature flag; rollback-friendly. È la disciplina di esecuzione della Fase 4 di spec-driven-development.
- **Attivazione:** description (multi-file change, task troppo grande); cmd `/build`.
- **Procedura:** consultativa-prescrittiva (regole).
- **Artefatti in → out:** task → incrementi commit-tati.
- **Subagent:** nessuno diretto.
- **Interrogazione utente:** nessuna (propone task per i "noted but not touching").
- **Directive forti:** Rule 0 simplicity (no premature abstraction); Rule 0.5 scope (no drive-by refactor); "keep it compilable" tra slice.
- **Costo token:** **Alto** (249 righe).
- **Fasi:** 7 coding.
- **Path:** `cache/addy.../skills/incremental-implementation/SKILL.md`

### `superpowers:test-driven-development`  · plugin superpowers
- **Cosa fa:** TDD **dogmatico**: Iron Law "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"; red-green-refactor; se scrivi codice prima del test → **cancellalo e ricomincia** ("delete means delete"); "violating the letter is violating the spirit".
- **Attivazione:** description ("implementing any feature/bugfix, before implementation code").
- **Procedura:** **prescrittiva fortissima** (Iron Law, no eccezioni senza human partner).
- **Artefatti in → out:** feature → test + codice minimo.
- **Subagent:** nessuno.
- **Interrogazione utente:** eccezioni richiedono permesso human partner.
- **Directive forti:** Iron Law; delete code-before-test; no mocks se evitabili; niente "test after".
- **Costo token:** **Molto alto** (320 righe).
- **Fasi:** 7 coding, 10 testing.
- **Path:** `cache/.../superpowers/6.2.0/skills/test-driven-development/SKILL.md`

### `agent-skills:test-driven-development` (+ cmd `/test`)  · plugin agent-skills
- **Cosa fa:** TDD **pragmatico**: red-green-refactor; **Prove-It pattern** (bug → test di riproduzione prima del fix); test pyramid (small/medium/large); DAMP over DRY; real impls > fakes > stubs > mocks; **discover-the-stack-first** (usa i comandi del repo, non `npm test` di default); browser testing via DevTools; subagent per test di riproduzione.
- **Attivazione:** description (any logic/bugfix/behavior change); cmd `/test`.
- **Procedura:** prescrittiva ma pragmatica.
- **Artefatti in → out:** feature/bug → test + fix.
- **Subagent:** opzionale (per repro test isolato).
- **Interrogazione utente:** nessuna.
- **Directive forti:** Prove-It (no fix senza repro test); discover stack prima; preferire real impls.
- **Costo token:** **Molto alto** (398 righe) + riferimenti (`testing-patterns.md`).
- **Fasi:** 7 coding, 10 testing.
- **Path:** `cache/addy.../skills/test-driven-development/SKILL.md`

### `mattpocock:tdd` (+ `implement`)  · plugin mattpocock
- **Cosa fa (`tdd`):** reference del loop red→green: good test = behavior via interfaccia pubblica; **seams pre-concordati con l'utente**; anti-pattern (implementation-coupled, tautological, horizontal slicing → usa vertical); "refactoring belongs to review, non al loop". `implement` è thin orchestrator (implementa spec/ticket, usa `/tdd` ai seams, typecheck+single tests regolari + full suite alla fine, poi `/code-review`, commit).
- **Attivazione:** `tdd` auto-invocabile (trigger "red-green-refactor"); `implement` `disable-model-invocation: true`.
- **Procedura:** consultativa (`tdd`); prescrittiva-minimal (`implement`).
- **Artefatti in → out:** feature → test+codice.
- **Subagent:** nessuno.
- **Interrogazione utente:** `tdd` conferma i seam con l'utente prima di testare.
- **Directive forti:** testa solo a seam pre-concordati; vertical slicing; refactoring fuori dal loop.
- **Costo token:** **Basso/Medio** (36/15 righe).
- **Fasi:** 7 coding, 10 testing.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/tdd/SKILL.md`; `.../implement/SKILL.md`

### `ponytail:ponytail`  · plugin ponytail (SessionStart hook, sempre-on)
- **Cosa fa:** "lazy senior dev": **ladder** (YAGNI → reuse nel codebase → stdlib → native platform → dep installata → one line → minimo che funziona); bug-fix = root cause non sintomo; lascia calibration knobs; per logica non-trivia1 lascia ONE runnable self-check; intensità lite/full/ultra. **ATTIVE EVERY RESPONSE** (drift-prevention).
- **Attivazione:** description (ANY coding task) + SessionStart hook (full di default).
- **Procedura:** prescrittiva (ladder + rules).
- **Artefatti in → out:** codice → codice minimale + `ponytail:` comments per ceiling noti.
- **Subagent:** nessuno.
- **Interrogazione utente:** "ship lazy version + question it in same response".
- **Directive forti:** no unrequested abstractions; deletion over addition; "shortest working diff wins"; never lazy su validation/errore-dati-loss/security/accessibilità.
- **Costo token:** **Alto** (120 righe) ma **sempre-on** (iniettato a ogni risposta via hook) → costo continuo.
- **Fasi:** trasversale (tutte le fasi di coding/design/review).
- **Path:** `cache/ponytail/ponytail/4.8.4/skills/ponytail/SKILL.md`

---

## Fase 8 — Code review (single-step e multi-step / cross-session)

### Agente `code-reviewer`  · user-level
- **Cosa fa:** review del `git diff` su 4 assi (Correctness/Security/Architecture/Maintainability); solo issue su cui è confidente, più severe prima, con `file:line` + fix concreto; salta style nits.
- **Attivazione:** description "Use proactively at the end of an implementation phase, before work is declared done".
- **Procedura:** consultativa-read-only; model `fable`; tools Read/Grep/Glob/Bash.
- **Artefatti in → out:** diff → ranked issues (no file).
- **Subagent:** è un subagent (contesto isolato).
- **Interrogazione utente:** nessuna.
- **Directive forti:** "Report only confident issues"; "If clean, say so in one line".
- **Costo token:** **Basso** (16 righe) → contesto isolato.
- **Fasi:** 8 code review.
- **Path:** `~/.claude/agents/code-reviewer.md`

### `superpowers:requesting-code-review`  · plugin superpowers
- **Cosa fa:** dispatch del code-reviewer **subagent** con contesto precisely crafted (DESCRIPTION/PLAN_OR_REQUIREMENTS/BASE_SHA/HEAD_SHA); **mai review inline** (brucia il context window del coordinator); act on Critical/Important; push back se sbagliato. È il meccanismo di review usato da subagent-driven-development.
- **Attivazione:** description ("completing tasks/major features/before merging").
- **Procedura:** prescrittiva.
- **Artefatti in → out:** diff SHAs → findings del reviewer subagent.
- **Subagent:** **sì** (code-reviewer subagent con template `code-reviewer.md`).
- **Interrogazione utente:** nessuna (dispatch).
- **Directive forti:** "Review early, review often"; niente review inline; niente session history al reviewer.
- **Costo token:** **Medio** (95 righe) + subagent.
- **Fasi:** 8 code review.
- **Path:** `cache/.../superpowers/6.2.0/skills/requesting-code-review/SKILL.md`

### `superpowers:receiving-code-review`  · plugin superpowers
- **Cosa fa:** **come ricevere** feedback di review con rigore tecnico, non agreement performatica: READ→UNDERSTAND→VERIFY→EVALUATE→RESPOND→IMPLEMENT; **mai** "you're absolutely right!/great point!/thanks"; YAGNI check su feature "professional"; push back con reasoning tecnico; implementa un item alla volta testando.
- **Attivazione:** description ("receiving code review feedback, before implementing suggestions").
- **Procedura:** prescrittiva (response pattern + forbidden responses).
- **Artefatti in → out:** feedback → fix verificati.
- **Subagent:** nessuno.
- **Interrogazione utente:** chiedi chiarimenti sugli item poco chiari prima di implementare.
- **Directive forti:** no gratitude performatica; verifica contro codebase prima di implementare; push back se tecnicamente sbagliato.
- **Costo token:** **Alto** (205 righe).
- **Fasi:** 8 code review (lato ricezione).
- **Path:** `cache/.../superpowers/6.2.0/skills/receiving-code-review/SKILL.md`

### `mattpocock:code-review`  · plugin mattpocock
- **Cosa fa:** review **a due assi** (Standards: conformità agli standard documentati del repo + smell baseline Fowler; Spec: fedeltà a issue/PRD) in **sub-agent paralleli**, aggregati side-by-side **senza reranking**. Pin del fixed-point, detection della sorgente spec, smell baseline (12 smell). Niente merge degli assi.
- **Attivazione:** auto-invocabile (description: "review a branch/PR/WIP/changes since X"). Richiede `/setup-matt-pocock-skills`.
- **Procedura:** prescrittiva (5 step).
- **Artefatti in → out:** fixed-point..HEAD → report Standards + Spec side-by-side.
- **Subagent:** **sì, 2 paralleli** (general-purpose).
- **Interrogazione utente:** chiede fixed-point e sorgente spec se mancante.
- **Directive forti:** repo standard override baseline; non rerank tra assi; sotto 400 words per sub-agent.
- **Costo token:** **Medio** (89 righe) + 2 subagent paralleli.
- **Fasi:** 8 code review.
- **Path:** `cache/.../mattpocock-skills/1.2.0/skills/engineering/code-review/SKILL.md`

> **Frame F8:** l'agente user-level `code-reviewer` (conciso, read-only) è lo stile-base. `requesting-code-review` è il **meccanismo** (dispatch subagent, integrato in subagent-driven-development). `mattpocock:code-review` è il più **strutturato** (due assi paralleli). `receiving-code-review` disciplina il lato ricezione. Manca all'appello `agent-skills:code-review-and-quality` + cmd `/review`/`code-review` (Batch successivo).
