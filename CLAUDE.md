# CLAUDE.MD - NixOS Family Configuration Project Context

## Project Overview

This is a NixOS configuration repository managing multiple family computers with varying technical expertise levels. The project transitioned from a complex submodule architecture to a unified repository with branch-based isolation, inspired by the Arch User Repository (AUR) model.

### Current Architecture Status
- **Repository Structure**: Single unified repository (no more submodules)
- **Branch Strategy**: Moving to AUR-style branch isolation where each user has their own permanent branch
- **Deployment Tool**: Using `nh` for system switching (`nh os switch`)
- **Target Users**: Mix of technical (admin/perihelie) and non-technical family members (estelle)

## Repository Structure

```
dotfiles/
├── flake.nix                    # Main flake managing all configurations
├── flake.lock                   # Shared dependency lock file
├── common/                      # Shared configurations
│   ├── default.nix
│   └── packages.nix            # Common packages (vlc, nh enabled)
├── hosts/                      # Machine-specific configurations
│   ├── perikon/               # Perihelie's main machine
│   │   └── configuration.nix
│   ├── linouce/               # Estelle's machine
│   │   └── configuration.nix
│   └── [other machines]
├── users/                      # User configurations
│   ├── perihelie/             # Admin user config
│   │   └── home.nix
│   ├── estelle/               # Non-technical user config
│   │   └── home.nix
│   └── [other users]
├── scripts/                    # Helper scripts
│   ├── commit-perikon.sh     # Multi-repo commit script (deprecated)
│   ├── kumit.sh              # Wrapper for commit script
│   └── maj-ordi.sh          # Update script for Estelle's computer
└── .gitignore                 # Excludes hardware-configuration.nix
```

## Branch Architecture Design

### Planned Branch Structure
```
main                           # Admin-only, contains shared files
├── shared-updates            # For flake.nix/flake.lock updates
├── user-perihelie           # Perihelie's isolated configuration
├── user-estelle             # Estelle's isolated configuration
└── user-[username]          # Other family members
```

### Branch Contents
Each user branch should contain:
- Their specific host configuration (`hosts/[hostname]/`)
- Their user configuration (`users/[username]/`)
- Shared files (`flake.nix`, `flake.lock`, `common/`)
- No other users' configurations

## Implementation Tasks

### Phase 1: Branch Setup (Current Priority)

1. **Create branch structure**
   ```bash
   # Create shared-updates branch from main
   git checkout -b shared-updates
   
   # Create user branches with only their files
   git checkout -b user-estelle
   # Remove other users' configs from this branch
   git rm -r users/perihelie hosts/perikon
   git commit -m "Initialize Estelle's isolated branch"
   ```

2. **Set up branch protection rules**
   - Protect `main` branch (admin only)
   - Protect user branches (user + admin access)
   - Document in repository settings

3. **Update deployment configuration**
   - Modify each host to track its user branch
   - Update `flake.nix` to work with branch-specific deployments

### Phase 2: Automation Setup

1. **Create synchronization workflow**
   - Script to sync `flake.nix` and `flake.lock` from `shared-updates` to user branches
   - GitHub Actions or local script for admin to run

2. **Update helper scripts**
   - Replace `commit-perikon.sh` with branch-aware version
   - Update `maj-ordi.sh` to work with Estelle's branch

3. **Conflict resolution procedures**
   - Document admin workflow for resolving flake.lock conflicts
   - Create merge helper scripts

## Key Constraints and Considerations

### Technical Constraints
1. **Flake Limitations**: NixOS flakes don't support sparse checkouts or partial repositories
2. **Lock File Synchronization**: `flake.lock` must be kept in sync across branches to prevent version conflicts
3. **Git Sparse Checkout**: Does NOT provide security isolation - all history remains accessible

### User Requirements
1. **Non-technical Users**: Must be able to:
   - Edit their own configuration files
   - Test changes locally with `nh os switch`
   - Commit and push changes without understanding git internals

2. **Admin Requirements**:
   - Handle all merge conflicts
   - Maintain shared dependencies
   - Push updates to user branches when needed

