# 50 — Piano di migrazione (Fase 5)

Nessuna modifica è stata applicata in questa sessione. Tutto ciò che segue è proposta.

---

## 1. Tabella delle decisioni

Verdetti: **KEEP** · **KEEP CON MODIFICHE** · **DISABILITA** (resta su disco, non spara da sé) · **RIMUOVI** (via dal disco) · **RECUPERA** (assente, da reinstallare) · **CREA** (non esiste).
La colonna *Uso* riporta `skillUsage` / `pluginUsage` reali da `~/.claude.json`.

### 1.1 Skill user-level (26)

> **I verdetti di questa sezione sono sostituiti da `60-SELECTION.md`**, che registra la selezione
> decisa dall'utente il 2026-08-01: 16 skill attive, 10 slash-only, nessuna rimossa. La tabella qui
> sotto conserva le **motivazioni e i rischi per skill**, che restano validi e a cui `60-SELECTION.md`
> rimanda; dove la colonna *Verdetto* divergesse dalla selezione, vale `60-SELECTION.md`.

| Componente | Uso | Verdetto | Motivazione | Rischio |
|---|---|---|---|---|
| `brainstorming` | 41 + 19 | **KEEP CON MODIFICHE** | Vincitore fase 1-2 per il dialogo. Cambiare il path da `docs/superpowers/specs/` a `docs/specs/`; il terminal state resta `writing-plans` | basso |
| `writing-plans` | **48** | **KEEP CON MODIFICHE** | Vincitore fase 4 (87). Cambiare il path da `docs/superpowers/plans/` a `docs/plans/`; aggiungere `Spec ref:` allo Task Structure | basso |
| `subagent-driven-development` | **45** | **KEEP** | Vincitore fase 7 (90), punteggio più alto dell'audit. Non toccare il file: la regola su `model:` va in `CLAUDE.md`, non nella skill | — |
| `systematic-debugging` | 14 | **DISABILITA** | Perde 56 a 87 contro `diagnosing-bugs`. Prima estrarre le sue 2 sezioni uniche (boundary instrumentation in sistemi multi-layer; regola dei 3 fix falliti) | **medio** — 14 usi reali, `diagnosing-bugs` ne ha 0 perché è vecchia di un giorno |
| `executing-plans` | 4 | **KEEP** | Fallback auto-dichiarato per task accoppiate. 45 righe, si declassa da sé | — |
| `dispatching-parallel-agents` | 1 | **DISABILITA** | 1 sola invocazione in mesi. SDD vieta il parallelismo sugli implementer; resta per il debugging multi-dominio | basso |
| `diagnosing-bugs` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Vincitore fase 10b (87 vs 56). Aggiungere le 2 sezioni estratte da `systematic-debugging`; rimuovere il pointer a `/improve-codebase-architecture` | basso |
| `interview-me` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Vincitore fase 1 (80,3). Rimuovere `'grill me'` dalla description: appartiene a `grilling` | basso |
| `grilling` | 0 | **KEEP** | 110 token per la criticità più alta della fase 1. Miglior rapporto valore/token dell'harness | — |
| `idea-refine` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Supporto fase 1. Rimuovere `"stress-test my plan"`: collide con `interview-me` e `grilling` | basso |
| `spec-driven-development` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Vincitore fase 2 (85) per il template. **Riscrivere la riga 169**: cita la "F7 chain in `~/.claude/CLAUDE.md`" (file di 0 byte) e 3 skill con prefisso `superpowers:` che non risolve | **medio** — è l'anello rotto più costoso |
| `planning-and-task-breakdown` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Supporto fase 4 per grafo/slicing/sizing. Rimuovere la prescrizione di scrivere `tasks/plan.md` e `tasks/todo.md`; rimuovere il pointer a `references/definition-of-done.md` (Backlog MD ha `--dod` nativo) | basso |
| `incremental-implementation` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Supporto fase 7. Restringere la description (oggi spara su *"any change that touches more than one file"*); rimuovere il pointer a `references/definition-of-done.md` | basso |
| `code-review-and-quality` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Rubrica di fase 8, la più completa. Rimuovere i 2 pointer a `references/*.md` inesistenti. **Non** disabilitare: va citata nei prompt dei reviewer, quindi il modello deve poterla raggiungere | basso |
| `doubt-driven-development` | 0 (1 giorno) | **KEEP CON MODIFICHE** | Escalation per fasi 3, 5, 8 su decisioni irreversibili. Rimuovere i pointer a `references/orchestration-patterns.md` e correggere `agents/` → `~/.claude/agents/` | basso |
| `documentation-and-adrs` | 0 (1 giorno) | **KEEP** | Vincitore fase 9 (74) e unico eseguibile della fase | — |
| `code-simplification` | 0 (1 giorno) | **DISABILITA** | 3,7k token, terzo strumento sullo stesso asse dopo `/ponytail-review` e `/simplify` | basso |
| `security-and-hardening` | 0 (1 giorno) | **DISABILITA** | 5,1k token, contenuto web-app-centrico, `/security-review` esegue. Resta il miglior riferimento a mano | basso |
| `context-engineering` | 2 | **DISABILITA** | 3k token per un lavoro una-volta-per-progetto, con trigger che spara a ogni sessione | basso |
| `consolidate-specs` | 0 | **DISABILITA** | Dichiara di non essere shippabile (riga 58); 5 prerequisiti mancanti. Resta la specifica del target per la fase 9 | basso |
| `consolidate-comments` | 0 | **DISABILITA** | Idem (riga 57) | basso |
| `wayfinder` | 0 | **KEEP CON MODIFICHE** | Già slash-only, costo zero. Sostituire i 3 pointer inesistenti: `/research` → `Explore`; tracker → Backlog MD con `--parent`; rimuovere `/setup-matt-pocock-skills` | basso |
| `skills-resync` | 2 | **KEEP CON MODIFICHE** | Documentazione autoritativa della provenienza. **Aggiungere una sezione sui riferimenti a `references/`**: l'edit L3 copre i riferimenti fra skill, non quelli ai file fratelli non copiati (17 dei 23 pointer rotti) | basso |
| `model-config-sync` | 0 | **KEEP** | Manutenzione, slash-only, `allowed-tools` senza scrittura | — |
| `handoff` | 0 | **KEEP** | 11 righe, slash-only, salva in `$TMPDIR` e non nel workspace | — |
| `writing-great-skills` | 0 | **KEEP** | Contiene il framework con cui questo audit è stato condotto. Slash-only | — |

