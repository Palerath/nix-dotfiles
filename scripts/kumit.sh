#!/usr/bin/env bash
# kumit - Commit and push changes in submodules and main repo
# Usage: kumit "commit message"

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if commit message provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Commit message required${NC}"
    echo "Usage: kumit \"your commit message\""
    exit 1
fi

COMMIT_MSG="$1"
MAIN_REPO_UPDATED=false

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

    cd "$submodule_path"

    # Check if there are changes
    if [[ -n $(git status -s) ]]; then
        echo -e "${YELLOW}Changes detected in: ${submodule_name}${NC}"
        git status -s

        # Add all changes
        git add -A

        # Commit
        git commit -m "$COMMIT_MSG"
        echo -e "${GREEN}Committed in ${submodule_name}${NC}"

        # Push
        if git push; then
            echo -e "${GREEN}Pushed ${submodule_name}${NC}\n"
            MAIN_REPO_UPDATED=true
        else
            echo -e "${RED}Failed to push ${submodule_name}${NC}\n"
            cd - > /dev/null
            exit 1
        fi
    else
        echo -e "${BLUE}No changes in ${submodule_name}${NC}"
    fi

    cd - > /dev/null
}

# Find the main repository root (not submodule root)
find_main_repo() {
    local current_dir="$PWD"

    # Check if we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        exit 1
    fi

    # Get current repo root
    local repo_root=$(git rev-parse --show-toplevel)

    # Check if this is a submodule by looking for .git file (not directory)
    if [ -f "$repo_root/.git" ]; then
        # We're in a submodule, find parent repo
        local git_dir=$(cat "$repo_root/.git" | sed 's/gitdir: //')
        # git_dir is relative to repo_root, so resolve it
        local abs_git_dir="$repo_root/$git_dir"

        # Parent repo is typically two levels up from .git/modules/submodule/path
        # Extract main repo path from gitdir
        local main_repo=$(echo "$abs_git_dir" | sed 's|/.git/modules/.*||')

        if [ -d "$main_repo/.git" ] && [ ! -f "$main_repo/.git" ]; then
            echo "$main_repo"
        else
            echo "$repo_root"
        fi
    else
        # We're in the main repo
        echo "$repo_root"
    fi
}

REPO_ROOT=$(find_main_repo)
echo -e "${BLUE}Main repository: ${REPO_ROOT}${NC}\n"
cd "$REPO_ROOT"

# Process all submodules
if [ -f .gitmodules ]; then
    # Get list of submodule paths
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')

    for submodule in $SUBMODULES; do
        if [ -d "$submodule" ]; then
            commit_submodule "$submodule"
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
