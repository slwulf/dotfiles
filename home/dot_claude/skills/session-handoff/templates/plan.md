# Plan file template

**Title line:** `# [ID]: [title]` when a tracker ID exists; `# [title]` otherwise.

**Metadata block (optional — omit entirely if no tracker):**

    **Ticket:** [URL]
    **Sprint:** ... | **Status:** ... | **Points:** ...

Omit fields that don't apply (e.g. no sprint in a GitHub project).

---

**Required sections:**

`## Behavioral / design outcomes` — bullet list of what this must do, in
behavioral terms. Acceptance criteria translated to outcomes, not
implementation steps.

`## Testing / verification` — bullet list of how you'd know it works. Edge
cases, states, breakpoints, analytics if relevant.

**Optional sections:**

`## Implementation details` — omit if nothing concrete is pre-decided. When
present: specific decisions already made, entry points, classes/files to use
as a base, API notes, translation notes. Subsections vary by what's known;
write only what's concrete.

`## Open items` — omit if there are none. When present: numbered, concrete,
actionable. Each item says what needs resolving and why it matters.

---

**Conventions:**

- Tone is oriented toward the user implementing. Claude surfaces information
  and flags gaps; doesn't design or plan for them.
- Where the task leaves choices open, discuss and decide before writing —
  don't leave forks in the plan.
