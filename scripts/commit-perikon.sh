#!/bin/bash

# Set default commit message if none is provided
COMMIT_MSG="$1"
if [ -z "$COMMIT_MSG" ]; then
   COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Base dotfiles directory
DOTFILES_DIR=~/dotfiles

# Function to commit and push a repo
commit_and_push() {
   local repo_path=$1
   echo "Processing $repo_path"

   cd "$repo_path" || { echo "Failed to enter $repo_path"; return; }

   git add -A
   if ! git diff --cached --quiet; then
      git commit -m "$COMMIT_MSG"
      git push
   else
      echo "No changes to commit in $repo_path"
   fi

   cd - > /dev/null || exit
}

# Commit and push submodules
commit_and_push "$DOTFILES_DIR/users/perihelie"
commit_and_push "$DOTFILES_DIR/hosts/perikon"

# Return to main repo to update submodule references if changed
commit_and_push "$DOTFILES_DIR"

