#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v stow &> /dev/null; then
  echo "GNU Stow is required. Install with: brew install stow"
  exit 1
fi

echo "Stowing packages from $DOTFILES_DIR..."

for dir in "$DOTFILES_DIR"/*/; do
  package="$(basename "$dir")"
  echo "  $package"
  stow -t ~ -d "$DOTFILES_DIR" "$package"
done

echo "Done."
