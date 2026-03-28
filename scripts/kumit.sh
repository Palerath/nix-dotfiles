#!/usr/bin/env bash
# kumit - Pull, update submodules, commit and push changes in submodules and main repo
# Usage: kumit ["commit message"]
# If no message provided, uses "update: <epoch_timestamp>"

set -e

# Find the dotfiles repository root
# This script assumes it's in dotfiles/scripts/
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set commit message: use provided message or generate default
if [ -z "$1" ]; then
    COMMIT_MSG="update: $(date -Iseconds)"
    echo -e "${BLUE}No message provided, using: ${COMMIT_MSG}${NC}\n"
else
    COMMIT_MSG="$1"
fi

MAIN_REPO_UPDATED=false

echo -e "${BLUE}=== Dotfiles Repository: ${DOTFILES_ROOT} ===${NC}\n"

# Navigate to dotfiles root
cd "$DOTFILES_ROOT"

# Pull latest changes from main repo
echo -e "${BLUE}Pulling latest changes from main repository...${NC}"
if git pull; then
    echo -e "${GREEN}Main repository updated${NC}\n"
else
    echo -e "${RED}Failed to pull from main repository${NC}"
    exit 1
fi

# Update all initialized submodules
echo -e "${BLUE}Updating initialized submodules...${NC}"
if git submodule update --remote --merge; then
    echo -e "${GREEN}Submodules updated${NC}\n"
else
    echo -e "${YELLOW}Warning: Some submodules may have failed to update${NC}\n"
fi

echo -e "${BLUE}Checking for changes in submodules...${NC}\n"

# Function to commit and push submodule
commit_submodule() {
    local submodule_path="$1"
    local submodule_name=$(basename "$submodule_path")

    # Check if submodule is initialized (has .git file or directory)
    if [ ! -e "$submodule_path/.git" ]; then
        echo -e "${BLUE}Skipping uninitialized submodule: ${submodule_name}${NC}"
        return 0
    fi

    # Save current directory
    local parent_dir="$PWD"

    cd "$submodule_path" || {
        echo -e "${RED}Failed to enter ${submodule_name}${NC}"
        return 1
    }

    # Check if there are changes (only in this submodule, not parent repo)
    if [[ -n $(git status -s) ]]; then
        echo -e "${YELLOW}Changes detected in: ${submodule_name}${NC}"
        git status -s

        # Add all changes
        git add -A

        # Commit (only if there's something staged)
        if git diff --cached --quiet; then
            echo -e "${BLUE}No changes to commit in ${submodule_name}${NC}"
        else
            git commit -m "$COMMIT_MSG"
            echo -e "${GREEN}Committed in ${submodule_name}${NC}"

            # Push
            if git push; then
                echo -e "${GREEN}Pushed ${submodule_name}${NC}\n"
                MAIN_REPO_UPDATED=true
            else
                echo -e "${RED}Failed to push ${submodule_name}${NC}\n"
                cd "$parent_dir" > /dev/null
                exit 1
            fi
        fi
    else
        echo -e "${BLUE}No changes in ${submodule_name}${NC}"
    fi

    cd "$parent_dir" > /dev/null
}

# Process all submodules
if [ -f .gitmodules ]; then
    # Get list of submodule paths
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')

    for submodule in $SUBMODULES; do
        # Only process if directory exists AND is initialized
        if [ -d "$submodule" ] && [ -e "$submodule/.git" ]; then
            commit_submodule "$submodule"
        elif [ -d "$submodule" ]; then
            echo -e "${BLUE}Skipping uninitialized submodule: $(basename "$submodule")${NC}"
        fi
    done
else
    echo -e "${BLUE}No submodules found${NC}"
fi

# Update main repository
echo -e "\n${BLUE}Checking main repository...${NC}"

# Update submodule references if any submodule was updated
if [ "$MAIN_REPO_UPDATED" = true ]; then
    # Add all submodule updates
    for submodule in $SUBMODULES; do
        if [ -d "$submodule" ] && [ -e "$submodule/.git" ]; then
            git add "$submodule"
        fi
    done
fi

# Check for other changes in main repo (excluding uninitialized submodules)
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}Changes detected in main repository${NC}"
    git status -s

    # Add all changes
    git add -A

    # Commit
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}Committed in main repository${NC}"

    # Push
    if git push; then
        echo -e "${GREEN}Pushed main repository${NC}"
    else
        echo -e "${RED}Failed to push main repository${NC}"
        exit 1
    fi
else
    echo -e "${BLUE}No changes in main repository${NC}"
fi

echo -e "\n${GREEN}All changes committed and pushed!${NC}"
