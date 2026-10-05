#!/usr/bin/env bash
# Check a project's memory dir: index entries resolve to files, every memory
# file is indexed, [[links]] resolve to a `name:` slug, the active task is
# first, and plans linked from handoffs exist.
# Prints each problem; exits 1 if any. Read-only.
# Usage: check-memory.sh [memory-dir]   (default: this directory's project memory)
set -u
dir=${1:-$HOME/.claude/projects/${PWD//[\/.]/-}/memory}
index=$dir/MEMORY.md
[ -f "$index" ] || { echo "no index: $index"; exit 1; }
bad=0
report() { echo "$1"; bad=1; }

while read -r f; do
  [ -f "$dir/$f" ] || report "index entry has no file: $f"
done < <(grep -o '](\([^)]*\.md\))' "$index" | sed 's/^](//; s/)$//')

for p in "$dir"/*.md; do
  f=${p##*/}
  [ "$f" = MEMORY.md ] && continue
  grep -qF "($f)" "$index" || report "file not in index: $f"
done

names=$(sed -n 's/^name: *//p' "$dir"/*.md | tr -d '"')
grep -on '\[\[[^]]*\]\]' "$dir"/*.md | while IFS=: read -r p n l; do
  t=${l#\[\[}
  t=${t%\]\]}
  grep -qxF -- "$t" <<<"$names" || echo "dangling link: ${p##*/}:$n $l"
done | grep . && bad=1

# session-handoff invariants
active=$(grep -cE '\(project_task_[^)]+\.md\) — Active:' "$index" || true)
[ "$active" -le 1 ] || report "multiple Active tasks ($active) in index"
if [ "$active" = 1 ]; then
  first=$(grep -m1 -E '\(project_task_[^)]+\.md\) — ' "$index")
  case $first in *' — Active:'*) ;; *) report "Active task is not the first task line in index" ;; esac
fi

# hook lines for pointer files should be discovery-only
while IFS= read -r line; do
  if printf '%s' "$line" | grep -qE '\(project_task_[^)]+\.md\)'; then
    if printf '%s' "$line" | grep -qE '(—\s+|;\s*)(next|plan|handoff):'; then
      f=$(printf '%s' "$line" | grep -oE 'project_task_[^)]+\.md')
      report "hook line for $f: contains old-format inline fields"
    fi
  fi
done < "$index"

for p in "$dir"/project_task_*.md; do
  [ -f "$p" ] || continue
  f=${p##*/}
  hf=$(grep '^Handoff:' "$p" | head -1 | sed 's/^Handoff:[[:space:]]*//')
  if [ -z "$hf" ]; then
    report "pointer $f: missing Handoff: field"
  else
    hp=${hf/#\~/$HOME}
    if [ -f "$hp" ]; then
      pf=$(sed -n 's/^Plan:[[:space:]]*//p' "$hp" | head -1 | grep -oE '^(~|/)[^ )]+')
      [ -z "$pf" ] || [ -f "${pf/#\~/$HOME}" ] || report "handoff $hf: plan not found: $pf"
    else
      report "pointer $f: handoff not found: $hf"
    fi
  fi
  grep -q '^Plan:' "$p" && report "pointer $f: contains Plan: field (belongs in handoff)"
done

exit $bad