### 1.2 Subagent, rules, memoria

| Componente | Verdetto | Motivazione | Rischio |
|---|---|---|---|
| `architect` (fable) | **KEEP** | Design input per fasi 2 e 4. 180 token | — |
| `spec-reviewer` (opus) | **KEEP** | Vincitore fase 3 (86,9). **Da mettere nella catena**: oggi il gate 3 gira sul self-review di `brainstorming` (57,4) | — |
| `implementation-plan-reviewer` (opus) | **KEEP** | Vincitore fase 5 (86,9). **Da mettere nella catena**: oggi la fase 5 non ha gate | — |
| `code-reviewer` (opus) | **KEEP** | Vincitore fase 8 standalone (86,9) | — |
| `rules/documentation-lifecycle-rules.md` | **KEEP CON MODIFICHE** | Emendare la regola 11 dopo aver deciso `O7` (`40-TARGET-HARNESS.md` §3.6) | **medio** — regola sempre in contesto |
| `rules/effort-escalation.md` | **KEEP CON MODIFICHE** | Aggiungere l'eccezione per implementer e reviewer (`30-CONFLICTS.md` §2.6) | basso |
| `~/.claude/documentation-lifecycle.md` (102 KB) | **KEEP** | Companion citato dalle `consolidate-*`. Regola 12: leggere per sezioni | — |
| Memoria file-based + `MEMORY.md` | **KEEP** | Unico store di memoria. 591 token misurati | — |
| `serena` memories | **NON USARE** | Secondo store non coordinato. Regola `CLAUDE.md` §S10 | basso |
| `~/.claude/escalations.md` | **NON CREARE ancora** | La regola 11 lo richiede, `O7` non è deciso. Crearlo ora significa scegliere `O7` per inerzia | — |

### 1.3 Plugin (26 installati)

| Plugin | Uso | Stato oggi | Verdetto | Motivazione | Rischio |
|---|---|---|---|---|---|
| `ponytail@ponytail` | **114** | on | **KEEP** | Unico governo di stile attivo; 3 hook + 6 command. Contro-limiti ben scritti (security, validation, comprensione) | — |
| `claude-md-management` | 3 (skill: 14+9) | on | **KEEP** | Strumento con cui verificherai il `CLAUDE.md` riscritto | — |
| `explanatory-output-style` | **416** | on | **DISABILITA** | Contraddice `ponytail` a livello imperativo, entrambi via `SessionStart`. **Decisione tua** — è una preferenza, non uno spreco | **medio** — 416 usi |
| `claude-code-setup` | **0** | on | **DISABILITA** | Abilitato da mesi, mai usato | nullo |
| `code-review` | **0** | on | **DISABILITA** | Abilitato da mesi, mai usato. Il suo `/code-review` è coperto dal `code-reviewer` agent | nullo |
| `skill-creator` | **0** | on | **DISABILITA** | Mai usato. **Riabilitare per la sessione** in cui scriverai `backlog-tasks`: i suoi eval sulla description sono l'unico modo di misurare l'accuratezza del trigger | nullo |
| `mcp-server-dev` | **0** | on | **DISABILITA** | Mai usato. 3 skill, ~590 righe | nullo |
| `superpowers` | **425** | off | **KEEP OFF** | 6/14 skill già vendorizzate. Riabilitarlo reintrodurrebbe l'hook `SessionStart` che inietta `using-superpowers` per intero a ogni avvio, resume, clear e compact. Recuperare le skill mancanti per vendorizzazione, non riattivando | — |
| `finishing-a-development-branch` (skill dentro `superpowers`) | **30** | non vendorizzata | **RECUPERA** | **30 invocazioni, ultima 2026-07-30 16:40** — il giorno prima di essere classificata fra le *"deliberately dropped"*. Più usata di `systematic-debugging`. È citata come esecutore dall'ultima riga operativa di SDD (riga 413). È una regressione | **medio** |
| `test-driven-development` (skill dentro `superpowers` o `agent-skills`) | 0 | non vendorizzata | **VALUTA** | Presupposta in 3 punti e definita in 0: `writing-plans` genera step TDD, `spec-driven-development` la invoca per nome, SDD chiede "TDD Evidence (RED/GREEN)". Ma zero invocazioni storiche: potresti applicare TDD senza una skill che te lo dica. Decidi tu | basso |
| `verification-before-completion` (dentro `superpowers`) | 0 | non vendorizzata | **VALUTA** | *"evidence before assertions always"*. La sua disciplina è già riscritta in prosa in `executing-plans` e `systematic-debugging` (edit L3). Probabilmente non serve un file | basso |
| `agent-skills@addy-agent-skills` | 22 | off | **KEEP OFF** | 11/24 skill vendorizzate ieri. Le 13 non vendorizzate: valutare `source-driven-development` e `api-and-interface-design` se un progetto le richiede | — |
| `mattpocock-skills` | 1 | off | **KEEP OFF** | 5/6 skill vendorizzate | — |
| `security-guidance` | **1.779** | off | **VALUTA** | Uso altissimo fino al 2026-07-31 16:21, poi disabilitato. 20 file di hook. Era il secondo componente più attivo dell'harness. **Perché l'hai disabilitato?** Se per costo, la decisione è coerente; se per errore, va riattivato | **medio** |
| `ralph-loop` | 105 | off | **RIMUOVI** | 105 usi ma ultimo 2026-04. Sostituito dal `/loop` built-in | basso |
| `feature-dev` | 0 (skill: 14) | off | **RIMUOVI** | 14 invocazioni della skill fino al 2026-05-20, pipeline feature alternativa e concorrente a quella target | basso |
| `pr-review-toolkit` | 0 | off | **RIMUOVI** | 6 subagent per la fase 8, che ha già due vincitori | basso |
| `code-simplifier` | 0 | off | **RIMUOVI** | Sovrapposto a `/ponytail-review` e `/simplify` | nullo |
| `plugin-dev`, `agent-sdk-dev`, `playground` | 0 | off | **RIMUOVI** | Meta-tooling mai usato | nullo |
| `chrome-devtools-mcp` | 0 | off | **RIMUOVI** | Sovrapposto a `claude-in-chrome`, attivo | nullo |
| `playwright`, `github` | 0 | off | **RIMUOVI** | Mai usati. `github` recuperabile via `gh` CLI | nullo |
| `figma`, `firecrawl`, `huggingface-skills`, `sentry`, `frontend-design` | 0 | off | **RIMUOVI** | 60 skill totali, nessuna fase del workflow | nullo |
| `hookify` | **9.445** | **non installato** | — | Telemetria orfana: il plugin con l'uso più alto in assoluto non è più su disco. Non toccare `pluginUsage` — è il tuo unico registro storico | — |

