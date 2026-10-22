---
name: session-handoff
description: >-
  Start and wrap-up routines for multi-session work. Start: "where did we
  leave off", "what's next", "pick up where we left off", "get started with
  <thing>", or any resume question at the start of a session. Wrap-up: "prep
  session handoff" or similar.
---

# Session handoff

This skill uses sub-files for templates and routines. They are not
auto-loaded — SKILL.md directs Claude to read them on demand via Read.

- `templates/pointer.md` — pointer file format and example; read when creating or updating pointer files
- `templates/handoff.md` — handoff file format; read when creating or updating handoff files
- `templates/plan.md` — plan file schema (required/optional sections); read by `routines/new-task.md` when drafting a plan
- `routines/new-task.md` — new task workflow; read when New task fires or Start finds no pointer with new work
- `routines/finishing.md` — finishing routine; read when a task is ready for PR, publish, or deploy

---

## New task

When the user opens a session describing new work — a ticket ID, a task
description, or both — without an existing handoff to resume, read
`routines/new-task.md` and follow it.

---

## Data model

Three stores, each with a distinct role:

- **`MEMORY.md` hook line** — discovery only. Always in context; one line per
  task, as terse as possible: the task's high-level name, just enough to
  recognise it by reference. Format: `- [<identifier>](project_task_<identifier>.md) — <Active|Paused>: <task name>`
- **Pointer file** (`project_task_<identifier>.md`) — restart context. Owns
  state, next step, open pins, unverified claims, shaky concepts, and path to
  the handoff file.
  Read at session start; retired when the task finishes.
  See `templates/pointer.md` for format, field descriptions, and example.
- **Handoff file** (`~/.claude/handoffs/<identifier>-handoff.md`) — detail
  record. Decisions + rationale, step results, findings, sources, plan link.
  Open it when work needs depth. Lives outside `~/.claude/plans/`, which
  Claude Code sweeps by age. Becomes a permanent record when the task closes;
  the Digest (see Finishing) is its entry point after the pointer retires.
  See `templates/handoff.md` for format.

`<identifier>` is the task's ticket, short title, or branch, slugged
(`feat/x` → `feat-x`). Several tasks can be in flight; one is active. The
active hook line is first and starts `Active:`; the rest start `Paused:`.

---

## Start

1. Read the `Active:` hook line, then its pointer file. The pointer file is
   sufficient to orient — it has state, next step, and open pins. No pointer:
   if the user is describing new work, treat this as a new task (read
   `routines/new-task.md`). Otherwise ask what the work is. If the user names
   a different in-flight task, make it active
   (see Switching).
2. Open the handoff file only when the work requires it — for detail on a
   specific decision, a prior finding, or a source.
3. Verify the pointer's state and next-step claims against live state: branch
   and git status for a branch, files for a path, a ticket's status through
   whatever tracker access the session has. Anything the session can't check
   (no tracker access, another machine) is reported as unverified.
4. Report tersely: where the work stands and the next step. Raise a pin or
   unverified item only when it bears on the next step; the rest stay in the
   pointer file. Re-explain shaky concepts. A task marked `cleanup pending`
   is a pin.

## Wrap-up

1. **Review, no writes.** Go through the session with the user: new concepts,
   decisions, findings, deferred items. Agree on what carries forward. A
   summary handed over for approval does not count as the review. A concept
   review passed in by another skill (which new concepts feel solid, which
   shaky) settles the concepts; don't ask again.
2. **Handoff file.** Add or update detail: step status and results, decisions
   with rationale (what was chosen and why — 3–5 sentences, not code blocks or
   file lists), findings, sources. Link the plan with `Plan: <path>`;
   implementation patterns, file paths, code snippets, and detailed steps stay
   in the plan. Replace sections rather than appending a session section beside
   them; for sections that record completed work or past decisions, add a date
   to the section header. Create the file if none exists.
3. **Pointer file.** Overwrite with current state, next step, open pins,
   unverified claims, shaky concepts (concepts now solid drop off), and
   handoff path. No detail copied from the handoff file, and no git state
   (branch, tree state, commits); it's derived live at Start.
4. **Hook line.** Leave it unchanged unless the task's name or its
   Active/Paused status changed. It names the task and nothing else: no
   progress, state or next step (those live in the pointer file).
   `- [<identifier>](project_task_<identifier>.md) — Active: <task name>`

Each write (steps 2–4) needs approval before it lands. If the Edit/Write tool
will show its own diff prompt (default permission mode), that prompt is the
approval; don't also paste the diff. If edits are auto-approved, or you can't
tell, show the diff as plain text in chat and wait for a reply. Deletes and
moves are writes too: list each path in the approval and run them only after
it. Ask in plain text, not with `AskUserQuestion` straight after the diff: the
prompt UI hides it. Don't commit; the user commits.

### Switching

Being pulled to other work pauses the current task: run wrap-up steps 2–4 for
it with `Paused:` in its hook line, then make the other task active (move its
line first, `Active:`). A new task gets a new handoff file and pointer. One
task is active at a time.

## Finishing

Read `routines/finishing.md` when a task is ready for PR, publish, or deploy.

## Retiring a memory file

A memory file is retired in two cases:

**Task finished** — retire the pointer after Finishing step 4.

**Content promoted** — the memory's content now belongs somewhere more
appropriate. Where depends on the content's nature and audience:

- Guidance Claude should always apply → a `CLAUDE.md` (global, project, or
  area-level) or skill file
- Team-wide reference → committed documentation or an external knowledge base
- Task-specific context that outlives the session → the task tracker or the
  relevant handoff file
- No longer relevant to anyone → drop it

The test: will the right person or agent find it there when they need it? If
yes, the memory is redundant. If the content is durable and has no better home
yet, keep it.

**Partial obsolescence:** If a memory has both obsolete and useful content,
extract the useful part into a new focused memory first, then retire the
original.

To retire: delete the file and its `MEMORY.md` line. Search the memory
directory for the file's `name:` slug; replace each `[[link]]` hit with the
new location or plain words. Run `memory-audit` to confirm no dangling links,
unindexed files, or orphaned index entries.
