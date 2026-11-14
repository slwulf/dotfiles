---
name: stage-commits
description: >-
  Split the working copy into discrete, isolated commits and stage them one
  at a time for the user to commit. Use when the user asks to break up,
  split, or organize the working copy into commits, or to stage patches for
  a commit log.
---

# Stage commits

**Never commit.** Claude only stages. The user runs every `git commit`,
including amends. Do not commit, amend, or push.

Claude proposes a commit log, the user settles it, and Claude stages one
group at a time. The user commits each group before Claude stages the next.

## Survey

Read the whole working copy before proposing any group:

```
git status --short
git diff
git ls-files --others --exclude-standard
```

Read each untracked file in full. When a hunk removes or renames something,
grep for its remaining uses.

Note any file or hunk that fits no group, such as an unrelated fix or
leftover side work. Raise it in the proposal and ask where it goes. Do not
guess.

## Propose groups

Propose the commit log as a numbered list of groups. Each group becomes one
commit:

- Give each group a one-line scope and its files.
- Each group makes sense on its own: a reader of the log, or a revert, can
  take it alone. Pieces that are inert or incomplete until the others land
  are one group.
- Each commit builds and works without the later ones. A commit never uses
  something a later commit adds.
- Group by purpose, not by file or layer.
- A file can hold changes for more than one purpose. Assign changes by hunk,
  not by file. When one hunk mixes purposes, split it further. Name each
  file that more than one group shares.
- List what stays unstaged: the files and hunks that fit no group.

Do not write commit messages. The user writes them.

## Settle the plan

The user may merge, split, reorder or drop groups, or move a leftover into a
group. Apply each change, and say so if a reorder makes a commit use
something from a later one.

When the user stops adjusting, restate the final order and the list that
stays unstaged. Agreement on that list is the approval to stage every group
in it, one at a time. Do not stage before then.

## Stage one commit

Stage the changes of one group only:

- **Whole files:** `git add <path>`, by name. Never `git add -A` or
  `git add .`.
- **Partial files:** write a patch with only the group's hunks, taken from
  `git diff` with the file header kept, and apply it with
  `git apply --cached <patch>`. Put the patch in the scratchpad.
- **A hunk that mixes purposes:** edit the patch to keep only the group's
  lines, and add `--recount` so git recomputes the hunk header counts.

Use patches, not `git add -p`, which needs an interactive terminal.

After staging, check that the index holds only this group. Report a digest:
the `git diff --cached --stat` output, and one line per file on what it
contributes to the group. Then stop and wait for the user to commit.

## Advance

After staging the first group, start a `Monitor` on `HEAD` without offering
it. Poll `git rev-parse HEAD`, and print `git log --oneline -1` when it
changes. Run the loop from the repo root. Use the longest timeout, and
re-arm on expiry while groups remain. If `Monitor` or `TaskStop` is a
deferred tool, load it with `ToolSearch` first.

On each new commit:

1. Run `git show --stat --format=%h HEAD` and `git status --short`.
2. Compare the commit with the plan. If it differs, for example by an amend,
   a merged group or a changed file, report it in one line. Don't ask about
   it. The user usually did it on purpose.
3. Re-derive the remaining groups from `git status`. Drop any group that the
   commit already holds.
4. Stage the next remaining group and report its digest, as in "Stage one
   commit".

The settled plan is the approval to stage. A watcher event only tells Claude
that `HEAD` moved.

## Finish

When no group remains, stop the watcher with `TaskStop`.

Report what is left unstaged: the files and hunks that were excluded from the
plan. Do not stage, commit or discard them.

