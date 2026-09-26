#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# 1. Install chezmoi if missing
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  if command -v brew &>/dev/null; then
    brew install chezmoi
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y chezmoi
  else
    sh -c "$(curl -fsLS https://get.chezmoi.io)"
  fi
fi

# 2. Fold any pre-existing legacy bash-era files into ~/.zsh_local
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

# 3. Point chezmoi's default source dir at the real repo
if [ ! -e "$HOME/.local/share/chezmoi" ]; then
  mkdir -p "$HOME/.local/share"
  ln -s "$DOTFILES" "$HOME/.local/share/chezmoi"
fi

# 4. Apply
chezmoi init --apply

# 5. Offer the shell switch — never do this without confirmation
read -r -p "Switch default shell to zsh now? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chsh -s "$(command -v zsh)"
fi
