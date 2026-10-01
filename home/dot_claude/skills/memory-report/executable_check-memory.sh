#!/usr/bin/env bash
# Check a project's memory dir: index entries resolve to files, every memory
# file is indexed, and [[links]] resolve to a `name:` slug.
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

exit $bad
