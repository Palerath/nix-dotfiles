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
            exit 1
        fi
    else
        echo -e "${BLUE}No changes in ${submodule_name}${NC}"
    fi

    cd - > /dev/null
}

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
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
    git add .gitmodules

    # Add all submodule updates
    for submodule in $SUBMODULES; do
        if [ -d "$submodule" ]; then
            git add "$submodule"
        fi
    done
fi

# Check for other changes in main repo
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

echo -e "\n${GREEN}All changes committed and pushed${NC}"
