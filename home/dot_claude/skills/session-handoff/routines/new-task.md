# New task routine

**Trigger:** User opens a session describing a new task — may include a
tracker ID, a description, or both. Trigger phrases: "start work on [thing]",
"new plan for [X]", "let's get started on [ID]", or any opening that
introduces work without an existing handoff.

---

## Step 1 — Discovery

- If the prompt includes a tracker ID and Claude has MCP access to that
  tracker, pull the ticket first and use it to populate the draft.
- If no tracker ID, or the tracker isn't accessible, prompt the user for
  details section by section — behavioral outcomes first, then
  testing/verification, then implementation details (what's pre-decided?),
  then open items. Ask one section at a time; don't front-load all questions
  at once.
- If the user's prompt already contains enough detail to draft a section,
  draft it without asking — confirm in the review step instead.

## Step 2 — Draft

Produce a draft plan following `templates/plan.md`:

- For implementation details: write only what's concretely known. Omit the
  section if nothing is pre-decided.
- For open items: include only if there are genuine gaps Claude couldn't
  determine from the ticket or user input. Omit if none.
- Present the full draft to the user before writing any file.

## Step 3 — Review loop

User reviews the draft and offers feedback. Iterate until the user says it's
final. The user has final say; Claude does not write the plan file without
explicit approval.

## Step 4 — Write plan file and prep handoff

Write the plan to `~/.claude/plans/[identifier].md`, where `[identifier]` is
the ticket ID (lowercased, hyphened) or a short slug if no ticket.

After writing, offer to create the session-handoff files for this task:
the pointer file, the handoff file, and the MEMORY.md hook line. The handoff
file should capture any decisions made during the drafting session — anything
discussed and resolved before the plan was finalized belongs there, not left
implicit.
