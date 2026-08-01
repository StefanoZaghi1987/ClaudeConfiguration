# 60 — Selezione delle skill (decisa dall'utente, 2026-08-01)

Questo documento è la **selezione autoritativa** delle 26 skill dell'inventario di
`~/.claude/skills/skills-resync/SKILL.md`. Sostituisce i verdetti di `50-MIGRATION.md` §1.1
per le skill user-level; le decisioni su plugin, MCP, hook e residui restano quelle di §1.2-1.4.

**Regime scelto per le skill non selezionate:** `disable-model-invocation: true`.
Restano su disco, invocabili con `/nome`, a costo di descrizione zero. **Nessuna skill viene rimossa.**

---

## 1. Le 16 skill ATTIVE (model-invoked)

| # | Skill | Fase | Righe | Note operative |
|---|---|---|---|---|
| 1 | `interview-me` | 1 | 150 | Rimuovere `'grill me'` dalla description: appartiene a `grilling` |
| 2 | `grilling` | 1, 3, 5 | 8 | Nessuna modifica |
| 3 | `idea-refine` | 1 | 124 | Rimuovere `"stress-test my plan"` dalla description |
| 4 | `spec-driven-development` | 2 | 148 | **Riga 169 da riscrivere** — è l'anello rotto più costoso |
| 5 | `doubt-driven-development` | 3, 5, 8 | 168 | Rimuovere 2 pointer a `references/`; correggere `agents/` |
| 6 | `writing-plans` | 4 | 111 | Path → `docs/plans/`; aggiungere `Spec ref:` al task template |
| 7 | `planning-and-task-breakdown` | 4, 6 | 168 | Togliere `tasks/plan.md` + `tasks/todo.md`; togliere il pointer a `definition-of-done.md` |
| 8 | `wayfinder` | 1, 4, 6 | 75 | **Promossa da slash-only.** Ha un prerequisito bloccante — §3.3 |
| 9 | `subagent-driven-development` | 7 | 406 | Nessuna modifica al file. La regola su `model:` va nel `CLAUDE.md` |
| 10 | `executing-plans` | 7 | 45 | Nessuna modifica. Si auto-declassa quando i subagent sono disponibili |
| 11 | `code-review-and-quality` | 8 | 291 | Rimuovere 2 pointer a `references/` |
| 12 | `security-and-hardening` | 8 | 367 | **Lo scope è il problema, non la scelta** — §3.2 |
| 13 | `documentation-and-adrs` | 9 | 218 | Nessuna modifica |
| 14 | `consolidate-specs` | 9 | 183 | **Attiva ma oggi può solo rifiutarsi** — §3.1 |
| 15 | `consolidate-comments` | 9 | 153 | Idem |
| 16 | `diagnosing-bugs` | bug | 82 | Assorbire 2 sezioni da `systematic-debugging`; togliere il pointer a `/improve-codebase-architecture` |

## 2. Le 10 skill SLASH-ONLY

| # | Skill | Righe | Cambio | Perché resta su disco |
|---|---|---|---|---|
| 17 | `brainstorming` | 108 | **declassata** | Il flusso completo a 9 step con i suoi gate resta invocabile a mano quando lo vuoi |
| 18 | `code-simplification` | 263 | declassata | Le 4 trappole della sovra-semplificazione e Chesterton's Fence non esistono altrove |
| 19 | `incremental-implementation` | 175 | declassata | Slicing, feature flag, e il formato `NOTICED BUT NOT TOUCHING` |
| 20 | `dispatching-parallel-agents` | 121 | declassata | Il debugging multi-dominio resta un caso reale |
| 21 | `systematic-debugging` | 211 | declassata | **Estrarre le 2 sezioni uniche prima** di declassarla |
| 22 | `context-engineering` | 209 | declassata | Le ~15 righe che valgono vanno nel `CLAUDE.md` §S10-S11 |
| 23 | `skills-resync` | 113 | invariata | Mappa autoritativa della provenienza dell'harness |
| 24 | `writing-great-skills` | 50 | invariata | Framework per scrivere `backlog-tasks` e la router skill |
| 25 | `handoff` | 11 | invariata | Handoff per la review cross-sessione |
| 26 | `model-config-sync` | 27 | invariata | Rivalida il model-routing contro i doc ufficiali |

**Copertura per fase, dopo la selezione:**

