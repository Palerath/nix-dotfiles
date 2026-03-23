#!/usr/bin/env bash
# 05-generate-new-flake.sh
# Writes the new flake.nix that uses import-tree.
# The old flake.nix is backed up as flake.nix.old

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

cp flake.nix flake.nix.old
echo "Backed up flake.nix → flake.nix.old"

cat > flake.nix <<'FLAKE'
{
  description = "Multi-host NixOS configuration";

  inputs = {
    self.submodules = true;

    nixpkgs.url          = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url   = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url      = "github:hercules-ci/flake-parts";
    import-tree.url      = "github:vic/import-tree";
    hyprland.url         = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
FLAKE

echo "Written new flake.nix"
echo ""
echo "NOTE: flake.lock will need updating after adding import-tree:"
echo "  nix flake lock --update-input import-tree"
echo ""
echo "Next: nix flake check (will fail until modules/ is populated)"
