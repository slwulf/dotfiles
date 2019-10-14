#💩

export DOTFILES=~/.dotfiles
source "$DOTFILES/prompt.sh"
touch "$DOTFILES/machine_specific.sh" && source "$DOTFILES/machine_specific.sh"
touch "$DOTFILES/secrets.sh" && source "$DOTFILES/secrets.sh"

# handy shit
alias c="clear"
alias ls="ls -G"
alias dotfiles="cd $DOTFILES"
function mkcd () { mkdir -p "$1" && cd "$1"; }
function mktouch () { mkdir -p "$(dirname "$1")" && touch "$1"; }
alias bp="vim $DOTFILES && source ~/.bashrc && echo \"Updated bash config\""
function sbp () { type "$1"; }
function file-sizes () { ls -lhS ${1:-'.'} | awk '{print $5,$9}'; }
function kill-name () { kill $(ps aux | grep "$1" | awk '{print $2}'); }
function ports () { lsof -n -i:${1:-8080} | grep LISTEN; }
function kill-ports () { kill $(ports "$1" | awk '{print $2}'); }
function nm () { ./node_modules/.bin/${1} "${@:2}"; }
function serve() { npx static-server; }
alias prune="git fetch -p && for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do git branch -D $branch; done"
alias path="echo $PATH | tr -s ':' '\n'"
function repos () { cd ~/Repos/"$1"; }
function repo () { repos "$1" && code -r .; }
function delete-branches () { git branch -D $(git branch | grep -E $1); }

# osx shit
alias hfShow='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hfHide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias dockspace="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}' && killall Dock"

# fun shit
alias weather="curl wttr.in/philadelphia"
alias shruggie="echo '¯\_(ツ)_/¯' | pbcopy"
alias shrugmd="echo '¯\\\_(ツ)\_\/¯' | pbcopy"
tableflip () {
  tables=("(ﾉಥ益ಥ）ﾉ﻿ ┻━┻" "(ノಠ益ಠ)ノ彡┻━┻" "(╯°□°）╯︵┻━┻");
  RANDOM=$$$(date +%s)
  table=${tables[$RANDOM % ${#tables[@]}]};
  echo $table;
}
fliptables () {
  for run in {1..10}
  do
    tableflip
  done
}
flip-many-tables () {
  while true
  do
    tableflip
  done
}
alias partyizer="$DOTFILES/scripts/partyizer.js"

# command line https
http-get () { curl "$1"; }
http-post () { curl --data "$1" "$2"; }
http-post-json () {
  curl -H "Content-Type: application/json" -X POST -d "$1" "$2";
}

# typos
alias rpsec="rspec"

# environment vars
export NODE_ENV="development"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/.rvm/bin"
