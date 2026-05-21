# Dotfiles

Personal macOS development environment managed via Homebrew. Brewfile declares formulae, casks, and App Store apps.

## Commands

| Task | Command |
|---|---|
| Install everything | `brew bundle` |
| Update Brewfile from system | `brew bundle dump --force` |
| Check what's missing | `brew bundle check --verbose` |
| Clean unlisted packages | `brew bundle cleanup` |

## Rules

1. **Public repo** — never commit secrets, tokens, or personal paths. Memory is gitignored for this reason.
2. **Brewfile sections** — maintain the existing grouping: formulae, casks, App Store apps. Add new entries to the correct section.
