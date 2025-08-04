#!/bin/bash

# Usage: ./script.sh [commit_message]
# Example: ./script.sh "feat: add new hyprland configuration"
# Example: ./script.sh (uses default timestamp message)

# Set default commit message if none is provided
COMMIT_MSG="$1"
if [ -z "$COMMIT_MSG" ]; then
   COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Base dotfiles directory
DOTFILES_DIR="/home/perihelie/dotfiles"

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to commit and push a repo
commit_and_push() {
   local repo_path=$1
   local repo_name=$(basename "$repo_path")
   
   echo -e "${BLUE}Processing ${repo_name}...${NC}"
   
   if [ ! -d "$repo_path" ]; then
      echo -e "${RED}Directory $repo_path does not exist${NC}"
      return 1
   fi
   
   cd "$repo_path" || { echo -e "${RED}Failed to enter $repo_path${NC}"; return 1; }
   
   # Check if it's a git repository
   if [ ! -d ".git" ]; then
      echo -e "${YELLOW}$repo_path is not a git repository${NC}"
      cd - > /dev/null || exit
      return 1
   fi
   
   git add -A
   
   if ! git diff --cached --quiet; then
      echo -e "${GREEN}Committing changes in ${repo_name} with message: \"$COMMIT_MSG\"${NC}"
      git commit -m "$COMMIT_MSG"
      
      # Check if commit was successful
      if [ $? -eq 0 ]; then
         echo -e "${GREEN}Pushing changes for ${repo_name}...${NC}"
         git push
         if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully pushed ${repo_name}${NC}"
         else
            echo -e "${RED}✗ Failed to push ${repo_name}${NC}"
         fi
      else
         echo -e "${RED}✗ Failed to commit ${repo_name}${NC}"
      fi
   else
      echo -e "${YELLOW}No changes to commit in ${repo_name}${NC}"
   fi
   
   cd - > /dev/null || exit
   echo "" # Add spacing between repos
}

# Display the commit message that will be used
echo -e "${BLUE}=== Git Commit & Push Script ===${NC}"
echo -e "${BLUE}Commit message: ${GREEN}\"$COMMIT_MSG\"${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Array of all repositories to process
REPOS=(
   "$DOTFILES_DIR/users/perihelie"
   "$DOTFILES_DIR/users/estelle" 
   "$DOTFILES_DIR/hosts/perikon"
   "$DOTFILES_DIR/hosts/linouce"
   "$DOTFILES_DIR" # Main repo last to update submodule references
)

# Process each repository
for repo in "${REPOS[@]}"; do
   commit_and_push "$repo"
done

echo -e "${GREEN}=== All repositories processed ===${NC}"

# Optional: Update submodule references in main repo if any submodules changed
echo -e "${BLUE}Checking if submodule references need updating...${NC}"
cd "$DOTFILES_DIR" || exit

if ! git diff --quiet; then
   echo -e "${GREEN}Submodule references changed, committing main repo...${NC}"
   git add -A
   git commit -m "Update submodule references: $COMMIT_MSG"
   git push
   echo -e "${GREEN}✓ Main repo submodule references updated${NC}"
else
   echo -e "${YELLOW}No submodule reference changes to commit${NC}"
fi

echo -e "${GREEN}🎉 All done!${NC}"
