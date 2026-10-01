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

# kssh -- launch a kitty session ssh'd into $KSSH_HOST, close the window it was launched from
function kssh () {
  if [[ -n $SSH_CLIENT || -n $SSH_TTY ]]; then
    echo "kssh: already in an ssh session — run this from the local machine" >&2
    return 1
  fi

  if [ -z "$KSSH_HOST" ]; then
    echo "kssh: \$KSSH_HOST not set — add 'env KSSH_HOST=<alias>' to ~/.config/kitty/kitty-local.conf" >&2
    return 1
  fi

  if ! kitty @ ls >/dev/null 2>&1; then
    echo "kssh: kitty remote control unavailable — check allow_remote_control/listen_on in ~/.config/kitty/kitty-local.conf" >&2
    return 1
  fi

  local resolved
  resolved=$(ssh -G "$KSSH_HOST" 2>/dev/null | awk '/^hostname /{print $2; exit}')
  if [ -z "$resolved" ] || [ "$resolved" = "$KSSH_HOST" ]; then
    echo "kssh: no usable 'Host $KSSH_HOST' entry in ~/.ssh/config" >&2
    return 1
  fi

  local template="$HOME/.config/kitty/sessions/ssh.session"
  if [ ! -f "$template" ]; then
    echo "kssh: missing session template at $template" >&2
    return 1
  fi

  local tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/kssh-session.XXXXXX") || return 1
  sed "s/__KSSH_HOST__/$KSSH_HOST/g" "$template" > "$tmp"

  nohup kitty --session "$tmp" >/dev/null 2>&1 &
  disown
  ( sleep 5; rm -f "$tmp" ) &
  disown

  kitty @ close-window --match state:focused_os_window
}
