#!/bin/bash
# Simple update script for the unified repository

cd /home/perihelie/dotfiles

# Add all changes
git add -A

# Commit with message
COMMIT_MSG="${1:-Update: $(date '+%Y-%m-%d %H:%M:%S')}"
git commit -m "$COMMIT_MSG"

# Push to remote
git push

# Rebuild systems
echo "Rebuilding perikon..."
nh os switch '.' --hostname perikon

echo "Rebuilding linouce..."
nh os switch '.' --hostname linouce

echo "Done!"
