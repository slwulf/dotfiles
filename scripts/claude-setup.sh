#!/bin/sh
# Sets up ~/.claude symlinks and base config from dotfiles

CLAUDE_DOTFILES="$DOTFILES/.claude"

printf "Setting up Claude config...\r\n"

mkdir -p "$HOME/.claude"

symlink_claude() {
  src="$CLAUDE_DOTFILES/$1"
  dst="$HOME/.claude/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "${dst}.bak"
    echo "  Backed up existing $1 to $1.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  Linked $1"
}

symlink_claude "CLAUDE.md"
symlink_claude "statusline-command.sh"
symlink_claude "skills/doc-review"

if [ ! -f "$HOME/.claude/settings.json" ]; then
  cp "$CLAUDE_DOTFILES/settings.json" "$HOME/.claude/settings.json"
  echo "  Copied base settings.json — add machine-specific settings as needed"
else
  echo "  settings.json already exists, skipping"
fi

printf "Done.\r\n"
