---
name: memory-audit
description: Report on the current project's memory — the MEMORY.md index, topic files by type, all handoffs and plans, and a consistency check. Use when the user asks to review, show, or list memory ("memory audit", "memory report", "memory review", "show me the memory index").
---

# Memory audit

Run the script with this project's memory directory (the path under
`~/.claude/projects/` from your context), then relay its output in the
reply. Tool output is not shown to the user; printing it in the reply is
the point of the skill.

    ~/.claude/skills/memory-audit/list-memory.sh <memory-dir>

Reply in the script's order, as formatted markdown rather than a code
block of raw output. Add no commentary beyond the report, and do not
alter the index text:

1. **Index.** A heading with its size, then `MEMORY.md` verbatim as a
   rendered list, first.
2. **Memory files.** A heading with count and total size. One subsection
   per type with its count and total; each file a bullet with the
   filename in bold, its size, and its full description.
3. **Handoffs and plans.** One heading each with count and total size,
   then a table: mentioned, file, modified, size. They are global, not
   per-project. The script's `*` becomes ✓ and a bold filename: this
   project's memory mentions the file by filename. A `[[link]]` to a file
   does not count.
4. **Check.** A heading with ✅ clean, or the findings from
   `check-memory.sh`.
5. **Separation of concerns.** Read each `project_task_*.md` pointer file
   and its hook line in the index. Flag: a hook line containing more than
   `<Active|Paused>: <one-liner>`, plus an optional trailing
   ` — cleanup pending` (e.g. a `next:`, `plan:`, or `handoff:`
   field, whether separated by `;` or `—`); a pointer file containing
   content beyond the template fields (State, Next, Pins, Unverified,
   Shaky, Handoff) — including old-format prose such as `**Why:**`/`**How to
   apply:**` blocks or inline summaries that belong in the handoff; a
   hook line whose one-liner is more than a terse task name; a pointer
   `description:` that only repeats its hook line.

The skill is read-only. Offer fixes for any findings and wait.
