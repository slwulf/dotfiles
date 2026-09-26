---
name: doc-review
description: Three-phase process for taking a doc (runbook, plan, procedure) from idea to ready — propose a skeleton, flesh it out section by section with the user, then run a fresh-eyes verification pass calibrated to the doc's actual reader before calling it done. Use whenever drafting or revising this kind of doc, not just at the end.
---

# Doc writing and review

A doc like a runbook or plan moves through three phases in order: **skeleton → section-by-section
draft → final verification pass**. Claude proposes moving to the next phase when the current one
looks done; the user confirms before it actually advances — never advance on your own judgment.

## Phase 1 — skeleton

Propose a rough outline, not prose: section headers plus a one-line summary of what belongs in
each, built from whatever's already been discussed or decided (in this conversation or in
memory) — don't invent new decisions at this stage, just structure what's already settled.

Scope it to **the clean, final end-state procedure only**. Leave out the mid-flight corrections,
dead ends, or "we originally tried X but then Y" narrative from however the decisions were
actually reached — that reasoning stays in chat/memory, not in the doc.

Present the skeleton and get corrections/reordering from the user before moving on. Once it's
settled, propose starting phase 2.

## Phase 2 — section-by-section draft

Work one section at a time, in doc order. Present a section — or, if it's long, break it into
smaller chunks rather than dropping the whole thing at once — close to verbatim, then stop and
wait for feedback before continuing. Don't dump the whole doc, don't pre-fix multiple sections at
once, and don't rush ahead to "the next obvious section" without a go-ahead, even if a fix
obviously implies a change elsewhere — flag the implication and wait for sign-off rather than
acting on it unasked.

Once a decision is made on a section, write it into the doc tersely — the full reasoning lives in
chat (and memory, for continuity), not repeated at length in the doc's prose.

Surface an inconsistency or gap the moment you notice it, even if it's in a section already
reviewed or one you're not currently working on — don't bank it for a later wrap-up. The cost of
sitting on a finding is a round-trip the user shouldn't have to ask for.

Docs meant to be read live under time pressure (a runbook executed on the day itself) need extra
terseness even at this stage — state the fix and, if needed, a one-line reason; leave the
investigation out of the doc.

Once the last section has been reviewed, propose starting phase 3.

## Phase 3 — final verification pass

This phase checks a doc believed complete for the gap between what it *says* and what would
actually happen if someone ran it — it's a verification pass, not more collaborative drafting.

### Establish the target audience first

Before reading the doc, state your best-guess read of who actually uses this doc and how,
inferred from its own stated purpose/framing, and get it confirmed or corrected — don't just
assume, since it changes what counts as a finding (what can be left implicit vs. must be spelled
out) and how strict the terseness needs to be. Cover both dimensions:
- **Reading conditions**: read live under time pressure (an incident runbook), read at
  leisure, or skimmed occasionally for reference.
- **Technical background of the reader**: the author's own future self with no memory of this
  context, a teammate who wasn't in these conversations, or someone with materially less
  familiarity with the system.

Keep this confirmed audience in mind for every finding and edit below — it's the yardstick for
"is this too verbose" or "does this need more explanation," not a one-time preamble.

### Read the whole doc first

Read start to finish, in order, before checking anything — as if you were the confirmed audience
about to act on it. Don't skim toward sections that "look risky" and don't stop mid-read to
verify — a full first pass catches structural issues (a step depending on a later step,
inconsistent terminology, a cross-reference to a section that doesn't exist) that only surface
when read the way the real reader will read it.

### Verify every concrete claim against ground truth

Go back through and check anything asserted as fact or instructed as a step: commands, file
paths, variable/flag names, version numbers, "X happens automatically" claims, ordering/dependency
assumptions between steps. Actually check each one — read the referenced source, grep for the
symbol, run the real read-only command, diff against the actual config — rather than judging it
plausible from the prose alone. Prose that *sounds* right is exactly what this pass exists to
catch.

Compile the complete findings list from this pass before presenting any of it — not to bank
them, just so the count and order in the next step are accurate. If something clearly needs
fixing turns up while checking an unrelated item, add it to the list rather than dropping it.

### Walk through findings one at a time

Present each as "issue N of M": what's wrong, a one-line reason, and a proposed fix. Wait for a
decision on that one finding before applying it or moving to the next — don't dump the whole list
at once and don't pre-apply fixes speculatively. If a fix implies a change elsewhere (a
renumbering, a cross-reference), say so but don't act on the implication without sign-off.

### Edit to match the confirmed audience

Apply confirmed fixes immediately, at the terseness/explanation level the audience call at the
top of this phase established. For a live-under-pressure reader, state the fix and nothing more.
For a less-familiar future reader, a fix may need one clause of context it wouldn't need for the
doc's own author. Either way, the investigation that got you to the fix stays in chat, not in the
doc.

### Close out

Once every finding is resolved, do one more pass over just the touched areas for consistency
(numbering, cross-references, terminology) — not a full second read-through. Summarize briefly:
how many issues found/fixed, and anything explicitly left as a known/deferred gap rather than
fixed now.
