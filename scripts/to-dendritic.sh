#!/usr/bin/env bash
# scripts/to-dendritic.sh
#
# Migrate the flake to the dendritic pattern: flake-parts + import-tree.
# Run once on the dendritic branch.
#
# Prerequisites
#   • git submodules already placed at modules/hosts/* and modules/users/*
#   • modules/parts.nix exists
#   • modules/common/ holds NixOS modules (including default.nix)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

B='\033[0;34m'
G='\033[0;32m'
Y='\033[1;33m'
R='\033[0m'
log() { printf "${B}%s${R}\n" "$1"; }
ok() { printf "${G}✓ %s${R}\n" "$1"; }
warn() { printf "${Y}⚠ %s${R}\n" "$1"; }

echo
log "=== Dendritic migration: flake-parts + import-tree ==="
echo

# ──────────────────────────────────────────────────────────────────────
# STRATEGY
#   modules/flake/   ← import-tree targets only this dir
#                       all files here are flake-parts modules
#   modules/common/  ← NixOS modules, never seen by import-tree
#   modules/hosts/*  ← host submodules, never seen by import-tree
#   modules/users/*  ← user submodules, never seen by import-tree
# ──────────────────────────────────────────────────────────────────────

# ── 1. Create modules/flake/ and move parts.nix into it ───────────────
log "[1] Setting up modules/flake/ …"
mkdir -p modules/flake

if [[ -f modules/parts.nix && ! -f modules/flake/parts.nix ]]; then
	mv modules/parts.nix modules/flake/parts.nix
	ok "modules/parts.nix → modules/flake/parts.nix"
fi

# ── 2. Rename common NixOS entrypoint ────────────────────────────────
# default.nix → nixos.nix so it can never be confused with a flake-parts
# default and is unambiguous when imported by path.
log "[2] Renaming modules/common/default.nix → nixos.nix …"
if [[ -f modules/common/default.nix && ! -f modules/common/nixos.nix ]]; then
	mv modules/common/default.nix modules/common/nixos.nix
	ok "modules/common/default.nix → nixos.nix"
else
	warn "modules/common/nixos.nix already exists or default.nix missing – skipped"
fi

# ── 3. flake.nix ──────────────────────────────────────────────────────
log "[3] Writing flake.nix …"
cat >flake.nix <<'FLAKE'
{
  description = "Multi-host NixOS / nix-darwin configuration";

  inputs = {
    self.submodules = true;

    nixpkgs.url        = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url    = "github:hercules-ci/flake-parts";
    import-tree.url    = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  # modules/flake/ contains only flake-parts modules.
  # modules/common/, modules/hosts/*, modules/users/* are NixOS / HM
  # modules and are referenced by path from within nixos.nix / darwin.nix.
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules/flake);
}
FLAKE
ok "flake.nix"

# ── 4. modules/flake/nixos.nix ────────────────────────────────────────
log "[4] Writing modules/flake/nixos.nix …"
cat >modules/flake/nixos.nix <<'EOF'
{ inputs, self, lib, ... }:

let
  mkHost =
    { hostName
    , system    ? "x86_64-linux"
    , useStable ? false
    }:
    let
      basePkgs  = if useStable then inputs.nixpkgs-stable else inputs.nixpkgs;
      hmInput   = if useStable then inputs.home-manager-stable else inputs.home-manager;
      extraPkgs = lib.optionalAttrs (!useStable) {
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      specialArgs = {
        inherit inputs hostName self;
        userConfigs = self.userConfigs;
      } // extraPkgs;
    in
    basePkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs;
      modules = [
        inputs.sops-nix.nixosModules.sops
        hmInput.nixosModules.home-manager
        {
          _module.args.inputs           = inputs;
          home-manager.extraSpecialArgs = specialArgs;
        }
        (self + /modules/hosts/${hostName}/hardware-configuration.nix)
        (self + /modules/hosts/${hostName}/configuration.nix)
        (self + /modules/common/nixos.nix)
      ];
    };

in
{
  flake = {
    # Consumed by host perihelie.nix / a-perihelie.nix via specialArgs.
    userConfigs = {
      perihelie = import (self + /modules/users/perihelie/home.nix);
      estelle   = import (self + /modules/users/estelle/home.nix);
      miyuyu    = import (self + /modules/users/miyuyu/home.nix);
    };

    nixosConfigurations = {
      perikon    = mkHost { hostName = "perikon"; };
      latitude   = mkHost { hostName = "latitude"; };
      linouce    = mkHost { hostName = "linouce";    useStable = true; };
      periserver = mkHost { hostName = "periserver"; useStable = true; };
    };
  };
}
EOF
ok "modules/flake/nixos.nix"

# ── 5. modules/flake/darwin.nix ───────────────────────────────────────
log "[5] Writing modules/flake/darwin.nix …"
cat >modules/flake/darwin.nix <<'EOF'
{ inputs, self, ... }:

let
  mkDarwinHost =
    { hostName, system ? "aarch64-darwin" }:
    let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs hostName self pkgs-stable;
        userConfigs = self.userConfigs;
      };
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          _module.args.inputs           = inputs;
          home-manager.extraSpecialArgs = specialArgs;
        }
        (self + /modules/hosts/${hostName}/configuration.nix)
        (self + /modules/common/darwin.nix)
      ];
    };

in
{
  flake.darwinConfigurations.airhelie =
    mkDarwinHost { hostName = "airhelie"; };
}
EOF
ok "modules/flake/darwin.nix"

# ── 6. modules/flake/devshell.nix ────────────────────────────────────
log "[6] Writing modules/flake/devshell.nix …"
cat >modules/flake/devshell.nix <<'EOF'
{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git nh nixos-rebuild alejandra nil
        rustup pkg-config openssl
        hyperfine python3 uv just jq curl httpie
      ];
      shellHook = ''
        export NIXPKGS_ALLOW_UNFREE=1
        export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
        export RUSTUP_HOME="$PWD/.rustup"
        export CARGO_HOME="$PWD/.cargo"
        export PATH="$CARGO_HOME/bin:$PATH"
        echo "Dev shell ready"
      '';
    };
  };
}
EOF
ok "modules/flake/devshell.nix"

# ── Done ──────────────────────────────────────────────────────────────
echo
ok "Migration complete.  Final layout:"
echo "  modules/flake/   ← flake-parts modules (import-tree target)"
echo "  modules/common/  ← NixOS modules (nixos.nix is the entrypoint)"
echo "  modules/hosts/*  ← host submodules"
echo "  modules/users/*  ← user submodules"
echo
log "Next steps:"
echo "  1.  nix flake update"
echo "      (adds import-tree to flake.lock)"
echo "  2.  git add -A"
echo "  3.  git commit -m 'feat: dendritic flake-parts + import-tree'"
echo "  4.  nh os switch . -H perikon    # smoke test"
