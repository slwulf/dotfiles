# 💩
export DOTFILES=~/.dotfiles
source "$DOTFILES/prompt.sh"

### add-ons that don't get checked into git
# secrets.sh -- user-generated secrets
# machine_specific.sh -- commands/aliases specific to a given terminal
# path.sh -- machine-generated path/pref updates
touch "$DOTFILES/secrets.sh" && source "$DOTFILES/secrets.sh"
touch "$DOTFILES/machine_specific.sh" && source "$DOTFILES/machine_specific.sh"
touch "$DOTFILES/path.sh" && source "$DOTFILES/path.sh"

# handy shit
alias c="clear"
alias ls="ls -G"
alias dotfiles="cd $DOTFILES"
alias vsc="code -r ."
function mkcd () { mkdir -p "$1" && cd "$1"; }
function mktouch () { mkdir -p "$(dirname "$1")" && touch "$1"; }
alias bp="vim $DOTFILES && source ~/.bashrc && echo \"Updated bash config\""
function sbp () { type "$1"; }
function file-sizes () { ls -lhS ${1:-'.'} | awk '{print $5,$9}'; }
function ports () { lsof -n -i:${1:-8080} | grep LISTEN; }
function kill-ports () { kill $(ports "$1" | awk '{print $2}'); }
function kill-name () { kill $(ps aux | grep "$1" | awk '{print $2}'); }
function nm () { ./node_modules/.bin/${1} "${@:2}"; }
alias path="echo $PATH | tr -s ':' '\n'"

# git shit
alias prune="git fetch -p && for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do git branch -D $branch; done"
function delete-branches () { git branch -D $(git branch | grep -E --color=never $1); }
alias update-fork-master="git fetch origin && git rebase origin/master"
alias update-fork-main="git fetch origin && git rebase origin/main"

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
    read -rp "wip: commit to '$current'? [y/N] " confirm
    case "$confirm" in
      y|Y|yes|Yes|YES) ;;
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

# osx shit
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias dockspace="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}' && killall Dock"

# typos
alias rpsec="rspec"

# we don't use zsh in this house sorry
export BASH_SILENCE_DEPRECATION_WARNING=1
