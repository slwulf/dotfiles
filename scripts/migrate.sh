#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# Install chezmoi if missing
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  if command -v brew &>/dev/null; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
  fi
fi

# Fold any pre-existing legacy bash-era files into ~/.zsh_local
legacy_files=("$DOTFILES/secrets.sh" "$DOTFILES/machine_specific.sh" "$DOTFILES/path.sh")
found_legacy=false
for f in "${legacy_files[@]}"; do
  if [ -s "$f" ]; then
    found_legacy=true
    {
      echo "# --- folded from $(basename "$f") ---"
      cat "$f"
    } >> "$HOME/.zsh_local"
  fi
done
if [ "$found_legacy" = true ]; then
  echo "Folded legacy config into ~/.zsh_local"
fi
for f in "${legacy_files[@]}"; do
  rm -f "$f"
done

# Remove legacy setup.sh/claude-setup.sh symlinks, if present
legacy_symlinks=(
  "$HOME/.bashrc"
  "$HOME/.bash_profile"
  "$HOME/.profile"
  "$HOME/.config/tmux"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.claude/statusline-command.sh"
  "$HOME/.claude/skills/doc-review"
)
for link in "${legacy_symlinks[@]}"; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    rm -f "$link"
    echo "Removed dangling legacy symlink: $link"
  fi
done

# Point chezmoi's default source dir at the real repo
if [ ! -e "$HOME/.local/share/chezmoi" ]; then
  mkdir -p "$HOME/.local/share"
  ln -s "$DOTFILES" "$HOME/.local/share/chezmoi"
fi

# Apply
chezmoi init --apply

# Offer the shell switch — never do this without confirmation
read -r -p "Switch default shell to zsh now? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chsh -s "$(command -v zsh)"
fi
