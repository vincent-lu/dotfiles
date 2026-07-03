# Dotfiles

Personal macOS development environment. Brewfile declares formulae, casks, and App Store apps; `git/` and `zsh/` hold dotfiles deployed as symlinks into `~/` by `install.sh`.

## Commands

| Task | Command |
|---|---|
| Install everything | `brew bundle` |
| Update Brewfile from system | `brew bundle dump --force` |
| Check what's missing | `brew bundle check --verbose` |
| Clean unlisted packages | `brew bundle cleanup` |
| Deploy dotfile symlinks | `./install.sh` (`--force` to back up real files in the way) |

## Layout

| Path | Deploys to | Notes |
|---|---|---|
| `git/gitconfig` | `~/.gitconfig` | Identity, colors, lfs |
| `git/gitignore` | `~/.gitignore` | Global excludesfile |
| `zsh/zshrc` | `~/.zshrc` | Sources `~/.zshrc.local` (untracked) last — secrets and machine-specific config go there, never in this repo |

## Rules

1. **Public repo** — never commit secrets, tokens, or personal paths. Memory is gitignored for this reason.
2. **Brewfile sections** — maintain the existing grouping: formulae, casks, App Store apps. Add new entries to the correct section, sorted alphabetically within each section.

## Skills

| Skill | Purpose |
|---|---|
| `/brewfile-audit` | Reconcile Brewfile against installed software — find gaps, research installability, update interactively |