| Fase | Skill attive | Subagent | Copertura |
|---|---|---|---|
| 1 Brainstorming | `interview-me` · `grilling` · `idea-refine` · `wayfinder` | — | **4** — vedi §3.4 |
| 2 Spec | `spec-driven-development` | `architect` | 1 + 1 |
| 3 Spec review | `doubt-driven-development` · `grilling` | `spec-reviewer` | 2 + 1 |
| 4 Plan | `writing-plans` · `planning-and-task-breakdown` · `wayfinder` | `architect` | 3 + 1 |
| 5 Plan review | `doubt-driven-development` · `grilling` | `implementation-plan-reviewer` | 2 + 1 |
| 6 Task Backlog | `planning-and-task-breakdown` · `wayfinder` | — | **0 adeguate** — serve `backlog-tasks` |
| 7 Coding | `subagent-driven-development` · `executing-plans` | — | 2 |
| 8 Code review | `code-review-and-quality` · `security-and-hardening` · `doubt-driven-development` | `code-reviewer` + il task-reviewer di SDD | 3 + 2 |
| 9 Doc | `documentation-and-adrs` · `consolidate-specs` · `consolidate-comments` | — | 1 operativa + 2 in attesa di prerequisiti |
| bug | `diagnosing-bugs` | `code-reviewer` | 1 + 1 |

---

## 3. Cinque conseguenze da gestire

### 3.1 `consolidate-specs` e `consolidate-comments` attive: oggi possono solo rifiutarsi

Questa è la scelta su cui insisto, in due frasi. Le due skill dichiarano nel proprio testo di non
essere spedibili (riga 58 e riga 57: *"This skill is not shippable as controlled"*) e cinque
prerequisiti mancano tutti — i 6 script di gate, i caps calibrati, l'intake `O7`, il floor del
knowledge graph. Attive significa che si attivano da sé al completamento di una feature, e quando
si attivano **il comportamento corretto è dichiarare quale controllo manca invece di girare**:
è ciò che il loro testo prescrive (*"say so rather than running the cross-check and reporting a pass"*).
Paghi ~210 token di descrizione a ogni turno più ~4,7k quando sparano, per ottenere un rifiuto motivato.

**Procedo come hai deciso**, con due mitigazioni che rendono il rifiuto utile invece di rumoroso:

1. **Una regola nel `CLAUDE.md`** che rende il rifiuto azionabile invece di generico:

   > When `consolidate-specs` or `consolidate-comments` fires, it must name the missing control
   > and stop: no target-set script, no gate scripts, no calibrated caps, no escalation intake
   > (open decision `O7`), no knowledge-graph floor. Then do the part that needs none of them:
   > realign what the code verifies, flag every divergence without resolving it, and hand
   > unresolvable statements to a person through `## To be confirmed`.

   È lo **stadio 1** di `40-TARGET-HARNESS.md` §1.4 — riallineamento senza controlli, che è
   comunque meglio di nessun riallineamento, e le regole 5/7/9/10 delle tue `rules/` lo governano già.

2. **La chiusura di `O7` sale di priorità.** È il solo prerequisito che dipende da una tua decisione
   e non da uno strumento assente: una volta deciso path, formato e reference scheme, le due skill
   passano dallo stadio 1 allo stadio 2 e il numero di controlli mancanti scende da cinque a tre.

Se preferisci che restino slash-only finché `O7` non è chiusa, è una riga di frontmatter da
togliere e rimettere: dimmelo e cambio la tabella.

### 3.2 `security-and-hardening`: il problema è lo *scope*, non la scelta

367 righe, ~5,1k token, e il contenuto è **quasi interamente web-app-centrico**: Express, Prisma,
React, npm, CORS, CSP, `express-rate-limit`, `helmet`, Zod. In `D:\ClaudeConfiguration` — un repo di
documentazione e configurazione, senza input non fidato, senza auth, senza storage — il suo trigger
(*"when handling user input, authentication, data storage, or external integrations"*) non ha
occasione di sparare correttamente, ma la descrizione si paga a ogni turno di ogni progetto.

**La leva giusta non è disattivarla: è spostarla di scope.** È esattamente il punto che il brief
chiedeva alla Fase 4 §6 ("quali skill spostare da user-level a project-level").

```
~/.claude/skills/security-and-hardening/          → rimuovere da user scope
<progetto-web>/.claude/skills/security-and-hardening/  → installare dove serve
```

