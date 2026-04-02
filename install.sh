#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v stow &> /dev/null; then
  echo "GNU Stow is required. Install with: brew install stow"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: install.sh <package> [package ...]"
  echo "Available packages:"
  for dir in "$DOTFILES_DIR"/*/; do
    name="$(basename "$dir")"
    [ "$name" = "docs" ] && continue
    echo "  $name"
  done
  exit 1
fi

for package in "$@"; do
  if [ "$package" = "docs" ]; then
    echo "Error: 'docs' is not an installable package"
    exit 1
  fi
  if [ ! -d "$DOTFILES_DIR/$package" ]; then
    echo "Error: package '$package' not found in $DOTFILES_DIR"
    exit 1
  fi
  echo "Stowing $package..."
  stow -t ~ -d "$DOTFILES_DIR" "$package"
done

echo "Done."
