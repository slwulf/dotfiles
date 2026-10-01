---
name: session-handoff
description: Start and wrap-up routines for multi-session work. Start: "where did we leave off", "pick up where we left off", "get started with <thing>". Wrap-up: "prep session handoff" or similar. Use at the open and close of any session that continues or leaves unfinished work.
---

# Session handoff

Two stores. Each handoff file (`~/.claude/handoffs/<identifier>-handoff.md`)
holds one task's detail. Project memory holds one pointer per in-flight
task, plus state that can't be derived from the repo or the handoff file.
`CLAUDE.md` has the separation rule; this skill has the routines. Handoff
files stay out of `~/.claude/plans/`, which Claude Code sweeps by age. A
handoff file links its plan-mode file (`Plan:` line) and records the
decisions that plan produced.

`<identifier>` is the task's ticket, short title, or branch, slugged
(`feat/x` → `feat-x`).

Several tasks can be in flight; one is active. Pointers are one memory file
per task (`project_task_<identifier>.md`) and one `MEMORY.md` hook line
each. The active task's line is first and starts `Active:`; the rest start
`Paused:`.

## Start

1. Read the `Active:` hook line, then its memory file. No pointer: ask what
   the work is, and offer to create the pointer and handoff file at
   wrap-up. If the user names a different in-flight task, make it active
   (see Switching).
2. Read only the handoff file's `Resume` block (top 15 lines). Read deeper
   sections when the work needs them, not up front.
3. Verify the pointer and `Resume` claims against live state: branch and
   git status for a branch, files for a path, a ticket's status through
   whatever tracker access the session has. Anything the session can't
   check (no tracker access, another machine) is reported as unverified.
4. For each unfinished task whose handoff links a plan-mode file in
   `~/.claude/plans/`, compare the file's age to `cleanupPeriodDays`
   (settings; default 30). Within 7 days of the cutoff, ask the user
   whether to archive it.
5. Report tersely: where the work stands, the next step, open pins. Open
   pins lead the session; none are dropped silently. A task marked
   `cleanup pending` is a pin.

## Wrap-up

1. **Review, no writes.** Go through the session with the user: new
   concepts, decisions, findings, deferred items. Agree on what carries
   forward. A summary handed over for approval does not count as the
   review.
2. **Handoff file.** Refresh the `Resume` block (state, next step, open
   pins; 15 lines max). Add or update detail below it: step status and
   results, decisions already made (don't re-litigate), findings, sources,
   confidence. Replace sections that describe current state, next steps,
   or open pins instead of adding a session section beside them; date
   history sections. Create the file if none exists.
3. **Memory file.** Overwrite the task's memory file: next action,
   unverified claims, handoff path. No detail copied from the handoff
   file. It is a `project` memory.
4. **Hook line.** Overwrite the task's `MEMORY.md` line:
   `- [<identifier>](project_task_<identifier>.md) — Active: <status>; next: <step>; plan: <handoff path>`

Each write (steps 2–4) needs approval before it lands. If the Edit/Write
tool will show its own diff prompt (default permission mode), that prompt
is the approval; don't also paste the diff. If edits are auto-approved, or
you can't tell, show the diff as plain text in chat and wait for a reply.
Deletes and moves are writes too: list each path in the approval and run
them only after it.
Ask in plain text, not with `AskUserQuestion` straight after the diff: the
prompt UI hides it. Don't commit; the user commits.

## Switching

Being pulled to other work pauses the current task: run steps 2–4 for it
with `Paused:` in its hook line, then make the other task active (move its
line first, `Active:`). A new task gets a new handoff file and pointer. One
task is active at a time.

## Finishing

When a task is ready for PR, publish, or deploy, confirm its cleanup in
that session or the next. Until then its hook line reads
`<status> — cleanup pending`.

1. Write one paragraph of anything worth keeping long-term (the outcome
   and durable gotchas, not dropped decisions), drawn from the handoff
   file and its linked plan. Add it at the top of the handoff file as
   `## Digest` and remove the `Resume` block. Plan-mode files in
   `~/.claude/plans/` that belong to the task but no handoff links are
   named to the user: each is linked from the Digest or left to be swept.
2. Make the rest of the file read as record. Remove sections that read as
   current (next steps, open pins, "state right now", working-style
   reminders), or date them. Each unfinished pin moves to a successor
   task's handoff file or is dropped, and a pin is dropped only after
   its closure is checked against live state or confirmed by the user.
   A linked plan-mode file may be swept; say so beside the link.
3. Retire the task's memory file (below). The handoff file stays in
   `~/.claude/handoffs/`, Digest on top.
4. If no task is active, say so; if others are paused, ask which to resume.

## Retiring memory

Two cases retire a memory file:

- **Task finished.** The task's pointer (`project_task_<identifier>.md`).
- **Promoted.** A durable memory (`feedback`, `reference`, or a `project`
  file that isn't a task pointer) whose content now lives in an
  instruction file: the global `CLAUDE.md`, a project `CLAUDE.md`, or an
  area-level one. The destination must load everywhere the memory
  applied. If it covers less, keep the memory.

Delete the file and its `MEMORY.md` line, then search the memory dir for
the file's name and its `name:` slug. Replace each `[[link]]` hit with
the handoff path, the instruction file, or plain words, so nothing
dangles. Then run the `memory-report` skill; its check prints any
dangling link, unindexed file, or index entry with no file.

## Resume block

```markdown
## Resume
State: <one or two lines>
Next: <the next step>
Pins:
- <open pin>
```
