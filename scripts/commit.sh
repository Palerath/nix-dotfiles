#!/bin/bash
# Simple commit script for unified repository

set -e

DOTFILES_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
COMMIT_MSG="${1:-Update: $(date '+%Y-%m-%d %H:%M:%S')}"

cd "$DOTFILES_DIR"

git add -A
if ! git diff --cached --quiet; then
    git commit -m "$COMMIT_MSG"
    git push
    echo "✓ Changes pushed"
else
    echo "No changes to commit"
fi
