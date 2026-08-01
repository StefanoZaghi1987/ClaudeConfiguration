# 30 — Conflitti e sovrapposizioni (Fase 3)

---

## 1. Matrice di collisione

Solo coppie in cui **entrambi i membri sono attivi oggi**. La colonna *Risoluzione* indica il meccanismo, non solo l'esito.

| # | Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|---|
| 1 | `brainstorming` ↔ `spec-driven-development` | Entrambe producono il documento di spec. `brainstorming` step 6 scrive `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`; `spec-driven-development` Fase 1 scrive uno spec sulle sue sei aree senza path fissato | **Split di ruolo** | `brainstorming` per il *dialogo*, `spec-driven-development` per la *struttura*. Regola di precedenza in `CLAUDE.md` §S2: il documento è uno solo, il template è quello di `spec-driven-development`, il path è quello del contratto. Nessuna disinstallazione |
| 2 | `brainstorming` ↔ `interview-me` | Entrambe interrogano l'utente all'inizio, entrambe una domanda per volta | **Sequenza, non scelta** | `interview-me` a monte (produce l'intento), `brainstorming` a valle (produce il design). Regola `CLAUDE.md` §S1 |
| 3 | `interview-me` ↔ `grilling` ↔ `idea-refine` | **Tre skill rivendicano la stessa frase di trigger.** Vedi §3.1 | `interview-me` | Restringere la description di `idea-refine` rimuovendo "stress-test my plan"; `grilling` resta su "grill" |
| 4 | `brainstorming` ↔ `consolidate-specs` / `consolidate-comments` | Le due `consolidate-*` hanno fra i trigger ammissibili *"entry into brainstorming on an area touched in the past"*, ma `brainstorming` vieta di invocare altre skill. Vedi §2.3 | `brainstorming` (di fatto), **ma è il conflitto sbagliato da vincere** | Le `consolidate-*` non sono comunque eseguibili (§Fase 9 di `20-COMPARISON.md`). Risoluzione a termine: un gate *prima* dell'ingresso in brainstorming, fuori dal HARD-GATE. Vedi `40-TARGET-HARNESS.md` §1.4 |
| 5 | `writing-plans` ↔ `planning-and-task-breakdown` | Entrambe producono un implementation plan, su **path diversi e incompatibili**: `docs/superpowers/plans/YYYY-MM-DD-<feature>.md` vs `tasks/plan.md` + `tasks/todo.md` | `writing-plans` sul documento; `planning-and-task-breakdown` sul metodo | Regola `CLAUDE.md` §S4: un solo plan, path del contratto. `planning-and-task-breakdown` contribuisce grafo delle dipendenze, slicing verticale e sizing, **e non scrive file** |
| 6 | `planning-and-task-breakdown` ↔ Backlog MD | `tasks/todo.md` è un secondo store di task, parallelo a `backlog/tasks/` e senza id, stato, dipendenze o cross-reference | **Backlog MD** | Regola `CLAUDE.md` §S6: `backlog/` è l'unico store di task. `tasks/todo.md` non va mai creato. La giustificazione della riga 148 (*"expected by the `/build` command"*) è morta: `/build` era un command del plugin `agent-skills`, disabilitato |
| 7 | `subagent-driven-development` ↔ `executing-plans` | Entrambe eseguono un plan | `subagent-driven-development` | **Auto-risolto**: `executing-plans` riga 14 si declassa da sé — *"If subagents are available, use subagent-driven-development instead of this skill."* Nessun intervento |
| 8 | `subagent-driven-development` ↔ `dispatching-parallel-agents` | Direttive opposte sul parallelismo. Vedi §2.5 | `subagent-driven-development` in fase 7 | Restringere `dispatching-parallel-agents` al debugging multi-dominio. Regola `CLAUDE.md` §S7 |
| 9 | `code-review-and-quality` ↔ `code-reviewer` (agent) ↔ `task-reviewer` di SDD | Tre esecutori per la fase 8, che possono sparare sullo stesso diff | **Split per momento** | `task-reviewer` in-loop, `code-reviewer` standalone, `code-review-and-quality` **come rubrica citata**, non caricata. Regola `CLAUDE.md` §S8 |
| 10 | `code-simplification` ↔ `ponytail-review` ↔ `/simplify` | Tre skill sulla semplificazione, tre filosofie: preservare il comportamento / cancellare e sfidare il requisito / applicare le fix. 3,7k + 0,5k + built-in | `ponytail-review` per il *trovare*, `/simplify` per l'*applicare* | `code-simplification` **DISABILITARE** (spostare a `disable-model-invocation: true`): il suo contributo unico — le 4 trappole della sovra-semplificazione e Chesterton's Fence — va citato nella rubrica, non caricato a ogni turno |
| 11 | `security-and-hardening` ↔ `/security-review` (built-in) | Stesso asse. 5,1k di skill sempre caricata vs uno slash command a costo passivo zero | `/security-review` per l'*esecuzione* | `security-and-hardening` → `disable-model-invocation: true`. Resta consultabile a mano come riferimento |
| 12 | `systematic-debugging` ↔ `diagnosing-bugs` | Stessa fase, trigger quasi identici, gate incompatibili. Vedi §2.4 e §3.2 | `diagnosing-bugs` (87 vs 56) | `systematic-debugging` → `disable-model-invocation: true` dopo aver estratto le sue due sezioni uniche (boundary instrumentation, regola dei 3 fix) in `diagnosing-bugs` |
| 13 | `consolidate-specs` ↔ `documentation-and-adrs` | Entrambe scrivono ADR. `consolidate-specs` rialloca con la disposizione `historical decision → ADR` ma **non definisce il formato dell'ADR**; `documentation-and-adrs` definisce il formato ma non ha bound né record | `documentation-and-adrs` sul formato | Complementari, non concorrenti: `documentation-and-adrs` fornisce il template che `consolidate-specs` presuppone. Da citare esplicitamente quando `consolidate-specs` diventerà eseguibile |
| 14 | `context-engineering` ↔ `claude-md-improver` ↔ `/init` | Tre componenti che toccano `CLAUDE.md`: uno lo descrive, uno lo audita e scrive, uno lo genera da zero | **Split di ruolo** | `context-engineering` → declassare a `disable-model-invocation` (3k per un lavoro una-volta-per-progetto); `claude-md-improver` per la *verifica dopo* la riscrittura; `/init` non usare (genererebbe una descrizione del repo, non le regole di harness) |
| 15 | `writing-great-skills` ↔ `skill-creator` | Entrambe sull'authoring di skill. 50 righe di riferimento vs 327 righe di procedura con eval | Split di ruolo | `writing-great-skills` per i *criteri*, `skill-creator` per gli *eval* quando scriverai `backlog-tasks` |
| 16 | memoria nativa (`~/.claude/projects/…/memory/` + `MEMORY.md`) ↔ `serena` memories (`write_memory`/`read_memory`/`list_memories`) ↔ convenzione `CONTEXT.md` di `diagnosing-bugs` | **Tre sistemi di memoria non coordinati.** Un fatto scritto in uno è invisibile agli altri | memoria nativa | Regola `CLAUDE.md` §S10: la memoria nativa è l'unico store. Non usare `serena.write_memory`. `CONTEXT.md`, se esiste in un progetto, è un artefatto di progetto versionato, non memoria d'agente |
| 17 | `incremental-implementation` ↔ `ponytail` | Entrambe governano *come* si scrive il codice durante la fase 7. `incremental-implementation` Rule 0 (Simplicity First) e `ponytail` ladder rung 1-7 dicono la stessa cosa con parole diverse | `ponytail` (è già iniettato incondizionatamente) | Nessun conflitto sostanziale: `incremental-implementation` mantiene un contributo unico (slicing verticale, feature flag, rollback-friendly, il formato `NOTICED BUT NOT TOUCHING`). Coesistono |
| 18 | `explanatory-output-style` ↔ `ponytail` | Direttive frontalmente opposte sulla prosa. Vedi §2.2 | **Nessuno vince oggi — il conflitto è aperto** | Decisione dell'utente. Vedi §2.2 per le due risoluzioni possibili |
| 19 | `serena` (`initial_instructions` su ogni task di coding) ↔ `context-engineering` (`<2.000 righe di contesto focalizzato per task`) | Il primo carica un manuale a ogni task di coding; il secondo fissa un budget di attenzione | `context-engineering` sul principio | Restringere `serena`: chiamare `initial_instructions` una volta per sessione, non per task. Regola `CLAUDE.md` §S10 |
| 20 | `~/.claude/rules/effort-escalation.md` ↔ `subagent-driven-development` Model Selection | Conflitto numerico diretto sulla scelta del modello per i subagent. Vedi §2.6 | `subagent-driven-development` nel suo dominio | Emendare `effort-escalation.md` con un'eccezione nominata. Vedi §2.6 |

---

## 2. Conflitti di direttive

Casi in cui due componenti attivi si contraddicono a livello di **istruzione imperativa**, non di semplice sovrapposizione funzionale. Per ciascuno: le citazioni verbatim, quale prevale, e la regola scritta che lo garantisce.

### 2.1 `ponytail` vs `writing-plans` — verbosità del piano

| Componente | Direttiva verbatim | Path |
|---|---|---|
| `ponytail` (hook, ogni sessione) | *"Fewest files possible. Shortest working diff wins."* · *"No essays, no feature tours, no design notes. **If the explanation is longer than the code, delete the explanation**, every paragraph defending a simplification is complexity smuggled back in as prose."* | `…/ponytail/4.8.4/skills/ponytail/SKILL.md` righe 61, 68-70 |
| `writing-plans` | *"Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. **Document everything they need to know**"* · *"Every step must contain the actual content an engineer needs… Steps that describe what to do without showing how (**code blocks required for code steps**)"* | `~/.claude/skills/writing-plans/SKILL.md` righe 10, 130-135 |

**Prevale `writing-plans` nella fase 4.** E non serve inventare la giustificazione: `ponytail` la fornisce da sé, alla riga 71-73 — *"Explanation the user explicitly asked for (a report, a walkthrough, per-phase notes) is not debt, give it in full, the rule is only against unrequested prose."* Un implementation plan è per definizione richiesto.

**Regola scritta (`CLAUDE.md` §S4):**
> An implementation plan is requested output, not unrequested prose. The ponytail brevity rule does not apply to plan documents, spec documents, ADRs, or review reports. It applies to code, commit messages, and conversational replies.

### 2.2 `explanatory-output-style` vs `ponytail` — obbligo di prosa esplicativa

| Componente | Direttiva verbatim |
|---|---|
| `explanatory-output-style` (hook `SessionStart`) | *"**before and after writing code, always provide** brief educational explanations about implementation choices using `★ Insight`… [2-3 key educational points]"* |
| `ponytail` (hook `SessionStart`) | *"Code first. Then **at most three short lines**: what was skipped, when to add it. No essays, no feature tours, **no design notes**."* |

Il primo obbliga blocchi esplicativi **prima e dopo ogni scrittura di codice**; il secondo li vieta e ne prescrive la cancellazione. Entrambi sono iniettati dallo stesso evento `SessionStart` e sono attivi **contemporaneamente in questa sessione** — la prova è questo documento, prodotto sotto entrambi.

**Nessuno dei due prevale per costruzione: sono due plugin abilitati che si contraddicono, e la contraddizione va risolta scegliendo.**

Due risoluzioni, entrambe legittime:

- **A — Disabilita `explanatory-output-style`.** Coerente con l'obiettivo di riduzione dei token: gli `★ Insight` sono output aggiuntivo su ogni turno di codice. `ponytail` resta come governo dello stile.
- **B — Mantieni entrambi e scrivi la regola di ambito.** Gli `★ Insight` valgono nelle fasi 1-6 e 9 (dove l'output *è* prosa e la spiegazione ha valore didattico); `ponytail` governa le fasi 7-8 (dove l'output è codice).

**Raccomandazione: A.** L'output style è pensato per chi impara un codebase; tu sei l'autore della configurazione che stai leggendo. Il costo è ricorrente, il beneficio è una-volta.

**Regola scritta se scegli B (`CLAUDE.md` §S11):**
> `★ Insight` blocks apply to document-producing phases (spec, plan, review report, documentation). During implementation, ponytail's output rule governs: code first, at most three lines after.

### 2.3 `brainstorming` HARD-GATE vs i trigger di `consolidate-*`

| Componente | Direttiva verbatim |
|---|---|
| `brainstorming` | *"`<HARD-GATE>` Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it."* · *"**The terminal state is invoking writing-plans.** Do NOT invoke frontend-design, mcp-builder, or any other implementation skill."* · *"**Do NOT invoke any other skill.** writing-plans is the next step."* |
| `consolidate-specs` / `consolidate-comments` | Trigger ammissibile: *"**entry into brainstorming on an area touched in the past** (`S35`)"* — e nel caso brainstorming-time, *"a standalone commit and, where review requires it, its own pull request"* |

`brainstorming` chiude la porta a ogni altra skill; le `consolidate-*` sono progettate per girare esattamente **nel momento in cui quella porta si apre**.

**Prevale `brainstorming` di fatto**, perché il HARD-GATE è testuale e imperativo e le `consolidate-*` non sono comunque eseguibili. **Ma è il conflitto sbagliato da vincere**: la conseguenza è che un'area toccata in passato entra in brainstorming con la documentazione non riallineata, che è precisamente il failure mode che le `consolidate-*` esistono per prevenire.

**Regola scritta (`CLAUDE.md` §S9):** la risoluzione non è nell'ordine di precedenza, è nel **collocare il gate fuori dal recinto**:
> Documentation realignment on a previously-touched area happens BEFORE brainstorming is invoked, as its own step with its own commit. Once brainstorming starts, its terminal state is writing-plans and no other skill is invoked.

### 2.4 `systematic-debugging` vs `diagnosing-bugs` — due gate sullo stesso momento

| Componente | Gate verbatim |
|---|---|
| `systematic-debugging` | *"`NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`"* · *"**You MUST complete each phase before proceeding to the next.**"* · *"Violating the letter of this process is violating the spirit of debugging."* · *"**Don't skip when:** Issue seems simple / You're in a hurry / Manager wants it fixed NOW"* |
| `diagnosing-bugs` | *"Skip phases only when explicitly justified."* · *"If you catch yourself reading code to build a theory before this command exists, **stop**… **No red-capable command, no Phase 2.**"* |

Non sono la stessa regola. `systematic-debugging` blocca sul **fix** e nega le esenzioni; `diagnosing-bugs` blocca sull'**ipotesi** e ammette esenzioni motivate. Un agente che carica entrambe ha due gate in punti diversi della stessa sequenza, e il più rigido dei due ("You MUST complete each phase") vincerebbe per forza retorica anche quando l'altro è più efficace.

**Prevale `diagnosing-bugs`** (87 vs 56): il suo gate è **checkable** (un comando nominato, già eseguito, con invocazione e output incollati) dove l'altro è esortativo.

**Regola scritta (`CLAUDE.md` §S12):**
> For any bug, test failure, or performance regression, `diagnosing-bugs` is the sole entry point. Its Phase 1 gate — a named, already-run, red-capable command — must be satisfied before any hypothesis. Escalate to architectural discussion when three fixes have failed.

La seconda frase preserva la regola dei 3 di `systematic-debugging`, che è il suo contributo unico.

### 2.5 `subagent-driven-development` vs `dispatching-parallel-agents` — parallelismo

| Componente | Direttiva verbatim |
|---|---|
| `subagent-driven-development` | *"**Never dispatch multiple implementation subagents in parallel (conflicts).**"* |
| `dispatching-parallel-agents` | *"**Core principle:** Dispatch one agent per independent problem domain. Let them work concurrently."* · *"Multiple dispatch calls in one response = parallel execution."* |
| Workflow dell'utente (brief) | *"**Coding** — esecuzione delle task, potenzialmente con subagent in parallelo"* |

Il tuo workflow chiede il parallelismo; il vincitore della fase 7 lo vieta. Il divieto non è arbitrario: due implementer concorrenti sullo stesso working tree producono conflitti, e SDD dispaccia sempre in un worktree isolato **per plan**, non per task.

**Prevale `subagent-driven-development` nella fase 7.** Il parallelismo che il tuo workflow desidera è ottenibile per un'altra strada, e va detto esplicitamente: **worktree separati per plan indipendenti**, non subagent concorrenti sulla stessa task sequence. Il tool `EnterWorktree` è disponibile nativamente in questa sessione.

**Regola scritta (`CLAUDE.md` §S7):**
> During task execution, implementers are dispatched one at a time — never concurrently. Parallelism comes from independent plans in separate worktrees, not from concurrent implementers on one plan. `dispatching-parallel-agents` applies only to investigation of multiple independent failures, never to implementation.

### 2.6 `effort-escalation.md` vs `subagent-driven-development` Model Selection

| Componente | Direttiva verbatim |
|---|---|
| `~/.claude/rules/effort-escalation.md` (regola utente, sempre in contesto) | *"For bulk exploration or lookup work delegated to subagents, **prefer the `haiku` model**."* |
| `subagent-driven-development` | *"**Turn count beats token price.** Wall-clock and context cost scale with how many turns a subagent takes, and the cheapest models routinely take 2-3× the turns on multi-step work — costing more overall. **Use a mid-tier model as the floor for reviewers and for implementers working from prose descriptions.**"* |

Conflitto reale e concreto: la tua regola dice haiku, la skill dice mid-tier come *pavimento*. Non è una differenza di stile: sono due raccomandazioni numeriche incompatibili sullo stesso dispatch.

**Entrambe hanno ragione nel proprio dominio**, e i domini sono distinguibili: la tua regola parla di *bulk exploration or lookup*, la skill parla di *reviewer e implementer da descrizioni in prosa*. Sono lavori diversi.

**Prevale `effort-escalation.md` sull'esplorazione, `subagent-driven-development` su implementer e reviewer.** L'emendamento da applicare alla regola (una riga aggiunta, non una riscrittura):

```diff
 For bulk exploration or lookup work delegated to subagents, prefer the `haiku` model.
+Implementers and reviewers are not exploration: use a mid-tier model as the floor there,
+per subagent-driven-development's Model Selection. Always set `model:` explicitly —
+an omitted model inherits the session's, which is `opus[1m]`.
```

L'ultima frase è la più importante dell'intero documento per il tuo obiettivo sui token. Vedi §4.1.

### 2.7 `code-review-and-quality` vs `doubt-driven-development` — calibrazione opposta

| Componente | Direttiva verbatim |
|---|---|
| `code-review-and-quality` | *"**The approval standard:** Approve a change when it definitely improves overall code health, even if it isn't perfect… Don't block a change because it isn't exactly how you would have written it."* |
| `doubt-driven-development` | *"The reviewer's prompt **must be adversarial**. Framing decides the answer… **Do NOT validate. Do NOT summarize.** Find issues, or state explicitly that you cannot find any after thorough examination."* |

Una calibra verso l'approvazione, l'altra verso la confutazione. `doubt-driven-development` è consapevole del conflitto e lo risolve nel proprio testo, riga 110: *"**The adversarial prompt above takes precedence over the persona's default response shape.** Personas like `code-reviewer` are written to produce balanced verdicts with both strengths and weaknesses; doubt-driven needs issues-only output. Paste the adversarial prompt verbatim into the invocation so it overrides the persona's default."*

**Nessuna regola nuova serve.** Le due calibrazioni appartengono a due decisioni diverse: *questo cambiamento può essere mergiato?* (approvazione) vs *questa affermazione è vera?* (confutazione). La risoluzione è già scritta nella skill che ne ha bisogno.

### 2.8 Regola 5 di `documentation-lifecycle-rules.md` vs la sezione `## To be confirmed`

| Componente | Direttiva verbatim |
|---|---|
| Regola 5 (sempre in contesto) | *"**Never append a revision to a spec. Edit the sentence.**"* |
| `consolidate-specs` | La sezione `## To be confirmed` è **scritta in append** al documento, e ne dichiara l'eccezione: *"It is excepted from *documents describe current state only* on state-versus-open-work grounds, not metadata grounds: open work assigned to a person is not current state, and it earns its place because the next reader must see it (`S63`)."* |

**Non è un conflitto: è un'eccezione nominata e argomentata.** La registro qui perché letta senza il companion sembra una violazione della regola 5, e un agente che applica la regola 5 alla lettera cancellerebbe la sezione. La regola 5 riguarda le *revisioni* (riscrivere aggiungendo "aggiornato il...", "vedi anche la nuova versione"); `## To be confirmed` porta *lavoro aperto assegnato a una persona*, che non è stato corrente.

**Regola scritta (`CLAUDE.md` §S9):**
> The `## To be confirmed` section is the one admissible append to a spec: it carries open work assigned to a person, not a revision. Resolve its items by deletion — the item becomes a sentence in the body, moves to an ADR, or disappears. Never annotate an item with its resolution.

### 2.9 Regola 11 di `documentation-lifecycle-rules.md` — direttiva senza destinazione

| Componente | Stato |
|---|---|
| Regola 11 (sempre in contesto) | *"Append every flag to `~/.claude/escalations.md`, one dated line naming the file and the divergence."* |
| Il file | **`~/.claude/escalations.md` non esiste** (verificato: listing completo di `~/.claude`) |
| `~/.claude/documentation-lifecycle.md` riga 41 | *"The escalation intake — path, format, churn-stable reference scheme … **Rule line eleven resolves to a guess; the flag obligation has no destination**; read-before-append has no key, so the intake has no memory"* |
| `~/.claude/documentation-lifecycle.md` riga 580 | *"**OPEN — `O7`.** The concrete path, format and churn-stable unit reference scheme of the escalation intake … settled as a prerequisite of the first shipment (`S157`, `S167`)."* |
| `consolidate-comments` riga 224 | *"Appending is done by a **script**, invoked by this skill. It is never a hand-written note in chat (`S119`)."* — lo script non esiste |

**Non è una confusione con `effort-escalation.md`**, che riguarda i livelli di effort del modello e non ha alcun rapporto con l'intake. La regola 11 ha nominato un path concreto **prima** che la decisione `O7` fosse presa, e la spec lo registra già come lacuna nota.

**Questa è la divergenza che la regola 10 mi impone di segnalare e non risolvere.** Non la risolvo: la registro qui, e la registro nel posto che la regola 11 indicherebbe se esistesse. La flag è già presente nel documento che la possiede — `documentation-lifecycle.md` come `O7` — quindi l'obbligo di segnalazione è soddisfatto a monte. Ciò che manca è la **decisione**, che è tua e non mia.

Opzioni per chiudere `O7` in `40-TARGET-HARNESS.md` §3.6.

---

## 3. Trigger ambigui

Coppie o gruppi le cui `description` sono abbastanza simili da rendere la scelta del modello non deterministica.

### 3.1 Tre skill rivendicano la stessa frase — il caso più netto

| Skill | Frase di trigger nella description (verbatim) |
|---|---|
| `interview-me` | *"when the user explicitly invokes ('interview me', 'grill me', 'are we sure?', **'stress-test my thinking'**)"* |
| `grilling` | *"Use when the user **wants to stress-test their thinking**, or uses any 'grill' trigger phrases."* |
| `idea-refine` | *"Triggers on 'ideate', 'refine this idea', or **'stress-test my plan'**."* |

`interview-me` rivendica anche `'grill me'`, che è la frase di `grilling`. Tre skill, un campo semantico, nessun criterio di disambiguazione nelle description. Il modello sceglierà in modo non riproducibile.

**Risoluzione:** i tre lavori *sono* diversi e le description devono dirlo.
- `interview-me` → estrarre l'**intento** (prima che esista un artefatto). Rimuovere `'grill me'` dalla lista.
- `grilling` → interrogare **su un artefatto o una decisione esistente**, con l'umano nel loop. Mantiene "grill".
- `idea-refine` → **divergere** su un'idea vaga. Rimuovere "stress-test my plan".

Diff in `40-TARGET-HARNESS.md` §6.2.

### 3.2 Le altre ambiguità

| Gruppo | Description in collisione | Perché il modello non può scegliere | Risoluzione |
|---|---|---|---|
| `systematic-debugging` / `diagnosing-bugs` | *"any bug, test failure, or unexpected behavior, before proposing fixes"* vs *"reports something broken/throwing/failing/slow"* | Insiemi di trigger praticamente coincidenti | `systematic-debugging` → `disable-model-invocation: true`. L'ambiguità sparisce per costruzione |
| `brainstorming` / `spec-driven-development` / `interview-me` | *"before any creative work"* vs *"starting a new project, feature, or significant change"* vs *"an ask is underspecified"* | Tutte tre sparano sul primo messaggio di una feature nuova | Ordine di precedenza esplicito in `CLAUDE.md` §S1-S2 (l'unica risoluzione possibile: le tre servono davvero, in sequenza) |
| `writing-plans` / `planning-and-task-breakdown` | *"when you have a spec or requirements for a multi-step task, before touching code"* vs *"when you have a spec or clear requirements and need to break work into implementable tasks"* | Quasi identiche parola per parola | `CLAUDE.md` §S4 nomina `writing-plans` come proprietario del documento; `planning-and-task-breakdown` come metodo, invocata da lì |
| `code-review-and-quality` / `code-simplification` / `ponytail` | *"before merging any change"* vs *"when reviewing code that has accumulated unnecessary complexity"* vs *"ANY coding task: writing, adding, refactoring, fixing, reviewing, or designing code"* | La description di `ponytail` rivendica **ogni** task di coding, incluso `reviewing`. Non è un'ambiguità: è un'appropriazione | `code-simplification` → `disable-model-invocation`. `ponytail` resta ma il suo dominio va delimitato in `CLAUDE.md` §S8 |
| `incremental-implementation` | *"any feature or change that touches more than one file"* | Trigger così ampio che spara su quasi ogni task di coding, anche quando `subagent-driven-development` è già il controller | Restringere la description a *"when implementing a task from a plan"*. Diff in §6.2 |
| `documentation-and-adrs` / `consolidate-specs` | *"shipping features"* vs *"Completion of a feature or epic"* | Stesso momento del ciclo | Non è problematico: coprono lavori disgiunti (produrre vs riallineare). Nessun intervento |
| `context-engineering` | *"when starting a new session"* | Spara all'inizio di qualunque sessione, dove non serve quasi mai | → `disable-model-invocation` |

---

## 4. Ridondanze di costo

### 4.1 La ridondanza più costosa: `model:` omesso

Non è una ridondanza di contesto, è un moltiplicatore di prezzo, e supera tutte le altre voci di questa sezione messe insieme.

- `~/.claude/settings.json` → `"model": "opus[1m]"`.
- `subagent-driven-development` dispaccia **da 2 a 12 subagent per task** (1 implementer + 1 task reviewer + fino a 5 coppie fix/re-review), più 3 nella review finale.
- La skill lo dice in grassetto: *"**Always specify the model explicitly when dispatching a subagent.** An omitted model inherits your session's model — often the most capable and most expensive — which silently defeats this section."*

Su un plan da 8 task con un fix round medio, sono ~30 dispatch. Con `model:` omesso girano tutti su Opus 1M; con il routing della skill applicato, la maggioranza sono transcription-plus-testing su tier economico e solo la review finale è sul modello più capace. **È il singolo intervento con il rapporto risparmio/rischio più alto dell'intera migrazione**, e non richiede di modificare nessuna skill: richiede una regola in `CLAUDE.md` e la disciplina di applicarla.

### 4.2 Lo stesso spec caricato sei volte nella catena

| # | Chi lo carica | Cosa carica |
|---|---|---|
| 1 | `brainstorming` / `spec-driven-development` | Lo scrive |
| 2 | `spec-reviewer` (agent) | Lo legge per intero, contesto isolato |
| 3 | `writing-plans` | Lo legge per estrarre le Global Constraints e la copertura |
| 4 | `implementation-plan-reviewer` (agent) | Lo legge per verificare la copertura del plan |
| 5 | La creazione delle task Backlog MD | Lo legge per i cross-reference |
| 6 | `task-reviewer` di SDD, una volta per task | Riceve una **copia verbatim** delle Global Constraints |

I carichi 2 e 4 sono in **contesti isolati** e quindi non si sommano nel contesto principale: sono corretti così. Il carico 6 è per costruzione una copia, e SDD lo giustifica (*"the constraints block is for what THIS project's spec demands"*). Il vero spreco è **3 + 5**: due letture integrali nello stesso contesto per due estrazioni diverse.

**Rimedio:** le Global Constraints, una volta estratte da `writing-plans`, vivono **nel plan**. La creazione delle task legge il plan, non lo spec. Un carico invece di due.

### 4.3 Tre skill sulla stessa review, 12,9k token

| Skill | Token | Può sparare sullo stesso diff? |
|---|---|---|
| `code-review-and-quality` | 4,1k | Sì (*"before merging any change"*) |
| `code-simplification` | 3,7k | Sì (*"when reviewing code that has accumulated unnecessary complexity"*) |
| `security-and-hardening` | 5,1k | Sì (*"when handling user input, authentication, data storage"*) |

Nel caso peggiore, un diff che tocca un endpoint carica **12,9k token di rubriche** prima di guardare una riga di codice. Il `task-reviewer` di SDD raggiunge una criticità superiore con un prompt template di ~2,3k, perché la sua rubrica è *scritta nel prompt del reviewer*, non caricata nel contesto del controller.

**Rimedio:** `code-simplification` e `security-and-hardening` a `disable-model-invocation`; `code-review-and-quality` citata come rubrica nei prompt dei reviewer invece di essere caricata.

### 4.4 Due skill di debugging, un momento

3k (`systematic-debugging`) + 1,1k (`diagnosing-bugs`) + fino a 4,4k di reference della prima. Con `diagnosing-bugs` come unico entry point: 1,1k. **Risparmio ~6,3k per sessione di debugging**, con il vincitore che ha il punteggio più alto.

### 4.5 Testo duplicato letteralmente in due skill

`dispatching-parallel-agents` riga 10 e `subagent-driven-development` riga 10 contengono **lo stesso paragrafo**:

> *"You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed at their task. They should never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work."*

Entrambe possono essere caricate nella stessa sessione di fase 7. È il failure mode che `writing-great-skills` chiama **duplication**: *"the same meaning in more than one place. Costs maintenance and tokens, and inflates a meaning's prominence on the ladder past its real rank."*

### 4.6 Carichi incondizionati per turno o per sessione

| Voce | Frequenza | Costo |
|---|---|---|
| `ponytail` hook `SessionStart` | ogni startup, resume, clear, compact | ~1,3k token |
| `ponytail` hook `SubagentStart` | **ogni subagent** | propagazione, ~ND token per subagent |
| `ponytail` hook `UserPromptSubmit` | **ogni prompt** | esecuzione Node, timeout 5 s (costo wall-clock) |
| `explanatory-output-style` hook `SessionStart` | ogni sessione | ~0,3k token + output aggiuntivo su ogni turno di codice |
| Istruzioni MCP `serena` (*"CRITICAL: Before starting to work on a coding task, call `initial_instructions`"*) | ogni task di coding | manuale, dimensione ND |
| Istruzioni MCP `backlog` (*"At the beginning of each session, list the available resources"*) | ogni sessione | **costo pagato, zero tool ottenuti** — il server non espone strumenti |
| 21 description di skill model-invoked | **ogni turno** | 5,4k token (misurato via `/context`) |

Il caso `backlog` è puro spreco: l'istruzione è iniettata, il server è configurato, i tool sono zero. Vedi `50-MIGRATION.md`.

### 4.7 Nove path per gli artefatti della stessa catena

| Path | Chi lo prescrive | Stato |
|---|---|---|
| `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` | `brainstorming` | Attivo; nome di un plugin disabilitato |
| `docs/superpowers/plans/YYYY-MM-DD-<feature>.md` | `writing-plans` | Attivo; idem |
| `tasks/plan.md` | `planning-and-task-breakdown`, `spec-driven-development` | Da abolire |
| `tasks/todo.md` | idem | Da abolire (collide con Backlog MD) |
| `docs/ideas/[idea-name].md` | `idea-refine` | Solo su conferma |
| `docs/intent/[topic].md` | `interview-me` | Solo su conferma |
| `docs/decisions/ADR-NNN-*.md` | `documentation-and-adrs` | Default, sovrascrivibile dalla convenzione del repo |
| `backlog/tasks/task-<N> - <Title>.md` | CLI `backlog` | **Fissato dallo strumento** |
| `.superpowers/sdd/<plan>/` | `subagent-driven-development` | Git-ignored, cancellato alla fine |

Nove destinazioni, di cui due da abolire, due con un nome fuorviante e una sola imposta da uno strumento reale. Una catena tracciabile richiede path stabili e citabili: contratto in `40-TARGET-HARNESS.md` §3.

---

## 5. Riferimenti pendenti — inventario completo

Non sono conflitti, sono rotture. Ogni riga è un pointer presente in una skill attiva verso qualcosa che non esiste su questo disco.

| Skill (attiva) | Riga | Punta a | Stato |
|---|---|---|---|
| `spec-driven-development` | 169 | *"the F7 chain in `~/.claude/CLAUDE.md`"* | **File di 0 byte** |
| `spec-driven-development` | 169 | `superpowers:test-driven-development` | Skill non installata **e** prefisso non risolvibile |
| `spec-driven-development` | 169 | `superpowers:subagent-driven-development`, `superpowers:executing-plans` | Esistono senza prefisso; con il prefisso non risolvono |
| `spec-driven-development` | 143 | *"the `/plan` command convention"* | Command non esistente |
| `planning-and-task-breakdown` | 148 | *"the `/build` command"* | Command non esistente |
| `planning-and-task-breakdown` | 234 | `references/definition-of-done.md` | File non esistente |
| `incremental-implementation` | 249 | `references/definition-of-done.md` | File non esistente |
| `incremental-implementation` | 41 | `git-workflow-and-versioning` | Skill non installata |
| `incremental-implementation` | 201 | *"the test-driven-development skill's Discover the Stack First section"* | Skill non installata |
| `doubt-driven-development` | 46, 229 | `references/orchestration-patterns.md` | File non esistente |
| `doubt-driven-development` | 108 | `agents/` (relativo alla skill) | Directory non esistente; risolve di fatto a `~/.claude/agents/` |
| `doubt-driven-development` | 226-228 | `source-driven-development`, `test-driven-development`, `debugging-and-error-recovery` | Non installate |
| `code-review-and-quality` | 351-352 | `references/security-checklist.md`, `references/performance-checklist.md` | File non esistenti |
| `code-review-and-quality` | 79 | `performance-optimization` | Skill non installata |
| `security-and-hardening` | 77, 303, 427 | `references/security-checklist.md` | File non esistente; la riga 303 lo cita come sede di una **matrice** di versioni di package manager, contenuto non recuperabile |
| `subagent-driven-development` | 413 | `finishing-a-development-branch` | Skill non installata; comportamento sostitutivo fornito in prosa alle righe 422-423 |
| `wayfinder` | 25 | `/setup-matt-pocock-skills` | Command non esistente |
| `wayfinder` | 77, 115 | subagent `/research` | Non esistente |
| `wayfinder` | 111, 112, 124 | `/domain-modeling` | Non esistente |
| `diagnosing-bugs` | 82 | `/improve-codebase-architecture` | Non esistente |
| `brainstorming` | 109 | `elements-of-style:writing-clearly-and-concisely` | Non installata (mitigato da *"if available"*) |
| `consolidate-specs` / `consolidate-comments` | passim | `TARGET_SET_SCRIPT` + 6 script di gate + script di append all'intake | Nessuno esiste |
| Regola 11 di `documentation-lifecycle-rules.md` | — | `~/.claude/escalations.md` | Non esistente; aperto come `O7` |

**Il pattern.** Diciassette dei ventitré pointer rotti puntano a `references/*.md` o a skill di plugin disabilitati. Sono l'impronta della vendorizzazione: `skills-resync` documenta la riscrittura dei riferimenti *fra skill* (edit L3) ma **non tratta i riferimenti a `references/`**, che nei plugin originali erano file fratelli nella directory della skill e non sono stati copiati.

**Nota su `skills-resync`.** La riga 130-134 dichiara accettati i cross-reference per nome verso skill non vendorizzate: *"They are inert and accepted. Flag one only if it becomes an executable instruction."* Due dei pointer sopra **sono** istruzioni eseguibili e superano quella soglia:
1. `spec-driven-development` riga 169 — *"Hand execution to the F7 chain"* è un'istruzione, non una citazione.
2. `wayfinder` riga 25 — *"run `/setup-matt-pocock-skills` if not"* è un comando da eseguire.

Vanno segnalati a `skills-resync` come blocked, non lasciati inerti.
