---
name: session-handoff
description: >-
  Start and wrap-up routines for multi-session work. Start: "where did we
  leave off", "what's next", "pick up where we left off", "get started with
  <thing>", or any resume question at the start of a session. Wrap-up: "prep
  session handoff" or similar.
---

# Session handoff

Three stores, each with a distinct role:

- **`MEMORY.md` hook line** — discovery only. Always in context; one line per
  task, as terse as possible: the task's high-level name, just enough to
  recognise it by reference. Format: `- [<identifier>](project_task_<identifier>.md) — <Active|Paused>: <one-liner>`
- **Pointer file** (`project_task_<identifier>.md`) — restart context. Owns
  state, next step, open pins, unverified claims, shaky concepts, and path to
  the handoff file.
  Read at session start; retired when the task finishes.
- **Handoff file** (`~/.claude/handoffs/<identifier>-handoff.md`) — detail
  record. Decisions + rationale, step results, findings, sources, plan link.
  Open it when work needs depth. Lives outside `~/.claude/plans/`, which
  Claude Code sweeps by age. Becomes a permanent record when the task closes;
  the Digest (see Finishing) is its entry point after the pointer retires.

`<identifier>` is the task's ticket, short title, or branch, slugged
(`feat/x` → `feat-x`). Several tasks can be in flight; one is active. The
active hook line is first and starts `Active:`; the rest start `Paused:`.

**Pointer file template:**

    ---
    name: project_task_<identifier>
    description: <detail that expands the hook line>
    metadata:
      type: project
    ---

    State: <one or two lines>
    Next: <the next step>
    Pins:
    - <open pin>
    Unverified:
    - <claim that couldn't be checked against live state>
    Shaky:
    - <concept that still feels shaky>
    Handoff: ~/.claude/handoffs/<identifier>-handoff.md

`name`, `description`, and body are filled per task; `type: project` is fixed —
it's how the memory system categorizes pointer files. Omit `Unverified:` if
everything was checked, and `Shaky:` if no concept is shaky.

A listed pin is open. Closing a pin removes it from the list; anything worth
keeping about it goes in the handoff (Decisions or Findings).

**Example:**

    ---
    name: project_task_auth-middleware-rewrite
    description: Rewriting auth middleware to meet compliance requirements
    metadata:
      type: project
    ---

    State: API migration — plan done, no code yet, awaiting security review
    of token format. Branch main is clean.
    Next: Implement per plan — add auth middleware to 3 endpoints, update client SDK.
    Pins:
    - Awaiting security team review of JWT claims
    - Open: defer integration tests until staging env ready, or mock now?
    Unverified:
    - Staging env said to be ready "next week" — not checked this session
    Shaky:
    - Token refresh flow — re-explain at start
    Handoff: ~/.claude/handoffs/auth-middleware-rewrite-handoff.md

**Handoff file template:**

    Plan: ~/.claude/plans/<plan-file>.md

    ## Decisions
    <what was chosen and why — 3–5 sentences per decision, no code>

    ## Steps
    <step status and results as work progresses>

    ## Findings
    <discoveries, constraints, gotchas>

    ## Sources
    <docs, tickets, links consulted>

Omit `Plan:` if there is no plan.

---

## Start

1. Read the `Active:` hook line, then its pointer file. The pointer file is
   sufficient to orient — it has state, next step, and open pins. No pointer:
   ask what the work is, and offer to create the pointer and handoff file at
   wrap-up. If the user names a different in-flight task, make it active
   (see Switching).
2. Open the handoff file only when the work requires it — for detail on a
   specific decision, a prior finding, or a source.
3. Verify the pointer's state and next-step claims against live state: branch
   and git status for a branch, files for a path, a ticket's status through
   whatever tracker access the session has. Anything the session can't check
   (no tracker access, another machine) is reported as unverified.
4. Report tersely: where the work stands, the next step, open pins, shaky
   concepts. Open pins lead the session; none are dropped silently. A task
   marked `cleanup pending` is a pin.

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
   handoff path. No detail copied from the handoff file.
4. **Hook line.** Overwrite the task's `MEMORY.md` line:
   `- [<identifier>](project_task_<identifier>.md) — Active: <one-liner>`

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

When a task is ready for PR, publish, or deploy, confirm its cleanup in that
session or the next. Until then its hook line reads `<status> — cleanup pending`.

1. Check each plan-mode file linked from the handoff against `cleanupPeriodDays`
   (settings; default 30 days). Within 7 days of the cutoff, ask the user
   whether to save it before it sweeps or let it go (user handles the move;
   Claude surfaces the flag).
2. Write a Digest: one paragraph capturing the outcome and durable gotchas —
   not dropped decisions or transient state. Add it as `## Digest` at the top
   of the handoff file. Once the pointer is retired, the Digest is the file's
   entry point and makes it self-contained as a permanent record. Plan-mode
   files the handoff doesn't link are named to the user and either linked from
   the Digest or left to sweep.
3. Make the rest of the handoff file read as record. Remove sections that read
   as current (next steps, open pins, working-style reminders), or date them.
   Each unfinished pin moves to a successor task's handoff file or is dropped;
   a pin is dropped only after its closure is checked against live state or
   confirmed by the user. A linked plan-mode file may be swept; say so beside
   the link.
4. Retire the task's pointer file (see Retiring a memory file). The handoff
   file stays in `~/.claude/handoffs/`, Digest on top.
5. If no other task is active, say so; if others are paused, ask which to resume.

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
new location or plain words. Run `memory-report` to confirm no dangling links,
unindexed files, or orphaned index entries.