### 1.4 MCP, hook, built-in, residui

| Componente | Verdetto | Motivazione | Rischio |
|---|---|---|---|
| MCP `serena` (29 tool) | **KEEP CON MODIFICHE** | Vincitore navigazione simbolica. Restringere `initial_instructions` a una volta per sessione (regola `CLAUDE.md` §S10) | basso |
| MCP `backlog` (0 tool) | **RIMUOVI** | Istruzioni iniettate a ogni sessione, zero tool esposti. La CLI v1.45.1 funziona e copre tutto il contratto | basso |
| MCP `claude-in-chrome` (22 tool) | **KEEP** | Estensione, non in `mcpServers` | — |
| Hook ponytail (3 eventi) | **KEEP** | Il valore del plugin è quasi tutto negli hook, non nelle skill (`skills-resync` righe 59-70) | — |
| Hook `explanatory-output-style` | **DISABILITA** con il plugin | Vedi §1.3 | medio |
| Built-in `/security-review`, `/simplify`, `Explore`, `/loop`, `update-config`, `claude-api` | **KEEP** | Costo passivo zero, nel target harness | — |
| Built-in `/init`, `dataviz`, `keybindings-help`, `schedule` | **KEEP** (inerti) | Non rimovibili, non usati nella pipeline | — |
| `cache/temp_git_*` ×3, `cache/sorbh/` | **RIMUOVI** | Residui di clone; marketplace `sorbh` non registrato | nullo |
| `skills/systematic-debugging/{CREATION-LOG,test-academic,test-pressure-1..3}.md` | **RIMUOVI** | **Sediment**: artefatti di sviluppo, non citati dal corpo | nullo |
| `~/.claude/CLAUDE.md` (0 byte) | **CREA** | Testo pronto in `40-TARGET-HARNESS.md` §4.1 | basso |
| `D:\ClaudeConfiguration\CLAUDE.md` | **CREA** | Testo pronto in §4.2. Il repo non ha istruzioni di progetto | basso |
| `~/.claude/commands/` | **CREA** | Directory assente; serve per gli slash command | nullo |
| Skill `backlog-tasks` | **CREA** | Nessuna delle 26 skill sa che Backlog MD esiste. Design in §3.3 e §5.2 | basso |
| Router skill (`/skills-map`) | **CREA** | Cura dichiarata da `writing-great-skills` per la proliferazione di skill user-invoked: dopo la migrazione saranno 12 | basso |
| `docs/reviews/` (contratto) | **CREA** | La review cross-sessione non ha oggi un artefatto | basso |
| `backlog/` in `D:\ClaudeConfiguration` | **CREA** | Il repo non è inizializzato con Backlog MD | basso |

---

## 2. Sequenza di migrazione

Passi atomici e reversibili, ordinati per **valore su rischio**. Ognuno ha un criterio di verifica che si può eseguire.
**Non passare al successivo prima di aver verificato il precedente.**

### Stadio 0 — Rete di sicurezza (prima di tutto)

**M0.** Snapshot dello stato corrente.
```bash
mkdir -p ~/claude-harness-backup-2026-08-01
cp -r ~/.claude/settings.json ~/.claude/skills ~/.claude/agents ~/.claude/rules \
      ~/claude-harness-backup-2026-08-01/
node -e "const j=require(process.env.USERPROFILE+'/.claude.json'); \
  require('fs').writeFileSync(process.env.USERPROFILE+'/claude-harness-backup-2026-08-01/usage-snapshot.json', \
  JSON.stringify({skillUsage:j.skillUsage,pluginUsage:j.pluginUsage,mcpServers:j.mcpServers},null,2))"
```
*Verifica:* la directory contiene `settings.json`, tre alberi e `usage-snapshot.json` con le chiavi `skillUsage` e `pluginUsage` non vuote.

**M1.** Baseline dei token. Esegui `/context` e incolla l'output in `docs/harness/baseline-2026-08-01.md`.
*Verifica:* il file esiste e riporta il valore di `Skills:` (oggi 5,4k).

### Stadio 1 — Costo zero, rischio nullo

**M2.** Disabilita i 4 plugin a `usageCount: 0` (`40-TARGET-HARNESS.md` §6.1, prime 4 righe del diff).
*Verifica:* `/context` mostra un `Skills:` più basso; le 6 skill di quei plugin non compaiono più nell'elenco annunciato all'avvio di una sessione nuova.

**M3.** Rimuovi l'MCP `backlog` da `~/.claude.json`.
*Verifica:* una sessione nuova non contiene più il blocco `## backlog` nelle istruzioni MCP; `backlog task list` continua a funzionare da Bash.

**M4.** Pulisci i residui: `cache/temp_git_*` ×3, `cache/sorbh/`, i 5 file di sediment in `skills/systematic-debugging/`.
*Verifica:* `Get-ChildItem ~/.claude/plugins/cache -Directory` non elenca `temp_git_*` né `sorbh`; `skills/systematic-debugging/` contiene 6 file (SKILL.md + 3 reference + `condition-based-waiting-example.ts` + `find-polluter.sh`).

**M5.** Rimuovi gli 11 plugin con verdetto RIMUOVI e `usageCount: 0` (§1.3).
*Verifica:* `installed_plugins.json` non li elenca; l'avvio di una sessione nuova non produce errori.

### Stadio 2 — Il risparmio grande, senza toccare file di skill

