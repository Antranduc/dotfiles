#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v stow &> /dev/null; then
  echo "GNU Stow is required. Install with: brew install stow"
  exit 1
fi

OS="$(uname -s)"
LINUX_ONLY="sway"

echo "Stowing packages from $DOTFILES_DIR (OS: $OS)..."

for dir in "$DOTFILES_DIR"/*/; do
  package="$(basename "$dir")"
  if echo "$LINUX_ONLY" | grep -qw "$package" && [ "$OS" != "Linux" ]; then
    echo "  $package (skipped — Linux only)"
    continue
  fi
  echo "  $package"
  stow -t ~ -d "$DOTFILES_DIR" "$package"
done

echo "Done."
