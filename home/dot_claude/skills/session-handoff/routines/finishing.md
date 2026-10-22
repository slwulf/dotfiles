# Finishing routine

**Trigger:** A task is ready for PR, publish, or deploy.

---

Until cleanup is confirmed, the hook line ends `— cleanup pending`:
`<Active|Paused>: <task name> — cleanup pending`.

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
4. Retire the task's pointer file (see `Retiring a memory file` in SKILL.md).
   The handoff file stays in `~/.claude/handoffs/`, Digest on top.
5. If no other task is active, say so; if others are paused, ask which to resume.
