# Claude Code

This is my Claude Code configuration, committed to git to be shared across my various projects. My global Claude file and a handful of custom skills define a structure that keeps working context low while retaining important project memory across sessions.

## How I work with Claude

The principles, briefly. [`CLAUDE.md`](CLAUDE.md) has the specifics.

- **Read-only by default.** Claude reads and searches freely. Every write (edits, commits, system changes) needs approval first.
- **Ground in real state.** Claude reads the actual system before designing against it, and checks for a built-in path before inventing one.
- **Small, paced steps.** When walking through something, Claude gives just enough for the next step, then waits.
- **Session handoff.** Multi-session work starts and wraps up through the `session-handoff` skill, which carries state across sessions through memory (below).

### Memory

Claude Code's built-in memory is a `MEMORY.md` index, loaded into every session, plus topic files that Claude reads on demand. `session-handoff` builds on that to keep in-session context small while task state survives a cleared context. Each task is split across three stores:

1. **Hook line** in `MEMORY.md`: one line per task, always loaded, just enough to recognize it.
2. **Pointer file**: State, next step and open pins (deferred items and open questions). Read at session start to resume.
3. **Handoff file** (`~/.claude/handoffs/`): Decisions, findings and sources. Opened only when the work needs depth.

After a clear, a new session sees only the `MEMORY.md` index and reads one pointer file to pick up where the last one stopped. Memory is local to each machine and not committed here.

## Skills

Custom skills live in [`skills/`](skills/).

- **`session-handoff`**: Start and wrap-up routines for multi-session work. Defines the memory breakdown described above.
- **`memory-audit`**: Reports on the current project's memory and checks it for inconsistencies. It works alongside `session-handoff`.
- **`doc-review`**: Takes a doc from skeleton to section-by-section draft to a final verification pass.
- **`hands-on-learning`**: A working mode for learning a new tool or codebase, where Claude guides and doesn't do the work for you.
