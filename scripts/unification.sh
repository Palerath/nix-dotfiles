#!/bin/bash
# Automated migration script to convert from submodules to unified repository

set -e

echo "=== NixOS Configuration Migration Script ==="
echo "This will convert your repository from submodules to a unified structure"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "flake.nix" ] || [ ! -f ".gitmodules" ]; then
    echo -e "${RED}Error: This doesn't appear to be the dotfiles root directory${NC}"
    echo "Please run this script from your dotfiles directory"
    exit 1
fi

DOTFILES_DIR=$(pwd)
echo -e "${BLUE}Working in: $DOTFILES_DIR${NC}"

# Step 1: Backup current state
echo -e "\n${BLUE}Step 1: Creating backup...${NC}"
BACKUP_DIR="../dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cp -r "$DOTFILES_DIR" "$BACKUP_DIR"
echo -e "${GREEN}✓ Backup created at: $BACKUP_DIR${NC}"

# Step 2: Clone submodules to temporary location
echo -e "\n${BLUE}Step 2: Cloning submodule contents...${NC}"
TEMP_DIR=$(mktemp -d)

# Clone each submodule
echo "Cloning estelle..."
git clone git@github.com:Palerath/dotfiles-estelle "$TEMP_DIR/estelle"

echo "Cloning perihelie..."
git clone git@github.com:Palerath/dotfiles-perihelie "$TEMP_DIR/perihelie"

echo "Cloning perikon..."
git clone git@github.com:Palerath/dotfiles-perikon "$TEMP_DIR/perikon"

echo "Cloning linouce..."
git clone git@github.com:Palerath/dotfiles-linouce "$TEMP_DIR/linouce"

# Step 3: Remove submodules
echo -e "\n${BLUE}Step 3: Removing git submodules...${NC}"

# Deinitialize submodules
git submodule deinit -f users/estelle
git submodule deinit -f users/perihelie
git submodule deinit -f hosts/perikon
git submodule deinit -f hosts/linouce

# Remove from git tracking
git rm -f users/estelle
git rm -f users/perihelie
git rm -f hosts/perikon
git rm -f hosts/linouce

# Clean up .git/modules
rm -rf .git/modules/users/estelle
rm -rf .git/modules/users/perihelie
rm -rf .git/modules/hosts/perikon
rm -rf .git/modules/hosts/linouce

echo -e "${GREEN}✓ Submodules removed${NC}"

# Step 4: Create directory structure
echo -e "\n${BLUE}Step 4: Creating new directory structure...${NC}"

mkdir -p users/estelle
mkdir -p users/perihelie
mkdir -p hosts/perikon
mkdir -p hosts/linouce
mkdir -p hosts/common
mkdir -p modules/nixos/desktop
mkdir -p modules/home-manager
mkdir -p scripts

# Step 5: Copy content from cloned repos
echo -e "\n${BLUE}Step 5: Copying content to new structure...${NC}"

# Copy user configs
cp -r "$TEMP_DIR/estelle/"* users/estelle/ 2>/dev/null || true
cp -r "$TEMP_DIR/perihelie/"* users/perihelie/ 2>/dev/null || true

# Copy host configs
cp -r "$TEMP_DIR/perikon/"* hosts/perikon/ 2>/dev/null || true
cp -r "$TEMP_DIR/linouce/"* hosts/linouce/ 2>/dev/null || true

echo -e "${GREEN}✓ Content copied${NC}"

# Step 6: Move common modules to shared location
echo -e "\n${BLUE}Step 6: Reorganizing shared modules...${NC}"

# Move desktop environments to shared modules
if [ -d "hosts/perikon/modules/desktop-env" ]; then
    mv hosts/perikon/modules/desktop-env/*.nix modules/nixos/desktop/ 2>/dev/null || true
fi

# Keep host-specific modules in place but update imports
echo -e "${GREEN}✓ Modules reorganized${NC}"

# Step 7: Update flake.nix
echo -e "\n${BLUE}Step 7: Updating flake.nix...${NC}"
# Backup old flake
cp flake.nix flake.nix.old
# Copy new flake (you'll need to adjust this based on the updated flake.nix artifact)
echo -e "${YELLOW}Note: Please manually update flake.nix with the new configuration${NC}"

# Step 8: Create new scripts
echo -e "\n${BLUE}Step 8: Creating management scripts...${NC}"

cat > scripts/commit.sh << 'EOF'
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
EOF

cat > scripts/rebuild-perikon.sh << 'EOF'
#!/bin/bash
set -e
echo "Rebuilding perikon..."
nh os switch '.' --hostname perikon
echo "✓ System rebuilt"
EOF

cat > scripts/rebuild-linouce.sh << 'EOF'
#!/bin/bash
set -e
echo "Rebuilding linouce..."
nh os switch '.' --hostname linouce
echo "✓ System rebuilt"
EOF

chmod +x scripts/*.sh
echo -e "${GREEN}✓ Scripts created${NC}"

# Step 9: Clean up
echo -e "\n${BLUE}Step 9: Cleaning up...${NC}"

# Remove .gitmodules
rm -f .gitmodules

# Clean up temp directory
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Cleanup complete${NC}"

# Step 10: Update .gitignore
echo -e "\n${BLUE}Step 10: Updating .gitignore...${NC}"

cat > .gitignore << 'EOF'
# Build results
result
result-*

# Temporary files
*~
*.swp
*.swo

# Hardware-specific files (regenerate on each machine)
# Commented out since we want to track these
# hosts/*/hardware-configuration.nix

# Secrets (if using sops-nix or similar)
secrets/*
!secrets/.gitkeep

# Backup files
*.old
*.backup

# Nix store links
/nix/store

# Lock files (optional - you may want to track this)
# flake.lock
EOF

echo -e "${GREEN}✓ .gitignore updated${NC}"

# Final summary
echo -e "\n${GREEN}=== Migration Complete ===${NC}"
echo ""
echo "Summary of changes:"
echo "  • Submodules removed and content integrated"
echo "  • New unified directory structure created"
echo "  • Management scripts added to scripts/"
echo "  • Backup created at: $BACKUP_DIR"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review and update flake.nix with the new configuration"
echo "  2. Update any import paths in configuration files"
echo "  3. Test the configuration with: nixos-rebuild build --flake ."
echo "  4. Commit changes: git add -A && git commit -m 'Migrate to unified structure'"
echo "  5. Archive old submodule repositories on GitHub"
echo ""
echo -e "${GREEN}The old submodule repositories can now be archived on GitHub.${NC}"