### Security Considerations
1. **No Secrets in Repository**: Never store passwords, API keys, or sensitive data
2. **Branch Isolation**: For convenience, not security (git history is always accessible)
3. **Future Secrets Management**: Consider sops-nix or agenix if needed

## Common Tasks

### For Users (e.g., Estelle)

```bash
# Update system after making changes
cd ~/dotfiles
git pull
# Edit configuration files
nh os switch '.?submodules=1' --hostname linouce

# Save changes
git add .
git commit -m "Update: description of changes"
git push
```

### For Admin (Perihelie)

```bash
# Update shared dependencies
git checkout shared-updates
nix flake update
git add flake.lock
git commit -m "Update flake inputs"
git push

# Sync to user branches
for branch in user-estelle user-perihelie; do
  git checkout $branch
  git checkout shared-updates -- flake.nix flake.lock
  git commit -m "Sync shared files from shared-updates"
  git push
done

# Resolve conflicts for users
git checkout user-estelle
git merge shared-updates
# Resolve conflicts manually
git add .
git commit -m "Resolved conflicts for Estelle"
git push
```

## Current Flake Structure

The main `flake.nix` currently defines:
- **nixosConfigurations**: `perikon` and `linouce`
- **homeConfigurations**: `perihelie`
- **Inputs**: nixpkgs, home-manager, nvf, hyprland, nix-colors, zen-browser

### Important Modules
- `nvf`: Neovim configuration framework
- `hyprland`: Wayland compositor
- `home-manager`: User environment management

## Migration Checklist

- [ ] Create branch structure
- [ ] Move existing configurations to appropriate branches
- [ ] Update deployment scripts
- [ ] Test deployments from branches
- [ ] Document new workflow for family members
- [ ] Set up automation for shared file synchronization
- [ ] Create conflict resolution procedures
- [ ] Update backup strategies

## Design Principles for Implementation

1. **Simplicity Over Complexity**: Keep workflows simple for non-technical users
2. **Fail-Safe Operations**: All changes should be reversible
3. **Clear Error Messages**: Scripts should provide helpful feedback
4. **Minimal Manual Git**: Users shouldn't need to understand git internals
5. **Automated Synchronization**: Reduce manual overhead for shared files

## Testing Strategy

Before deploying changes:
1. Test on a VM or spare machine first
2. Create rollback points before major changes
3. Document the rollback procedure
4. Test user workflows with family members

## References and Resources

- Current repository structure in `/home/perihelie/dotfiles/`
- NixOS manual: https://nixos.org/manual/nixos/stable/
- Home Manager manual: https://nix-community.github.io/home-manager/
- Git branching strategies: https://www.atlassian.com/git/tutorials/comparing-workflows

## Notes for Claude Code

When working on this project:
1. Always preserve existing functionality while implementing new features
2. Create incremental, testable changes rather than large rewrites
3. Add comments explaining complex Nix expressions
4. Test branch operations on a test repository first
5. Consider the non-technical users when designing workflows
6. Maintain backwards compatibility during the transition period

## Current Issues to Address

1. **Submodule Removal**: Clean up references to old submodule structure
2. **Branch Creation**: Initialize user branches with proper content
3. **Script Updates**: Modernize helper scripts for branch-based workflow
4. **Documentation**: Create user-friendly guides for family members
5. **Automation**: Implement GitHub Actions or GitLab CI for synchronization

## Command Aliases and Helpers

Consider adding these to make operations easier:
```bash
# For users
alias update-system="cd ~/dotfiles && git pull && nh os switch '.?submodules=1' --hostname $(hostname)"
alias save-config="cd ~/dotfiles && git add . && git commit -m 'Update configuration' && git push"

# For admin
alias sync-flakes="~/dotfiles/scripts/sync-shared-files.sh"
alias check-conflicts="git branch -r | xargs -I {} git log {}..shared-updates --oneline"
```

---

This document should be kept updated as the migration progresses and new patterns emerge.