Così è **attiva al 100%** nei progetti che ne hanno bisogno e costa **zero** in quelli che non ne
hanno. Le sezioni davvero trasversali — OWASP LLM Top 10 e la supply-chain hygiene — sono ~40 righe:
possono restare come blocco nel `CLAUDE.md` user-scope se le vuoi sempre disponibili.

**Se lavori prevalentemente su progetti web**, la scelta user-scope è quella corretta e questa
osservazione decade: dimmi quale dei due casi vale.

### 3.3 `wayfinder` model-invoked ha un prerequisito bloccante

Promuovendola a auto-invocabile, si attiverà da sé su un'idea grande e nebulosa — e nel farlo
eseguirà le sue istruzioni, che includono tre dipendenze **inesistenti su questo disco**:

| Riga | Istruzione | Stato |
|---|---|---|
| 25 | *"run `/setup-matt-pocock-skills` if not"* | Command non esistente |
| 77, 115 | *"Resolved by a `/research` **subagent**"* · *"Fire the research subagents"* | Non esistente |
| 111, 112, 124 | *"Run a `/grilling` and `/domain-modeling` session"* | `/domain-modeling` non esistente |

Slash-only questo era tollerabile: sei tu a invocarla e correggi al volo. Auto-invocabile non lo è:
la skill spara e prova a eseguire.

**Ordine obbligatorio:** prima le tre correzioni, poi la promozione. Le sostituzioni:

```diff
-The issue tracker should have been provided to you — run `/setup-matt-pocock-skills` if not.
-Consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them.
-If no tracker has been provided, default to the local-markdown tracker.
+The tracker is Backlog MD (`backlog` CLI). The map is a task labelled `wayfinder:map`;
+its tickets are child tasks created with `--parent`. Blocking uses `--depends-on`.
+The frontier is `backlog task list --status "To Do"` filtered to unblocked, unassigned children.

-- **Research** (AFK): … Resolved by a `/research` **subagent**.
+- **Research** (AFK): … Resolved by an `Explore` subagent, or a `general-purpose` subagent
+  when the answer needs reading outside the working directory.

-If in doubt, use `/grilling` and `/domain-modeling`.
+If in doubt, use `/grilling`.
```

