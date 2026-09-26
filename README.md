# dotfiles

Personal dotfiles, managed with [chezmoi](https://chezmoi.io). `home/` is the chezmoi source directory (via `.chezmoiroot`); everything else in the repo root is ordinary scaffolding chezmoi never touches.

## Setup

```sh
git clone git@github.com:slwulf/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/migrate.sh
```

Works for both a fresh machine and one still running the old bash-era setup. The script installs chezmoi if it's missing, folds any pre-existing `secrets.sh`/`machine_specific.sh`/`path.sh` into `~/.zsh_local` if present, symlinks `~/.local/share/chezmoi` to this repo, and runs `chezmoi init --apply`. It'll ask before switching the default shell to zsh.

```sh
# Manual setup, skipping the script
ln -s ~/.dotfiles ~/.local/share/chezmoi
chezmoi init --apply
```
