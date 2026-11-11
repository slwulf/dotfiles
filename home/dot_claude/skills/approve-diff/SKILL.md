---
name: approve-diff
description: Use before presenting any edit for the user's approval — code, tests, config, or a small markdown edit (a few sentences within one or two paragraphs of one file) — whenever the user asks you to implement, fix, or change something. Sets how to split the change into diffs and what each diff shows. For drafting or revising prose across sections, use doc-review instead. Handoff, pointer, and memory files need no diff approval; session-handoff covers the handoff and pointer writes.
---

# Approve diff

Use this skill when you are about to show the user an edit for approval. The user
approves each diff before it lands, so the diff is the unit of review. Size and
order each diff so the user can evaluate it without digging for context.

Two kinds of edit don't follow this skill. Drafting or revising prose across
sections follows `doc-review`. Handoff, pointer, and memory files need no diff
approval, and `session-handoff` covers the handoff and pointer writes. Every
other edit follows this skill.

## Code and tests

Split an implementation into diffs that each cover one step in the path the data
takes, in the order the data flows. Start at the entry point and end at the code
that does the work.

When a diff calls something new, show that new code in the next diff. The call
and its target stay next to each other.

Present each diff in the format in `templates/diff.md`. Wait for approval before
you apply it or show the next one.

When writing tests, show one test for approval. Cover only what the user asked
the tests to cover.

## Small markdown edits

This section covers any markdown file that isn't a handoff, pointer, or memory
file. A small edit changes a few sentences within one or two paragraphs of one
file. Show it as one diff, with the filename, the line numbers, and the
surrounding text.

For wording, follow `doc-review` and the sentence rules in `CLAUDE.md`. Name
anything in the diff the user didn't agree to, such as changed wording or a
neighboring line you touched.

If the work is drafting or revising prose across sections, use `doc-review`.

## Config edits

Config is any file that sets how a system behaves, such as a settings file or a
flag definition. Show a change as one diff, with the filename, the line numbers,
and the surrounding keys. Group lines only when they form one logical setting.

Before you present the diff, check what else reads the key or file. Name anything
the change affects that the user didn't discuss, such as another environment, a
default that moves, or another consumer of the file. If nothing turns up, say
nothing.
