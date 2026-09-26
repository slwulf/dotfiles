# wip          -- commit all changes (incl. untracked) as "WIP" on current branch
# wip <branch> -- create <branch> from HEAD, switch to it, then commit WIP
# wip --reset  -- undo a "WIP" commit at HEAD on current branch
function wip () {
  local reset=false new_branch="" arg
  for arg in "$@"; do
    case "$arg" in
      --reset) reset=true ;;
      -h|--help)
        cat <<'EOF'
Usage: wip [<branch> | --reset]

  wip            commit all changes (incl. untracked) as "WIP" on current branch
  wip <branch>   create <branch> from HEAD, switch to it, then commit WIP
  wip --reset    undo a "WIP" commit at HEAD on current branch
  wip -h|--help  show this help
EOF
        return 0 ;;
      -*) echo "wip: unknown option: $arg" >&2; return 1 ;;
      *) new_branch="$arg" ;;
    esac
  done

  local current
  current=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "wip: not a git repository" >&2; return 1;
  }

  if [ "$reset" = true ]; then
    if [ -n "$new_branch" ]; then
      echo "wip: --reset takes no branch argument" >&2
      return 1
    fi
    local msg
    msg=$(git log -1 --pretty=%s 2>/dev/null)
    if [ "$msg" != "WIP" ]; then
      echo "wip: HEAD on '$current' is not a WIP commit (got: \"$msg\")" >&2
      return 1
    fi
    git reset HEAD~1
    return $?
  fi

  if [ -z "$(git status --porcelain)" ]; then
    echo "wip: nothing to commit" >&2
    return 1
  fi

  if [ -z "$new_branch" ]; then
    if [ "$current" = "main" ] || [ "$current" = "master" ]; then
      echo "wip: refusing to commit to '$current' — pass a branch name to create one" >&2
      return 1
    fi
    local confirm
    printf '%s' "wip: commit to '$current'? [Y/n] "
    read -r confirm
    case "$confirm" in
      ""|y|Y|yes|Yes|YES) ;;
      *) echo "Aborted"; return 1 ;;
    esac
  else
    if [ "$new_branch" = "main" ] || [ "$new_branch" = "master" ]; then
      echo "wip: refusing to use '$new_branch' as a branch name" >&2
      return 1
    fi
    git checkout -b "$new_branch" || return 1
  fi

  git add -A && git commit -m "WIP"
}
