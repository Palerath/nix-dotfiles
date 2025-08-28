# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
## CUSTOM INSTRUCTIONS

### Design Principles

1. Always refer back to the documentations (when available) 
2. Don't overengineer: Simple beats complex
3. No fallbacks: One correct path, no alternatives
4. One way: One way to do things, not many
5. Clarity over compatibility: Clear code beats backward compatibility
6. Throw errors: Fail fast when preconditions aren't met
7. No backups: Trust the primary mechanism
8. Separation of concerns: Each function should have a single responsibility

### Development Methodology

9. Surgical changes only: Make minimal, focused fixes
10. Evidence-based debugging: Add minimal, targeted logging
11. Fix root causes: Address the underlying issue, not just symptoms
12. Simple > Complex: Let TypeScript catch errors instead of excessive runtime checks
13. Collaborative process: Work with user to identify most efficient solution

### Styling 
1. Avoid emojis
2. Kaomojis are fine

you are a detective, this is the crime, find the theory of the crime, then collect evidence, and only after evidence proves it, then fix it, has saved me some random fixes as it changes because it has a beautiful theory that is not backed by real evidence

## Repository Overview

This is a NixOS/Home Manager dotfiles repository using Nix Flakes to manage system and user configurations for multiple machines (perikon and linouce). The repository follows a modular architecture where system-level configurations are separated from user-level configurations.

## Key Commands

### System Rebuilds
```bash
# Rebuild perikon system
./scripts/rebuild-perikon.sh
# or: nh os switch '.' --hostname perikon

# Rebuild linouce system  
./scripts/rebuild-linouce.sh
# or: nh os switch '.' --hostname linouce

# Update all systems (commit + push + rebuild both)
./scripts/update-all.sh
```

### Home Manager
```bash
# Update standalone home-manager config for perihelie
home-manager switch --flake .#perihelie@perikon

# Update standalone home-manager config for estelle
home-manager switch --flake .#estelle@linouce
```

### Development Workflow
```bash
# Commit changes with optional message
./scripts/commit.sh ["custom message"]

# Test configuration before rebuilding
nix flake check

# Update flake inputs
nix flake update
```

## Architecture

### Directory Structure
- `hosts/` - Machine-specific NixOS configurations
  - `perikon/` - Desktop system configuration and modules
  - `linouce/` - Secondary system configuration
  - `common/` - Shared system configurations
- `users/` - Home Manager configurations per user
  - `perihelie/` - Main user configuration with desktop environment modules
  - `estelle/` - Secondary user configuration
- `modules/` - Reusable modules
  - `nixos/` - System-level modules (desktop environments)
  - `home-manager/` - User-level modules
- `scripts/` - Build and deployment scripts
- `flake.nix` - Main flake configuration defining inputs and outputs

### Key Configuration Patterns

**System Configuration**: Each host imports modular configurations from `hosts/{hostname}/modules/` covering bootloader, graphics, desktop environments (Hyprland, KDE Plasma, XFCE), gaming, development tools, and services.

**User Configuration**: Home Manager configurations in `users/{username}/` import modular configurations for shells (fish, nushell, zsh), terminal emulators (kitty, alacritty, wezterm), editors (neovim via nvf, emacs), and window managers.

**Flake Architecture**: Uses a helper function `mkSystem` to create NixOS configurations with Home Manager integration. Defines both `nixosConfigurations` for full system builds and `homeConfigurations` for standalone user environment updates.

### Dependencies
- **nh**: Modern Nix helper for system rebuilds
- **nvf**: Neovim configuration framework
- **Hyprland**: Wayland compositor with plugins
- **nix-colors**: Color scheme management
- **zen-browser**: Web browser via flake

## Development Notes

The system uses NixOS unstable channel and enables flakes + nix-command experimental features. The NH_FLAKE environment variable is set to `/home/perihelie/dotfiles` for convenient system management.

When modifying configurations, test with `nix flake check` before rebuilding systems. The repository supports both integrated Home Manager (as NixOS modules) and standalone Home Manager configurations.

### Additional Scripts
- `./scripts/commit.sh` - Simple commit with git add -A, commit, and push
- `./scripts/kumit.sh`, `./scripts/maj-ordi.sh`, `./scripts/unification.sh` - Additional utility scripts