**M6.** Scrivi `~/.claude/CLAUDE.md` col testo di `40-TARGET-HARNESS.md` §4.1.
*Verifica:* una sessione nuova mostra il file in `# claudeMd`; `/context` mostra un `System prompt` più alto di ~1,5k (è il costo che stai comprando consapevolmente); nessuna regola contraddice le due `rules/*.md` già in contesto.

**M7.** Applica la regola su `model:` esplicito nella prossima esecuzione reale di `subagent-driven-development`.
*Verifica:* nel transcript, **ogni** dispatch di subagent contiene un campo `model:`. Confronta `lastCost` in `~/.claude.json` → `projects[...]` con quello di un plan di dimensione simile eseguito prima. **È l'intervento con il rapporto risparmio/rischio più alto della migrazione.**

**M8.** Scrivi `D:\ClaudeConfiguration\CLAUDE.md` col testo di §4.2.
*Verifica:* aprendo una sessione in questo repo, il file compare in `# claudeMd`.

### Stadio 3 — Rimettere i gate mancanti

**M9.** Correggi la riga 169 di `spec-driven-development` (l'anello rotto più costoso).
```diff
-Execute tasks one at a time, test-first (`superpowers:test-driven-development`). Hand execution to the F7 chain in `~/.claude/CLAUDE.md`: `superpowers:subagent-driven-development`, with `superpowers:executing-plans` as fallback.
+Execute tasks one at a time. Hand execution to `subagent-driven-development`, with
+`executing-plans` as the fallback when tasks are tightly coupled. Per `CLAUDE.md` §S7,
+every subagent dispatch sets `model:` explicitly.
```
*Verifica:* `rg -n 'superpowers:|F7 chain' ~/.claude/skills/spec-driven-development/SKILL.md` non restituisce nulla. Registra l'edit come **L5** in `skills-resync`, o un re-vendor lo perde.

**M10.** Cambia i path degli artefatti in `brainstorming` (riga 29, 107) e `writing-plans` (riga 18, 154): `docs/superpowers/{specs,plans}/` → `docs/{specs,plans}/`.
*Verifica:* `rg -n 'docs/superpowers' ~/.claude/skills/` non restituisce nulla. Registra come **L6**.

**M11.** Aggiungi `Spec ref:` allo Task Structure di `writing-plans`, dopo `**Files:**`.
*Verifica:* il template contiene la riga; il prossimo plan generato ce l'ha in ogni task.

**M12.** Aggiungi `## Review` ai contratti di spec e plan. È una modifica ai *template* dentro le due skill, non al codice.
*Verifica:* il prossimo spec e il prossimo plan hanno la sezione, vuota fino al gate.

### Stadio 4 — La fase 6, che oggi non esiste

**M13.** Inizializza Backlog MD in questo repo: `backlog init "ClaudeConfiguration" --defaults`, poi `backlog config set remoteOperations false` se il warning disturba.
*Verifica:* `backlog/config.yml` e `backlog/tasks/` esistono; `backlog task list` risponde.

**M14.** Scrivi la skill `backlog-tasks` (~80 righe). Corpo di partenza in `40-TARGET-HARNESS.md` §5.2, convertito da command a skill con una `description` model-invoked. Riabilita `skill-creator` per questa sessione e usa i suoi eval sulla description.
*Verifica:* dato un plan con 3 task, la skill produce 3 task Backlog, ognuna con **esattamente due** `references:`. Comando di verifica:
```bash
rg -c '^\s+- docs/' backlog/tasks/*.md   # deve stampare 2 per ogni file
```

**M15.** Crea `~/.claude/commands/` e i quattro command di §5 (opzionale, dato che li usi a mano).
*Verifica:* `/gate`, `/tasks`, `/harness-check`, `/review-report` compaiono nell'autocompletamento.

### Stadio 5 — Recuperare ciò che la potatura ha perso

**M16.** Recupera `finishing-a-development-branch` (30 invocazioni reali).
```bash
# Il plugin superpowers è disabilitato ma la cache è su disco:
cp -r ~/.claude/plugins/cache/claude-plugins-official/superpowers/6.2.0/skills/finishing-a-development-branch \
      ~/.claude/skills/
```
Poi applica l'edit L3 al file copiato: rimuovi i prefissi `superpowers:` e i path `../<skill>/`.
*Verifica:* `rg -n 'superpowers:|\.\./[a-z-]*/' ~/.claude/skills/finishing-a-development-branch/` non restituisce nulla. Aggiungi la riga alla tabella di `skills-resync` §superpowers, e **correggi la frase alla riga 54-57** che dichiara 6/14 vendorizzate: diventano 7/14.

**M17.** Decidi su `test-driven-development` e `verification-before-completion`. Non le recupero io: hanno zero invocazioni storiche, e recuperare per completezza è precisamente il **sediment** che `writing-great-skills` descrive.

**M18.** Decidi su `security-guidance` (1.779 invocazioni, disabilitato ieri). Se l'hai disabilitato per costo, resta off. Se per errore, riattivalo.

### Stadio 6 — Le disabilitazioni, e la cura per il costo cognitivo

**M19.** Aggiungi `disable-model-invocation: true` alle 7 skill di §6.3, **una per volta**, riscrivendo la `description` in forma human-facing (una riga, trigger rimossi).
*Verifica dopo ciascuna:* `/context` mostra `Skills:` in calo; dopo 10 sessioni reali, `skillUsage` non mostra un buco d'uso su un lavoro che quella skill copriva.

**M20.** Scrivi la router skill `/skills-map`: una sola skill user-invoked che elenca le 12 slash-only e quando raggiungerle. È la cura che `writing-great-skills` prescrive: *"When user-invoked skills multiply past what you can remember, that piled-up cognitive load is cured by a router skill."*
*Verifica:* `/skills-map` elenca tutte le skill con `disable-model-invocation: true` presenti su disco. Nessuna omessa.

**M21.** Restringi le tre description di §6.2 (`idea-refine`, `interview-me`, `incremental-implementation`).
*Verifica:* `rg -n 'stress-test|grill me' ~/.claude/skills/*/SKILL.md` restituisce solo `grilling/SKILL.md`.

**M22.** Rimuovi i 23 riferimenti pendenti (`30-CONFLICTS.md` §5), skill per skill.
*Verifica:* `/harness-check` (se creato in M15) riporta zero dangling reference. Aggiungi la sezione sui riferimenti `references/` a `skills-resync`, o un re-vendor li reintroduce tutti.

### Stadio 7 — Decisioni che sono tue, non mie

**M23.** Decidi su `explanatory-output-style` vs `ponytail` (`30-CONFLICTS.md` §2.2, opzioni A o B). 416 invocazioni: non è una decisione automatica.

**M24.** Decidi `O7` — l'intake di escalation (`40-TARGET-HARNESS.md` §3.6, opzioni A/B/C, raccomandata B). Poi emenda la regola 11 e aggiungi lo script di append. **Solo dopo** questo passo la regola 11 ha una destinazione.

**M25.** Emenda `rules/effort-escalation.md` con l'eccezione per implementer e reviewer (`30-CONFLICTS.md` §2.6).
*Verifica:* la regola nomina esplicitamente l'obbligo di `model:` esplicito.

### Stadio 8 — Chiudere il cerchio

**M26.** Allinea le copie versionate: `config/agents/`, `config/rules/`, e aggiungi al repo le due skill originali `consolidate-specs` e `consolidate-comments`, che **oggi esistono solo in `~/.claude/skills/`** e non sono versionate da nessuna parte.
*Verifica:* `diff -r` fra ogni copia nel repo e l'installata restituisce identico. Un commit che tocca un lato tocca l'altro.

**M27.** Misura. `/context` + delta di `skillUsage` contro `baseline-2026-08-01.md`.
*Criterio di accettazione:* `Skills:` scende, **e** nessuna skill che serviva ha smesso di sparare. Il secondo si vede solo nel delta dei conteggi.

---

## 3. Task Backlog MD

Formato **verificato empiricamente** su Backlog MD v1.45.1 in un repo temporaneo: front matter con `references:` da `--ref` ripetuto, sentinel `<!-- AC:BEGIN -->` / `<!-- DOD:BEGIN -->`, e la conferma che `--ac` non splitta sulla virgola. Nessuna ipotesi sul formato — per questo non chiedo conferma prima di generarle.

Prerequisito: **M13** (`backlog init`).

```bash
# ─── Stadio 0: rete di sicurezza ────────────────────────────────────────────
backlog task create "Snapshot harness state before migration" \
  -d "Copy settings.json, skills, agents, rules and the usage telemetry to a dated backup directory." \
  --ac "Backup directory contains settings.json plus the three trees" \
  --ac "usage-snapshot.json contains non-empty skillUsage and pluginUsage" \
  --dod "Restore tested: copying one file back produces no error" \
  --ref "docs/harness/50-MIGRATION.md#stadio-0--rete-di-sicurezza-prima-di-tutto" \
  --ref "docs/harness/40-TARGET-HARNESS.md#6-modifiche-di-configurazione" \
  --labels "harness-migration,stage-0" --priority high

backlog task create "Record token baseline" \
  -d "Run /context and record the per-category breakdown, in particular the Skills value." \
  --ac "docs/harness/baseline-2026-08-01.md exists and records the Skills token count" \
  --ref "docs/harness/50-MIGRATION.md#m1" \
  --ref "docs/harness/40-TARGET-HARNESS.md#73-come-verificarlo-empiricamente" \
  --labels "harness-migration,stage-0" --priority high

# ─── Stadio 1: costo zero, rischio nullo ────────────────────────────────────
backlog task create "Disable the four never-used enabled plugins" \
  -d "Set claude-code-setup, code-review, skill-creator and mcp-server-dev to false in enabledPlugins. All four have pluginUsage.usageCount 0 despite months enabled." \
  --ac "settings.json has the four plugins set to false" \
  --ac "/context shows a lower Skills value than the baseline" \
  --ac "A fresh session no longer announces their six skills" \
  --dod "No startup error in a fresh session" \
  --ref "docs/harness/40-TARGET-HARNESS.md#61-claudesettingsjson" \
  --ref "docs/harness/50-MIGRATION.md#m2" \
  --labels "harness-migration,stage-1,token-cost" --priority high \
  --dep TASK-1 --dep TASK-2

backlog task create "Remove the backlog MCP server" \
  -d "The backlog MCP is configured in ~/.claude.json and its instructions are injected every session, but it exposes zero tools. The CLI v1.45.1 covers the whole task contract." \
  --ac "mcpServers no longer contains backlog" \
  --ac "A fresh session has no ## backlog MCP instruction block" \
  --ac "backlog task list still works from Bash" \
  --ref "docs/harness/40-TARGET-HARNESS.md#64-il-server-mcp-backlog" \
  --ref "docs/harness/50-MIGRATION.md#m3" \
  --labels "harness-migration,stage-1,token-cost" --priority medium --dep TASK-1

backlog task create "Clean plugin cache residue and skill sediment" \
  -d "Remove three temp_git_* clone directories, the unregistered sorbh marketplace cache, and five development artefacts inside systematic-debugging that its body never cites." \
  --ac "No temp_git_* or sorbh directory under plugins/cache" \
  --ac "systematic-debugging contains six files, none of them test-pressure-* or CREATION-LOG.md" \
  --ref "docs/harness/40-TARGET-HARNESS.md#65-pulizia-del-filesystem-plugin" \
  --ref "docs/harness/50-MIGRATION.md#m4" \
  --labels "harness-migration,stage-1" --priority low --dep TASK-1

# ─── Stadio 2: il risparmio grande ──────────────────────────────────────────
backlog task create "Write the user-scope CLAUDE.md" \
  -d "Write ~/.claude/CLAUDE.md from the ready text: twelve precedence rules S0-S12 resolving the conflicts found in the audit. English, deliberately short — it is paid every turn." \
  --ac "A fresh session shows the file under # claudeMd" \
  --ac "No rule contradicts the two rules/*.md already in context" \
  --ac "S7 states the explicit-model requirement for every subagent dispatch" \
  --dod "The file is under 250 lines" \
  --ref "docs/harness/40-TARGET-HARNESS.md#41-claudeclaudemd--regole-di-harness-user-scope" \
  --ref "docs/harness/50-MIGRATION.md#m6" \
  --labels "harness-migration,stage-2" --priority high --dep TASK-3

backlog task create "Enforce explicit model on every subagent dispatch" \
  -d "The largest avoidable cost in the harness: with model opus[1m] as the session default, any dispatch without an explicit model: field inherits it. subagent-driven-development dispatches 2-12 subagents per task." \
  --ac "In the next real SDD run, every dispatch in the transcript carries a model: field" \
  --ac "lastCost for a comparable plan is measurably lower than before" \
  --dod "Routing follows the skill's Model Selection: cheapest tier for transcription, mid-tier floor for prose implementers and reviewers, most capable for the final whole-branch review" \
  --ref "docs/harness/30-CONFLICTS.md#41-la-ridondanza-piu-costosa-model-omesso" \
  --ref "docs/harness/50-MIGRATION.md#m7" \
  --labels "harness-migration,stage-2,token-cost" --priority high --dep TASK-6

backlog task create "Write the project-scope CLAUDE.md" \
  -d "This repo has no project instructions. Document that it is the versioned source of truth for the harness, the two-copy invariant against ~/.claude, and that the 22 vendored skills live outside the repo." \
  --ac "A session opened in this repo shows the file under # claudeMd" \
  --ac "The two-copy invariant is stated explicitly" \
  --ref "docs/harness/40-TARGET-HARNESS.md#42-dclaudeconfigurationclaudemd--project-scope-oggi-assente" \
  --ref "docs/harness/50-MIGRATION.md#m8" \
  --labels "harness-migration,stage-2" --priority medium --dep TASK-6

# ─── Stadio 3: rimettere i gate mancanti ────────────────────────────────────
backlog task create "Fix the broken spec-to-execution handoff" \
  -d "spec-driven-development line 169 points at the F7 chain in ~/.claude/CLAUDE.md (a 0-byte file) and at three skills with a superpowers: prefix that does not resolve since the plugin is disabled. This is the most expensive broken link in the chain." \
  --ac "rg -n 'superpowers:|F7 chain' on the skill returns nothing" \
  --ac "The edit is recorded as L5 in skills-resync, or a re-vendor loses it" \
  --dod "The replacement names subagent-driven-development and executing-plans without prefixes" \
  --ref "docs/harness/10-EVIDENCE.md#6--spec-driven-development" \
  --ref "docs/harness/50-MIGRATION.md#m9" \
  --labels "harness-migration,stage-3,dangling-ref" --priority high --dep TASK-6

backlog task create "Rename artifact paths off the disabled plugin name" \
  -d "brainstorming and writing-plans write under docs/superpowers/{specs,plans}/, naming a plugin that is disabled. Move to docs/{specs,plans}/." \
  --ac "rg -n 'docs/superpowers' over ~/.claude/skills returns nothing" \
  --ac "The edit is recorded as L6 in skills-resync" \
  --ref "docs/harness/40-TARGET-HARNESS.md#30-path-e-naming--tabella-normativa" \
  --ref "docs/harness/50-MIGRATION.md#m10" \
  --labels "harness-migration,stage-3" --priority medium --dep TASK-6

backlog task create "Add the traceability fields to the spec and plan contracts" \
  -d "Add Spec ref: to the writing-plans task structure, and a ## Review section to both the spec and plan templates so review findings survive the session." \
  --ac "The writing-plans task template contains a Spec ref: line" \
  --ac "The next generated plan carries Spec ref: in every task" \
  --ac "Both templates contain an empty ## Review section" \
  --ref "docs/harness/40-TARGET-HARNESS.md#32-contratto-del-plan" \
  --ref "docs/harness/50-MIGRATION.md#m11" \
  --labels "harness-migration,stage-3,traceability" --priority high --dep TASK-10

backlog task create "Wire the spec-reviewer and plan-reviewer gates into the chain" \
  -d "Phase 3 currently runs on brainstorming's inline self-review, which scores 57.4 and ends with 'just fix and move on'. Phase 5 has no gate at all. Both subagents already exist and cost ~170 tokens each." \
  --ac "CLAUDE.md S3 and S5 name the two subagents as the gate" \
  --ac "In the next full-workflow run, both are dispatched and their findings land in the ## Review sections" \
  --dod "No phase advances with blocking issues open" \
  --ref "docs/harness/20-COMPARISON.md#fase-3--specification-review" \
  --ref "docs/harness/40-TARGET-HARNESS.md#1-pipeline-del-workflow-principale" \
  --labels "harness-migration,stage-3,quality-gate" --priority high --dep TASK-6 --dep TASK-11

# ─── Stadio 4: la fase 6 ────────────────────────────────────────────────────
backlog task create "Initialize Backlog MD in this repository" \
  -d "No backlog/ directory exists here. Initialize it and disable remoteOperations if the no-remote warning is noisy." \
  --ac "backlog/config.yml and backlog/tasks/ exist" \
  --ac "backlog task list responds" \
  --ref "docs/harness/40-TARGET-HARNESS.md#33-contratto-della-task-backlog-md" \
  --ref "docs/harness/50-MIGRATION.md#m13" \
  --labels "harness-migration,stage-4" --priority high

backlog task create "Write the backlog-tasks skill" \
  -d "None of the 26 installed skills knows Backlog MD exists. This skill turns an approved plan into Backlog tasks, each carrying the two mandatory cross-references. Reads the plan only, never the spec." \
  --ac "Given a three-task plan, produces three Backlog tasks" \
  --ac "rg -c '^\\s+- docs/' over the created task files prints 2 for each" \
  --ac "One --ac per criterion — the flag does not split on commas" \
  --ac "Dependencies from the plan become --dep values" \
  --dod "The skill is under 100 lines and its description was checked with skill-creator's eval" \
  --ref "docs/harness/20-COMPARISON.md#fase-6--decomposizione-in-task-atomiche-e-gestione-nel-tempo-backlog-md" \
  --ref "docs/harness/40-TARGET-HARNESS.md#52-tasks--genera-le-task-backlog-dal-plan" \
  --labels "harness-migration,stage-4,new-skill" --priority high --dep TASK-14 --dep TASK-11

# ─── Stadio 5: recuperare ciò che è stato perso ─────────────────────────────
backlog task create "Recover finishing-a-development-branch" \
  -d "30 real invocations, the last on 2026-07-30 16:40 — the day before it was classified among the deliberately dropped skills. More used than systematic-debugging. Cited as the executor by the last operative line of subagent-driven-development." \
  --ac "The skill is present under ~/.claude/skills/" \
  --ac "rg -n 'superpowers:|\\.\\./[a-z-]*/' over it returns nothing (edit L3 applied)" \
  --ac "skills-resync lists it and its 6/14 sentence is corrected to 7/14" \
  --dod "A branch-integration run reaches the merge/PR/leave choice through the skill" \
  --ref "docs/harness/40-TARGET-HARNESS.md#0-evidenza-duso-reale--vincolo-di-progetto" \
  --ref "docs/harness/50-MIGRATION.md#m16" \
  --labels "harness-migration,stage-5,regression" --priority high --dep TASK-1

# ─── Stadio 6: disabilitazioni e router ─────────────────────────────────────
backlog task create "Move seven skills to slash-only invocation" \
  -d "security-and-hardening, code-simplification, context-engineering, systematic-debugging, consolidate-specs, consolidate-comments, dispatching-parallel-agents. Each pays its description every turn for work that is occasional. One at a time." \
  --ac "Each carries disable-model-invocation: true and a one-line human-facing description" \
  --ac "/context shows Skills lower after each" \
  --ac "systematic-debugging's two unique sections are in diagnosing-bugs before it is disabled" \
  --dod "After 10 real sessions, skillUsage shows no gap on work these skills covered" \
  --ref "docs/harness/40-TARGET-HARNESS.md#63-skill-da-spostare-a-disable-model-invocation-true" \
  --ref "docs/harness/50-MIGRATION.md#m19" \
  --labels "harness-migration,stage-6,token-cost" --priority medium --dep TASK-6

backlog task create "Write the skills-map router skill" \
  -d "After the migration there will be twelve slash-only skills. writing-great-skills names the router skill as the cure for that accumulated cognitive load." \
  --ac "/skills-map lists every skill on disk carrying disable-model-invocation: true" \
  --ac "No such skill is omitted" \
  --ref "docs/harness/20-COMPARISON.md#104-meta-authoring-dellharness" \
  --ref "docs/harness/50-MIGRATION.md#m20" \
  --labels "harness-migration,stage-6,new-skill" --priority medium --dep TASK-17

backlog task create "Disambiguate three colliding skill descriptions" \
  -d "interview-me, grilling and idea-refine all claim near-identical stress-test trigger phrases, so the model cannot choose deterministically. Also narrow incremental-implementation, whose trigger fires on almost any coding task." \
  --ac "rg -n 'stress-test|grill me' over the skills returns only grilling" \
  --ac "incremental-implementation's description names 'implementing a task from a plan'" \
  --ref "docs/harness/30-CONFLICTS.md#31-tre-skill-rivendicano-la-stessa-frase--il-caso-piu-netto" \
  --ref "docs/harness/50-MIGRATION.md#m21" \
  --labels "harness-migration,stage-6,trigger" --priority medium --dep TASK-1

backlog task create "Remove the 23 dangling references" \
  -d "Seventeen of them point at references/*.md files that vendoring never copied. skills-resync documents rewriting cross-skill references (edit L3) but not sibling-file references, so a re-vendor reintroduces them all." \
  --ac "No skill body points at a references/ path that does not exist" \
  --ac "No skill body names a slash command that does not exist" \
  --ac "skills-resync has a section covering references/ pointers" \
  --dod "Two pointers that are executable instructions, not citations, are reported as blocked rather than left inert" \
  --ref "docs/harness/30-CONFLICTS.md#5-riferimenti-pendenti--inventario-completo" \
  --ref "docs/harness/50-MIGRATION.md#m22" \
  --labels "harness-migration,stage-6,dangling-ref" --priority medium --dep TASK-1

# ─── Stadio 7: decisioni dell'utente ────────────────────────────────────────
backlog task create "DECISION: explanatory-output-style versus ponytail" \
  -d "Two enabled plugins contradict each other through the same SessionStart event: one mandates ★ Insight blocks before and after writing code, the other prescribes deleting explanation longer than the code. 416 invocations — not an automatic call." \
  --ac "A decision is recorded: disable the output style, or write the scope rule" \
  --ac "If the scope rule is chosen, CLAUDE.md S11 carries it" \
  --ref "docs/harness/30-CONFLICTS.md#22-explanatory-output-style-vs-ponytail--obbligo-di-prosa-esplicativa" \
  --ref "docs/harness/50-MIGRATION.md#m23" \
  --labels "harness-migration,stage-7,decision" --priority medium

backlog task create "DECISION: close O7, the escalation intake" \
  -d "Rule 11 mandates appending every flag to ~/.claude/escalations.md; the file does not exist and documentation-lifecycle.md tracks path, format and reference scheme as open decision O7. Three options; B (per-repo, versioned) is recommended because a churn-stable reference scheme cannot exist behind a global path." \
  --ac "O7 is decided and the choice is recorded in documentation-lifecycle.md" \
  --ac "Rule 11 is amended to match the decision" \
  --ac "The append script exists and read-before-append works" \
  --dod "consolidate-specs and consolidate-comments can name one fewer missing prerequisite" \
  --ref "docs/harness/40-TARGET-HARNESS.md#36-chiudere-o7--lintake-di-escalation" \
  --ref "docs/harness/30-CONFLICTS.md#29-regola-11-di-documentation-lifecycle-rulesmd--direttiva-senza-destinazione" \
  --labels "harness-migration,stage-7,decision" --priority medium

backlog task create "Amend effort-escalation with the subagent model exception" \
  -d "The rule says prefer haiku for bulk exploration delegated to subagents; subagent-driven-development says use a mid-tier model as the floor for reviewers and prose implementers. Both are right in their own domain, and the domains are distinguishable." \
  --ac "The rule names the exception for implementers and reviewers" \
  --ac "The rule states the explicit-model requirement" \
  --ref "docs/harness/30-CONFLICTS.md#26-effort-escalationmd-vs-subagent-driven-development-model-selection" \
  --ref "docs/harness/50-MIGRATION.md#m25" \
  --labels "harness-migration,stage-7" --priority medium

# ─── Stadio 8: chiudere il cerchio ──────────────────────────────────────────
backlog task create "Version the two unversioned original skills" \
  -d "consolidate-specs and consolidate-comments implement the documentation-lifecycle rules and exist only in ~/.claude/skills/. They are in no repository. A reset of ~/.claude loses them." \
  --ac "Both are under config/skills/ in this repo" \
  --ac "diff -r between each repo copy and the installed one is empty" \
  --dod "The two-copy invariant is stated in the project CLAUDE.md" \
  --ref "docs/harness/00-INVENTORY.md#71-il-repo-come-sorgente-di-verita-versionata" \
  --ref "docs/harness/50-MIGRATION.md#m26" \
  --labels "harness-migration,stage-8" --priority high --dep TASK-8

backlog task create "Measure the migration against the baseline" \
  -d "Acceptance is not 'tokens went down'. It is 'tokens went down AND no skill that was needed stopped firing'. The second is only visible in the skillUsage delta." \
  --ac "/context Skills value is compared against baseline-2026-08-01.md" \
  --ac "The skillUsage delta over 10 real sessions is recorded" \
  --ac "Any skill that stopped firing is either re-enabled or its absence is justified in one line" \
  --ref "docs/harness/40-TARGET-HARNESS.md#73-come-verificarlo-empiricamente" \
  --ref "docs/harness/50-MIGRATION.md#m27" \
  --labels "harness-migration,stage-8,verification" --priority high \
  --dep TASK-17 --dep TASK-2
```

**25 task, 8 stadi.** Le dipendenze (`--dep`) riflettono la sequenza di §2: nulla parte prima dello snapshot, nulla che tocchi un template parte prima del `CLAUDE.md`, e la misura finale dipende sia dal baseline sia dalle disabilitazioni.

**Nota sui numeri di TASK.** Gli id sono assegnati dalla CLI in ordine di creazione; i `--dep TASK-N` sopra assumono l'esecuzione dei comandi in questo ordine in un `backlog/` vuoto. Se il repo ha già task, i riferimenti vanno rinumerati — oppure si crea prima tutto e si aggiungono le dipendenze dopo con `backlog task edit`.

---

## 4. Rollback

### 4.1 Per stadio

| Stadio | Come si torna indietro | Costo |
|---|---|---|
| 0 | Niente da annullare | — |
| 1 (M2-M5) | `cp ~/claude-harness-backup-2026-08-01/settings.json ~/.claude/`. I plugin rimossi si reinstallano da marketplace: `/plugin install <name>@claude-plugins-official`. I residui di cache eliminati non servivano | minuti |
| 2 (M6-M8) | `rm ~/.claude/CLAUDE.md` e `rm D:\ClaudeConfiguration\CLAUDE.md`. La regola su `model:` è una pratica, non un file: si smette di applicarla | secondi |
| 3 (M9-M12) | `cp -r ~/claude-harness-backup-2026-08-01/skills/<name> ~/.claude/skills/`. Oppure `/skills-resync`, che ha il proprio backup in `$TMPDIR/skills-resync-backup/` | minuti |
| 4 (M13-M15) | `rm -rf backlog/` (o `git checkout` se già committato). La skill `backlog-tasks` si elimina | minuti |
| 5 (M16-M18) | `rm -rf ~/.claude/skills/finishing-a-development-branch`. Nessuna dipendenza la richiede in modo bloccante | secondi |
| 6 (M19-M22) | Rimuovi la riga `disable-model-invocation: true` e ripristina la `description` originale dal backup | minuti |
| 7 (M23-M25) | Le decisioni sono in file di testo. `git checkout` per il repo; il backup per `~/.claude/rules/` | minuti |
| 8 (M26-M27) | `git revert`. La misura non modifica nulla | minuti |

### 4.2 Rollback completo

```bash
cp -r ~/claude-harness-backup-2026-08-01/settings.json ~/.claude/
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/rules
cp -r ~/claude-harness-backup-2026-08-01/{skills,agents,rules} ~/.claude/
rm -f ~/.claude/CLAUDE.md
# ripristina mcpServers.backlog in ~/.claude.json dal usage-snapshot.json
cd D:\ClaudeConfiguration && git checkout -- . && git clean -fd
```

*Verifica del rollback:* una sessione nuova annuncia le stesse 21 skill invocabili di oggi, `/context` riporta `Skills: 5.4k`, e `~/.claude/CLAUDE.md` è di nuovo assente o vuoto.

### 4.3 Reti di sicurezza già presenti sul disco

Non dipendere solo da M0. Sono già lì:

| Meccanismo | Cosa copre |
|---|---|
| `~/.claude/backups/` | Directory di backup gestita dal CLI. Contenuto e retention non ispezionati in questo audit |
| `~/.claude/file-history/` | Cronologia delle modifiche ai file operate dagli agenti |
| `$TMPDIR/skills-resync-backup/` | Creato da `skills-resync` allo step 6, prima di ogni re-vendor |
| `~/.claude/plugins/cache/` | I plugin disabilitati restano su disco: riabilitare è una riga in `settings.json`, non una reinstallazione |
| `git` in `D:\ClaudeConfiguration` | Copre `config/agents`, `config/rules`, `config/skills`, `docs/`, e i due `CLAUDE.md` |
| `~/.claude.json` → `skillUsage` / `pluginUsage` | **Non è un backup ma è l'unico registro storico d'uso.** Non ripristinarlo mai da uno snapshot: sovrascriverebbe i conteggi accumulati dopo |

### 4.4 Il rischio che il rollback non copre

`git` e i backup coprono i file. **Non coprono la disciplina.** I tre interventi con il valore più alto — `model:` esplicito su ogni dispatch, i gate 3 e 5 dispacciati davvero, le task Backlog aggiornate durante il coding — sono pratiche, non configurazione: nessun hook le impone, nessun file le verifica.

L'unico presidio è un hook `PreToolUse` sui dispatch di subagent che rifiuti un dispatch senza `model:`. Oggi **non esiste nessun hook definito dall'utente**: `~/.claude/settings.json` non ha la chiave `hooks` e i quattro hook attivi vengono tutti da plugin. È il candidato naturale per una sessione successiva, con la skill built-in `update-config` (10 invocazioni reali) come strumento.

Fino ad allora, il presidio è `/harness-check` eseguito periodicamente, e il fatto che le regole stiano scritte in un `CLAUDE.md` che il modello legge a ogni turno.
