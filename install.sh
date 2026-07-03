#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

link() {
  local target="$1" link_path="$2"
  local label="${link_path#$HOME/}"

  if [[ -L "$link_path" ]]; then
    local current
    current="$(readlink "$link_path")"
    if [[ "$current" == "$target" ]]; then
      echo "  ok  $label (already linked)"
      return
    fi
    echo "  fix $label (repointing symlink)"
    ln -sfn "$target" "$link_path"
    return
  fi

  if [[ -e "$link_path" ]]; then
    if $FORCE; then
      echo "  bak $label → ${link_path}.bak"
      mv "$link_path" "${link_path}.bak"
    else
      echo "  SKIP $label (real file exists; use --force to replace)"
      return
    fi
  fi

  ln -s "$target" "$link_path"
  echo "  new $label → $target"
}

echo "Dotfiles:"
link "$REPO_DIR/git/gitconfig" "$HOME/.gitconfig"
link "$REPO_DIR/git/gitignore" "$HOME/.gitignore"
link "$REPO_DIR/zsh/zshrc" "$HOME/.zshrc"

echo ""
echo "Done. Machine-local overrides go in ~/.zshrc.local (untracked)."
