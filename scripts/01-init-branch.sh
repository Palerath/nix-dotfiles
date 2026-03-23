#!/usr/bin/env bash
# 01-init-branch.sh
# Creates the feat/dendritic branch and new directory skeleton.
# Run from the dotfiles repo root.
# Usage: bash scripts/01-init-branch.sh

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

# ── Sanity checks ─────────────────────────────────────────────────────────────
if ! git diff --quiet HEAD 2>/dev/null; then
    echo "ERROR: Uncommitted changes. Stash or commit first."
    exit 1
fi

BRANCH="feat/dendritic"
if git show-ref --quiet "refs/heads/$BRANCH"; then
    echo "Branch $BRANCH already exists. Checking out."
    git checkout "$BRANCH"
else
    git checkout -b "$BRANCH"
    echo "Created branch: $BRANCH"
fi

# ── Directory skeleton ─────────────────────────────────────────────────────────
# These dirs live in the public repo.
# hosts/* and users/* stay as submodules — do NOT create them here.
DIRS=(
    modules/system
    modules/home
    modules/pkgs
    modules/overlays
    modules/common
)

for d in "${DIRS[@]}"; do
    mkdir -p "$d"
    echo "  created $d"
done

# Keep git from ignoring empty dirs during development
for d in "${DIRS[@]}"; do
    touch "$d/.gitkeep"
done

echo ""
echo "Done. Next step: run 02-wrap-system-modules.sh"
