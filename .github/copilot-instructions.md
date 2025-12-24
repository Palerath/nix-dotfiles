# Copilot Instructions - NixOS Dotfiles

## Architecture Overview

This is a **multi-host, multi-user NixOS flake configuration** using flake-parts. The key data flow is:

```
flake.nix → lib.mkHost() → hosts/{hostname}/ → users/{username}/home.nix
                ↓                    ↓
         common/ modules      host-specific overrides/
```

### Three-Layer Configuration Pattern

1. **User modules** (`users/{user}/perihelie-modules/`) - Portable configs that work across hosts
2. **Host modules** (`hosts/{host}/modules/`) - System-level NixOS modules (desktop environments, drivers, services)
3. **Host overrides** (`hosts/{host}/overrides/`) - Host-specific home-manager customizations that extend user modules

Example: Hyprland is enabled system-wide in `hosts/perikon/modules/desktop/hyprland.nix`, but user keybinds/settings live in `hosts/perikon/overrides/hypr.nix`.

## Key Files and Conventions

| Path | Purpose |
|------|---------|
| `flake.nix` | Defines `lib.mkHost` helper, `userConfigs`, host list. `useStable = true` switches to stable channel |
| `hosts/{host}/configuration.nix` | Main host config, imports modules via `./modules/` |
| `hosts/{host}/{username}.nix` | User definition + home-manager setup, imports from `userConfigs.{user}` AND local `./overrides/` |
| `users/{user}/home.nix` | Portable home-manager config, imports from `./perihelie-modules/` |
| `common/` | Shared NixOS module applied to ALL hosts (`nixosModules.common`) |

## Adding New Configuration

**New host module** → `hosts/{host}/modules/{feature}.nix`, then import in `configuration.nix`  
**New user program** → `users/{user}/perihelie-modules/{program}.nix`, then add to `default.nix` imports  
**Host-specific override** → `hosts/{host}/overrides/{feature}.nix`, then import in `overrides/perihelie-local.nix`

## Code Style

- Use 4-space indentation in `.nix` files
- Prefer explicit `pkgs` references: `with pkgs; [ ... ]` or `pkgs.packageName`
- Function args use pattern matching: `{ pkgs, lib, inputs, ... }:`
- Import flake inputs via `specialArgs`: `{ inherit inputs; }`

## Rebuild Commands

```bash
# Preferred: Uses nh with the flake path from NH_FLAKE env var
nh os switch

# Alternative
sudo nixos-rebuild switch --flake .#perikon
```

## Submodule Workflow

Some configs (like nvim at `users/perihelie/perihelie-modules/nvim/`) are symlinked and may be git submodules. Use the `scripts/kumit.sh` helper to commit across all submodules:

```bash
./scripts/kumit.sh "commit message"  # Commits submodules first, then main repo
```

## External Inputs

Key flake inputs that modules depend on:
- `inputs.hyprland` - Hyprland compositor (see `modules/desktop/hyprland.nix`)
- `inputs.nvf` - Neovim flake framework
- `inputs.zen-browser` - Zen browser home-manager module
- `inputs.determinate` - Determinate Nix module (applied to all hosts)

When adding features that use flake inputs, access them via `inputs.{name}` in module args.
