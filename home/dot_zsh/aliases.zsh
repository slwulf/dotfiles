# dotfiles
alias dotfiles="cd $DOTFILES"
alias bp="${EDITOR:-nvim} $DOTFILES && chezmoi apply && echo \"Updated dotfiles\""
function sbp () { type "$1"; }

# shell
alias c="clear"
function path () { echo $PATH | tr -s ':' '\n'; }
function mkcd () { mkdir -p "$1" && cd "$1"; }
function mktouch () { mkdir -p "$(dirname "$1")" && touch "$1"; }
function file-sizes () { ls -lhS ${1:-'.'} | awk '{print $5,$9}'; }
function ports () { lsof -n -i:${1:-8080} | grep LISTEN; }
function kill-ports () { kill $(ports "$1" | awk '{print $2}'); }
function kill-name () { kill $(ps aux | grep "$1" | grep -v grep | awk '{print $2}'); }

# git
function prune () { git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D "$branch"; done }
alias update-fork-master="git fetch origin && git rebase origin/master"
alias update-fork-main="git fetch origin && git rebase origin/main"
function delete-branches () { git branch -D $(git branch | grep -E --color=never $1); }

# apps
function vsc() { if command -v codium &>/dev/null; then codium -r .; else code -r .; fi; }
function nm () { ./node_modules/.bin/${1} "${@:2}"; }
function repos() { cd ~/Repos/$1; }