E una `description` model-invoked va scritta: quella attuale è human-facing per convenzione
`disable-model-invocation`, quindi ha i trigger rimossi (`writing-great-skills`: *"the `description`
becomes human-facing — a one-line summary, trigger lists stripped"*). Proposta:

```yaml
description: Charts work too large for one agent session as a map of decision tickets on the
  task tracker, then resolves them one at a time until the route is clear. Use when the ask spans
  more than one session, when the decisions that need making are not yet known, or when the user
  says the work is too big to plan in one go. Not for work that fits in a single plan.
```

L'ultima frase è la difesa contro il rischio che ho segnalato: che spari su lavori che stanno in
una sessione. Va verificata con gli eval di `skill-creator`.

### 3.4 Senza `brainstorming`, la fase 1 ha quattro skill che si contendono lo stesso momento

Il guadagno che avevi previsto è reale: sparisce l'`<HARD-GATE>` più invasivo dell'harness — quello
che vieta di invocare *qualsiasi* altra skill — e con esso il conflitto `30-CONFLICTS.md` §2.3
con i trigger di `consolidate-*`, che hai appena messo fra le attive. Quel conflitto si risolve
gratis.

Il costo è che l'ambiguità di trigger **peggiora**. Oggi quattro skill attive sparano sul primo
messaggio di una feature nuova, e tre rivendicavano già frasi quasi identiche
(`30-CONFLICTS.md` §3.1):

| Skill | Momento reale | Produce |
|---|---|---|
| `interview-me` | l'intento non è chiaro | un restate confermato a 6 campi |
| `grilling` | una decisione o un artefatto esistente va stressato | niente (solo comprensione condivisa) |
| `idea-refine` | l'idea è vaga e servono opzioni | un one-pager con la lista Not Doing |
| `wayfinder` | il lavoro non sta in una sessione | una mappa di decision ticket |

Due interventi, entrambi già pianificati ma che salgono da "consigliati" a **prerequisiti**:

1. **La disambiguazione delle description** (M21 in `50-MIGRATION.md`) diventa bloccante, non
   opzionale. Con `brainstorming` presente c'era una skill dominante che assorbiva l'ambiguità;
   ora non c'è.
2. **La regola `CLAUDE.md` §S1 va riscritta** per l'ordine a quattro. Testo sostitutivo:

```markdown
## S1 — Before any spec exists

Pick by what is missing, in this order — the first that matches wins:

1. The work does not fit in one session, or you cannot yet name the decisions that need
   making → `wayfinder`. Chart the map, then return here for the first sub-project.
2. **who** / **why now** / **success** / **binding constraint** — any one missing →
   `interview-me`. Stop at an explicit "yes" on its six-field restate. "Sounds good",
   "whatever you think", and silence are not a yes.
3. The intent is clear but the shape is not, and options are worth generating →
   `idea-refine`. Its "Not doing" list is the deliverable.
4. Intent and shape are both clear → go straight to `spec-driven-development`.

`grilling` is orthogonal to all four: invoke it by hand at any point to stress a decision that
is converging too early. It produces no artifact and never replaces one of the four.

The terminal state of this phase is `spec-driven-development`, which owns the spec document.
When the spec is written and reviewed, the next skill is `writing-plans`. No other skill is
invoked between them.
```

L'ultimo paragrafo è la sostituzione del terminal state che `brainstorming` forniva
(*"The ONLY skill you invoke after brainstorming is writing-plans"*): senza di lei quella
catena esisteva solo dentro il suo file, e ora sta nel `CLAUDE.md`.

**Una cosa che perdi e va detta:** `brainstorming` era l'unica skill attiva che *scriveva*
il design doc e chiedeva l'approvazione sezione per sezione. `spec-driven-development` chiede
domande di chiarimento e produce il template, ma il suo gate è più debole — una lista di
assunzioni con *"→ Correct me now or I'll proceed with these"* invece di un'approvazione per
sezione. Il subagent `spec-reviewer` recupera il rigore **dopo** che il documento è scritto,
non durante. Se scopri che il documento arriva troppo avanti prima che tu possa correggerlo,
`/brainstorming` a mano è il rimedio, ed è per questo che resta su disco.

### 3.5 `doubt-driven-development` attiva su tre fasi: l'offerta cross-model diventa ricorrente

Averla attiva su 3, 5 e 8 significa che può sparare su qualunque decisione non banale — e la sua
definizione di "non banale" include *"introduces or modifies branching logic"*, che in una sessione
di coding è quasi sempre vera. Ogni ciclo interattivo porta con sé un obbligo:

> *"This question is mandatory in every interactive doubt cycle — even on artifacts that feel
> low-stakes. The user — not the agent — decides whether the cost is worth it."*
> — l'offerta di una second opinion cross-model (Gemini CLI / Codex CLI)

Su un lavoro con dieci decisioni non banali sono dieci interruzioni, più 8-15k token per artefatto
e fino a 3 cicli ciascuno. La skill si difende da sé (*"If you doubt every keystroke, you ship
nothing"*), ma la sua `When NOT to use` è una lista, non un gate.

**Regola `CLAUDE.md` §S3 da aggiungere**, che restringe l'attivazione senza toccare il file:

```markdown
`doubt-driven-development` is not the default review posture. Invoke it only when the artifact
under review has at least one of: an irreversible blast radius (data migration, public API,
production deploy), a property no test or compiler can verify (thread safety, idempotence,
ordering), or a correctness that depends on context the future reader cannot see. On everything
else the phase gate is enough: `spec-reviewer`, `implementation-plan-reviewer`, or the task
reviewer of `subagent-driven-development`.

Neither Gemini CLI nor Codex CLI is installed on this machine. Verify with `which` before
offering the cross-model step, and when neither is present say so once rather than offering
a choice that cannot be taken.
```

L'ultima frase chiude un buco concreto, e la verifica è stata fatta:

```
gemini     NON PRESENTE
codex      NON PRESENTE
```

**Nessuno dei due CLI cross-model è installato su questa macchina.** L'offerta obbligatoria della
skill precede la verifica del binary in PATH, quindi oggi `doubt-driven-development` ti proporrebbe
in ogni ciclo interattivo una scelta non percorribile, e solo dopo la tua risposta scoprirebbe che
lo strumento non c'è. La regola sopra non è un'ottimizzazione: elimina un'interruzione che non può
mai produrre nulla.

---

## 4. Effetto sul costo — e perché è più modesto di quanto sembri

| Voce | Oggi | Dopo la selezione | Delta |
|---|---|---|---|
| Skill model-invoked | 21 | **16** | −6 declassate, +1 promossa (`wayfinder`) |
| Costo di descrizione per turno | **5,4k** (misurato via `/context`) | ~4,1k stimato | **≈ −1,3k / turno** |
| Righe caricabili quando le attive sparano | — | 2.605 righe fra le 16 | — |
| Skill sopra le 250 righe fra le attive | — | 3 (`subagent-driven-development` 406, `security-and-hardening` 367, `code-review-and-quality` 291) | — |

**La lettura onesta: il taglio è del ~24% sul costo passivo, e il costo attivo sale.** Le tre skill
più grandi dell'harness sono tutte fra le 16 attive, e due delle nuove attive (`consolidate-*`)
oggi non possono produrre altro che un rifiuto motivato. La riduzione dei token che cercavi non
viene principalmente da qui.

**Viene da altrove, e non è una skill.** Le tre voci che pesano davvero, in ordine:

1. **`model:` esplicito su ogni dispatch di subagent.** Con `model: opus[1m]` di sessione,
   i ~30 dispatch di un plan multi-task girano tutti su Opus 1M. Ordine di grandezza, rischio nullo,
   e la skill lo prescrive già in grassetto.
2. **I 4 plugin abilitati con `usageCount: 0` per mesi.** Segnale ammissibile (§0): abilitati da
   mesi, mai scelti quando c'era occasione. Le loro 6 skill pagano descrizione a ogni turno.
3. **`security-and-hardening` a project scope invece di user scope** (§3.2). ~5,1k che diventano
   zero nei progetti che non sono web app.

La selezione delle skill è la parte **più visibile** dell'ottimizzazione e la **meno efficace**.
Vale farla per la determinismo dei trigger — quattro skill che si contendono la fase 1 producono
comportamento non riproducibile, e quello è un costo di qualità, non di token.

---

## 5. Cosa cambia nel piano di migrazione

Rispetto a `50-MIGRATION.md`, la selezione produce quattro delta:

| # | Delta | Effetto sul piano |
|---|---|---|
| 1 | **M19 cambia elenco.** Le 7 skill da declassare diventano 6: `security-and-hardening` esce (va a project scope, §3.2) ed entrano `brainstorming` e `incremental-implementation`. `consolidate-specs`/`consolidate-comments` **escono dalla lista**: restano attive | riscrivere M19 |
| 2 | **M21 sale a prerequisito bloccante** e passa da 3 a 4 skill (aggiungere `wayfinder`) | M21 prima di tutto ciò che dipende dalla fase 1 |
| 3 | **Nuovo step M28: correggere `wayfinder` e scrivere la sua description model-invoked.** Prerequisito bloccante della sua promozione (§3.3) | nuovo task |
| 4 | **Nuovo step M29: spostare `security-and-hardening` a project scope** nei progetti web | nuovo task |
| 5 | **La chiusura di `O7` (M24) sale di priorità**: è il solo prerequisito delle `consolidate-*` che dipende da te e non da uno strumento assente (§3.1) | M24 da "stadio 7" a "stadio 3" |

I task Backlog corrispondenti, con i cross-reference a questo documento:

```bash
backlog task create "Fix wayfinder's three dangling dependencies before promoting it" \
  -d "wayfinder is being promoted from slash-only to model-invoked. Auto-invocation means it will execute its own instructions, which name /setup-matt-pocock-skills, a /research subagent and /domain-modeling — none of which exist here. Replace the tracker with Backlog MD (--parent, --depends-on), /research with Explore, and drop /domain-modeling." \
  --ac "rg -n '/research|/domain-modeling|setup-matt-pocock' over the skill returns nothing" \
  --ac "The tracker section names Backlog MD with --parent and --depends-on" \
  --ac "A model-invoked description exists and closes with the negative trigger 'Not for work that fits in a single plan'" \
  --dod "The description was checked with skill-creator's eval before the promotion lands" \
  --ref "docs/harness/60-SELECTION.md#33-wayfinder-model-invoked-ha-un-prerequisito-bloccante" \
  --ref "docs/harness/30-CONFLICTS.md#5-riferimenti-pendenti--inventario-completo" \
  --labels "harness-migration,stage-3,blocking-prereq" --priority high

backlog task create "Move security-and-hardening to project scope" \
  -d "367 lines, ~5.1k tokens, almost entirely web-app-centric (Express, Prisma, npm, CORS, CSP). Active at user scope it is paid in every project; at project scope it is free where it does not apply and fully active where it does. Keep the ~40 cross-cutting lines (OWASP LLM Top 10, supply-chain hygiene) in the user CLAUDE.md if they should always be reachable." \
  --ac "The skill is no longer under ~/.claude/skills/" \
  --ac "It is installed under .claude/skills/ in at least one web project" \
  --ac "/context shows Skills lower by roughly its description cost" \
  --ref "docs/harness/60-SELECTION.md#32-security-and-hardening-il-problema-e-lo-scope-non-la-scelta" \
  --ref "docs/harness/40-TARGET-HARNESS.md#63-skill-da-spostare-a-disable-model-invocation-true" \
  --labels "harness-migration,stage-6,scope" --priority medium

backlog task create "Rewrite CLAUDE.md S1 for a four-skill phase 1" \
  -d "Dropping brainstorming removes the dominant skill that absorbed the trigger ambiguity, and the terminal-state chain to writing-plans existed only inside its file. Four active skills now fire on the first message of a new feature." \
  --ac "S1 orders wayfinder, interview-me, idea-refine, spec-driven-development as first-match-wins" \
  --ac "S1 states that grilling is orthogonal and produces no artifact" \
  --ac "S1 names spec-driven-development as the owner of the spec document and writing-plans as the next skill" \
  --dod "M21 (description disambiguation) is done first — it is a prerequisite, not a companion" \
  --ref "docs/harness/60-SELECTION.md#34-senza-brainstorming-la-fase-1-ha-quattro-skill-che-si-contendono-lo-stesso-momento" \
  --ref "docs/harness/30-CONFLICTS.md#31-tre-skill-rivendicano-la-stessa-frase--il-caso-piu-netto" \
  --labels "harness-migration,stage-3,trigger" --priority high

backlog task create "Scope doubt-driven-development and check the cross-model CLIs" \
  -d "Active on phases 3, 5 and 8, it can fire on any non-trivial decision — and its own definition includes 'introduces or modifies branching logic'. Every interactive cycle carries a mandatory cross-model offer, but the offer precedes the PATH check, so a path that cannot be taken would be proposed." \
  --ac "CLAUDE.md S3 restricts invocation to irreversible blast radius, compiler-unverifiable properties, or invisible-context correctness" \
  --ac "Whether gemini and codex are on PATH is verified and recorded" \
  --ac "If neither is present, the rule says to state it once rather than offer the choice" \
  --ref "docs/harness/60-SELECTION.md#35-doubt-driven-development-attiva-su-tre-fasi-lofferta-cross-model-diventa-ricorrente" \
  --ref "docs/harness/10-EVIDENCE.md#13--doubt-driven-development" \
  --labels "harness-migration,stage-3,scope" --priority medium

backlog task create "Add the missing-control rule for the two consolidate skills" \
  -d "Both are active by decision, and both declare themselves not shippable as controlled. Today the only correct behaviour when they fire is to name the missing control and do the part that needs none: realign what the code verifies, flag divergences without resolving them, hand unresolvable statements to a person." \
  --ac "CLAUDE.md S9 names the five missing controls explicitly" \
  --ac "S9 states what to do anyway — stage 1 of the target design" \
  --ac "Neither skill reports a pass when the target-set floor is absent" \
  --dod "O7 is scheduled: it is the only missing prerequisite that depends on a decision rather than an absent tool" \
  --ref "docs/harness/60-SELECTION.md#31-consolidate-specs-e-consolidate-comments-attive-oggi-possono-solo-rifiutarsi" \
  --ref "docs/harness/40-TARGET-HARNESS.md#14-consolidate-specs--consolidate-comments--cosa-fare-oggi-di-due-skill-non-eseguibili" \
  --labels "harness-migration,stage-3,decision" --priority high
```

---

## 6. Quattro domande ancora aperte

Nessuna è bloccante: procedo con le assunzioni indicate se non dici altro.

| # | Domanda | Assunzione se non rispondi |
|---|---|---|
| 1 | Lavori prevalentemente su progetti web? (§3.2) | No → `security-and-hardening` va a project scope |
| 2 | `consolidate-*` attive subito, o slash-only fino alla chiusura di `O7`? (§3.1) | Attive, come hai deciso, con la regola sul controllo mancante |
| 3 | ~~`gemini` o `codex` sono installati?~~ | **Chiuso: nessuno dei due.** L'offerta cross-model va soppressa (§3.5) |
| 4 | `O7` — path, formato e reference scheme dell'intake (`40-TARGET-HARNESS.md` §3.6) | Opzione B: `docs/escalations.md` per repo, versionato |

---

## 7. Verifica di compatibilità fra le 16 attive

`30-CONFLICTS.md` analizzava tutte le skill installate. Questa sezione rifà l'analisi **solo
sull'insieme selezionato**, più i componenti sempre attivi (i 2 hook, i 4 subagent, le 2 rules).
Sono 22 coppie potenzialmente in collisione; nove sono reali e vanno risolte, **due sono causate
dalla selezione stessa** e non esistevano prima.

### 7.1 Le nove collisioni reali

| # | Coppia attiva | Collisione | Risoluzione |
|---|---|---|---|
| **C1** | `interview-me` · `grilling` · `idea-refine` · `wayfinder` | Quattro skill sparano sul primo messaggio di una feature nuova, e tre rivendicano frasi di trigger quasi identiche | `CLAUDE.md` §W1 first-match-wins + disambiguazione delle description (M21, bloccante) |
| **C2** | `writing-plans` · `planning-and-task-breakdown` · `spec-driven-development` | **Tre skill attive prescrivono path di output per il plan, e due prescrivono gli stessi path aboliti.** `planning-and-task-breakdown` riga 145-148 *e* `spec-driven-development` riga 143 impongono entrambe `tasks/plan.md` + `tasks/todo.md` | `CLAUDE.md` §W4. **Correggere due file, non uno** — vedi §7.3 |
| **C3** | `doubt-driven-development` · `subagent-driven-development` | **Incompatibilità strutturale, non stilistica.** `doubt-driven` è progettata per l'orchestratore di sessione principale e dichiara di non poter girare annidata in un subagent (Claude Code impedisce lo spawn nidificato); ma se spara durante la fase 7, o gira nel controller — dove SDD vieta di correggere e di fermarsi — o gira dentro un implementer, dove deve degradarsi a self-questioning. Entrambi gli esiti sono sbagliati | `CLAUDE.md` §W8: `doubt-driven` si invoca **ai confini di fase** (3, 5, 8b standalone), **mai durante l'esecuzione**. Dentro il fix loop di SDD governa SDD |
| **C4** | `diagnosing-bugs` · `subagent-driven-development` | Un bug incontrato da un implementer: `diagnosing-bugs` vuole prima un feedback loop red-capable, il fix loop di SDD ha il proprio protocollo (5 round, escalation di modello, breaker). Due gate sullo stesso momento | `CLAUDE.md` §W12: dentro il fix loop di SDD governa SDD; un bug segnalato indipendentemente entra da `diagnosing-bugs` |
| **C5** | `consolidate-specs` · `consolidate-comments` — trigger | **Causata dalla selezione.** Il loro trigger ammissibile è *"entry into brainstorming on an area touched in the past"*, ma `brainstorming` è ora slash-only e non è più l'ingresso della fase 1. Il trigger nomina un momento che non esiste più | Riformulare il trigger in termini del nuovo ingresso (`interview-me` / `idea-refine` / `wayfinder`). Vedi §7.3 |
| **C6** | `wayfinder` · `planning-and-task-breakdown` | **Causata dalla selezione** (`wayfinder` promossa a model-invoked). Entrambe rivendicano la fase 6: `wayfinder` crea decision ticket sul tracker, `planning-and-task-breakdown` crea build task. Con Backlog MD come tracker unico, **entrambe scrivono in `backlog/tasks/`** | `CLAUDE.md` §W6: discriminatore per label. `wayfinder:map` e `wayfinder:ticket` per le decisioni; lo slug del lavoro per le build task. Una task non può portare entrambe |
| **C7** | `code-review-and-quality` · `security-and-hardening` | 4,1k + 5,1k = **9,2k caricati sullo stesso diff** se entrambe sparano. È il co-caricamento più grande dell'insieme attivo | `CLAUDE.md` §W9: si **citano** nel prompt del reviewer, non si caricano nel contesto del controller. Più `security-and-hardening` a project scope (§3.2) |
| **C8** | `consolidate-*` · `subagent-driven-development` | Le `consolidate-*` impongono *"No functional commit follows from here to the end of the unit"* e un commit separato nella stessa PR; SDD chiude con la scelta di integrazione. Se il consolidamento parte prima, blocca l'integrazione | `CLAUDE.md` §W10: il consolidamento avviene **dopo** la review finale di SDD e **prima** della scelta di integrazione |
| **C9** | `ponytail` (hook) · le 5 skill che producono documenti | `ponytail` ordina *"If the explanation is longer than the code, delete the explanation"*; `writing-plans`, `spec-driven-development`, `documentation-and-adrs` e le due `consolidate-*` producono per definizione prosa strutturata | `CLAUDE.md` §W0, usando l'esenzione che `ponytail` fornisce da sé: *"Explanation the user explicitly asked for … is not debt"* |

### 7.2 Le sette coppie che NON collidono — verificate, non assunte

| Coppia | Perché è compatibile |
|---|---|
| `subagent-driven-development` · `executing-plans` | Auto-risolta: `executing-plans` riga 14 si declassa (*"If subagents are available, use subagent-driven-development instead"*), e `writing-plans` offre la scelta all'utente in modo esplicito |
| `code-review-and-quality` · `doubt-driven-development` | Calibrazioni opposte ma per decisioni diverse (*mergiabile?* vs *vero?*), e `doubt-driven` riga 110 spiega come sovrascrivere la forma di risposta di un reviewer role-based |
| `documentation-and-adrs` · `consolidate-specs` | Complementari: la prima definisce il formato ADR che la seconda presuppone per la disposizione `historical decision → ADR` |
| `grilling` · `subagent-driven-development` | `grilling` non produce artefatti e opera in fase 1/3/5; SDD in fase 7. Nessuna sovrapposizione temporale |
| `interview-me` · `spec-driven-development` | Sequenziali e dichiarate tali: `interview-me` riga 183 nomina `spec-driven-development` come downstream |
| `writing-plans` · `subagent-driven-development` | Contratto esplicito: `writing-plans` produce l'header con `REQUIRED SUB-SKILL` e le Global Constraints che SDD passa al task-reviewer |
| I 4 subagent fra loro | `architect.md` dichiara la catena: design → `implementation-plan-reviewer` → `code-reviewer`. Tutti read-only, nessuno scrive |

### 7.3 Correzioni ai file che la compatibilità richiede

Oltre a quelle già in `60-SELECTION.md` §1, la verifica di compatibilità aggiunge due edit che
non erano nel piano.

**C2 — `spec-driven-development` riga 143.** Il piano correggeva solo `planning-and-task-breakdown`.
Anche questa skill impone i path aboliti, e delegando a `planning-and-task-breakdown` come *"canonical
source"* propaga la collisione:

```diff
-> **Output convention:** Save the plan to `tasks/plan.md` and the task list to `tasks/todo.md`, per the `/plan` command convention. Create `tasks/` if it does not exist. Downstream commands (`/build`, etc.) expect these paths.
+> **Output convention:** the plan is a single file at `docs/plans/YYYY-MM-DD-<slug>.md`, written by
+> `writing-plans`. Tasks live in `backlog/tasks/`, created with the `backlog` CLI. Do not create
+> `tasks/plan.md` or `tasks/todo.md`.
```

**C5 — il trigger delle due `consolidate-*`.** Entrambe hanno la stessa riga nella tabella dei
trigger ammissibili e nella `description`:

```diff
-| Entry into brainstorming on an area touched in the past | The standalone case (`S35`) |
+| Entry into design work on an area touched in the past — the first phase-1 skill firing on it | The standalone case (`S35`) |
```

Il nome del momento cambia, la semantica di `S35` no: resta *"entry into design work on a
previously-touched area"*. Registrare come edit locale **L7** in `skills-resync`, o un re-vendor
lo perde.

### 7.4 Verdetto

**L'insieme delle 16 è internamente coerente**, a condizione che le nove collisioni siano risolte
dalle regole di precedenza del `CLAUDE.md` e dai quattro edit ai file (C2 ×2 file, C5 ×2 file).
Nessuna collisione richiede di rimuovere una skill dall'insieme.

Le due collisioni **create dalla selezione** (C5, C6) sono il prezzo di due scelte deliberate —
declassare `brainstorming` e promuovere `wayfinder` — e costano quattro righe di edit e una regola
ciascuna. Nessuna delle due è un motivo per rivedere la scelta.

La collisione **C3 è quella da non sottovalutare**: non è una questione di stile o di costo, è
un'incompatibilità di esecuzione fra due delle skill più importanti dell'insieme, e senza la regola
§W8 produce silenziosamente una review degradata che si dichiara completa.
