#!/usr/bin/env bash
# Report on a project's memory: the index verbatim, topic files by type, all
# handoffs and plans (* = mentioned in this project's memory), and the
# check-memory.sh result. Read-only.
# Usage: list-memory.sh [memory-dir]   (default: this directory's project memory)
set -u
dir=${1:-$HOME/.claude/projects/${PWD//[\/.]/-}/memory}
index=$dir/MEMORY.md
[ -f "$index" ] || { echo "no index: $index"; exit 1; }

# Frontmatter value: fm <file> <key>
fm() {
  awk -v k="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---" { exit }
    NR > 1 { sub(/^[ \t]+/, ""); if (index($0, k ":") == 1) { sub(k ":[ \t]*", ""); print; exit } }
  ' "$1" | sed 's/^"//; s/"$//'
}

if stat -c %y / >/dev/null 2>&1; then
  mtime() { stat -c %y "$1" | cut -c1-10; }
else
  mtime() { stat -f %Sm -t %F "$1"; }
fi

mentioned() { grep -qF -- "$1" "$dir"/*.md; }

fsize() { wc -c < "$1" | tr -d ' '; }
plural() { [ "$1" = 1 ] || echo s; }
human() {
  local b=$1 unit=KB div=1024 t
  if [ "$b" -lt 1024 ]; then echo "$b B"; return; fi
  [ "$b" -ge 1048576 ] && { unit=MB; div=1048576; }
  t=$((b * 10 / div))
  echo "$((t / 10)).$((t % 10)) $unit"
}

list_dir() {
  local p f mark b n=0 tot=0
  for p in "$1"/*.md; do
    [ -e "$p" ] || continue
    f=${p##*/}
    b=$(fsize "$p")
    n=$((n + 1))
    tot=$((tot + b))
    mark=' '
    mentioned "$f" && mark='*'
    printf '%s %s  %s  %s\n' "$mark" "$f" "$(mtime "$p")" "$(human "$b")"
  done
  if [ "$n" = 0 ]; then
    echo "  (none)"
  else
    echo "  total: $n file$(plural "$n"), $(human "$tot")"
  fi
}

echo "# Index ($index, $(human "$(fsize "$index")"))"
echo
cat "$index"

echo
alln=0
all=0
for p in "$dir"/*.md; do
  [ "${p##*/}" = MEMORY.md ] && continue
  alln=$((alln + 1))
  all=$((all + $(fsize "$p")))
done
echo "# Memory files ($alln file$(plural "$alln"), $(human "$all"))"
for want in user feedback project reference other; do
  out=
  n=0
  tot=0
  for p in "$dir"/*.md; do
    f=${p##*/}
    [ "$f" = MEMORY.md ] && continue
    t=$(fm "$p" type)
    case $t in user|feedback|project|reference) ;; *) t=other ;; esac
    [ "$t" = "$want" ] || continue
    b=$(fsize "$p")
    n=$((n + 1))
    tot=$((tot + b))
    out+="- $f  $(human "$b")"$'\n'"    $(fm "$p" description)"$'\n'
  done
  if [ -n "$out" ]; then
    printf '\n## %s (%s file%s, %s)\n%s' "$want" "$n" "$(plural "$n")" "$(human "$tot")" "$out"
  elif [ "$want" != other ]; then
    printf '\n## %s\n  (none)\n' "$want"
  fi
done

echo
echo "# Handoffs (~/.claude/handoffs; * = mentioned in this project's memory)"
list_dir "$HOME/.claude/handoffs"

echo
echo "# Plans (~/.claude/plans; * = mentioned in this project's memory)"
list_dir "$HOME/.claude/plans"

echo
echo "# Check"
chk=$(cd "$(dirname "$0")" && pwd)/check-memory.sh
if [ -x "$chk" ]; then
  "$chk" "$dir" && echo "clean"
else
  echo "skipped: $chk missing"
fi
exit 0
