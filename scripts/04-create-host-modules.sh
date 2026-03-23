#!/usr/bin/env bash
# 04-create-host-modules.sh
# Generates modules/hosts/<n>/default.nix for each host.
# Key fix: imports the submodule's configuration.nix so its
# flake.nixosModules.* definitions are visible to import-tree.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

declare -A HOSTS=(
    [perikon]="unstable"
    [latitude]="unstable"
    [linouce]="stable"
    [periserver]="stable"
)

for HOST in "${!HOSTS[@]}"; do
    CHANNEL="${HOSTS[$HOST]}"
    DIR="modules/hosts/$HOST"
    mkdir -p "$DIR"

    if [[ ! -d "hosts/$HOST" ]]; then
        echo "  ⚠ hosts/$HOST not initialized — skipping"
        echo "    Run: git submodule update --init hosts/$HOST"
        continue
    fi

    if [[ "$CHANNEL" == "stable" ]]; then
        NIXPKGS_INPUT="inputs.nixpkgs-stable"
        HM_INPUT="inputs.home-manager-stable"
    else
        NIXPKGS_INPUT="inputs.nixpkgs"
        HM_INPUT="inputs.home-manager"
    fi

    # CamelCase the host name: perikon → Perikon, periserver → Periserver
    MODULE_NAME="$(echo "$HOST" | sed -E 's/(^|-)([a-z])/\U\2/g')"

    cat > "$DIR/default.nix" <<NIXEOF
# Entry point for host: $HOST
{ self, inputs, ... }: {
  # Pull nixosModules definitions from the private submodule into import-tree scope
  imports = [ ../../../hosts/${HOST}/configuration.nix ];

  flake.nixosConfigurations.${HOST} = ${NIXPKGS_INPUT}.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs self;
      hostName = "${HOST}";
    };
    modules = [
      ${HM_INPUT}.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.${MODULE_NAME}Configuration
    ];
  };
}
NIXEOF

    echo "  created $DIR/default.nix ($CHANNEL)"
done

echo ""
echo "Next: bash scripts/05-generate-new-flake.sh"
