#!/usr/bin/env bash
# 06-wrap-user-submodules.sh
# Wraps users/*/home.nix into flake.homeManagerModules.*
# and updates modules/hosts/*/default.nix for Darwin (airhelie).
# Run from dotfiles root after submodules are initialized.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

wrap_home() {
    local FILE="$1"
    local MODULE_NAME="$2"

    # Skip if already wrapped
    if grep -q "flake.homeManagerModules" "$FILE"; then
        echo "  skip (already wrapped): $FILE"
        return
    fi

    local TMP
    TMP="$(mktemp)"
    cat > "$TMP" <<NIXEOF
{ self, inputs, ... }: {
  flake.homeManagerModules.${MODULE_NAME} =
$(cat "$FILE")
;
}
NIXEOF
    mv "$TMP" "$FILE"
    echo "  wrapped → $MODULE_NAME ($FILE)"
}

# perihelie
[[ -f "users/perihelie/home.nix" ]] && wrap_home "users/perihelie/home.nix" "perihelieHome"

# miyuyu
[[ -f "users/miyuyu/home.nix" ]] && wrap_home "users/miyuyu/home.nix" "miyuyuHome"

# estelle
[[ -f "users/estelle/home.nix" ]] && wrap_home "users/estelle/home.nix" "estelleHome"

echo ""
echo "═══ Reminder: manual edits still needed ═══"
cat <<'NOTES'
In each wrapped home.nix:
  - Replace userConfigs.perihelie / userConfigs.estelle etc with
    self.homeManagerModules.perihelieHome etc
  - Replace ./perihelie-modules/foo.nix imports with self.homeManagerModules.foo
  - Add inputs to args if helix.nix or similar needs inputs.nixpkgs-stable

In users/perihelie/perihelie-modules/helix.nix:
  - Change { pkgs, lib, pkgs-stable, ... } to { pkgs, lib, inputs, ... }
  - Add: let pkgs-stable = import inputs.nixpkgs-stable { inherit (pkgs) system; config.allowUnfree = true; }; in

Darwin host (airhelie):
  - modules/hosts/airhelie/default.nix must use darwinConfigurations not nixosConfigurations
  - needs inputs.nix-darwin and inputs.nix-homebrew
  - see MIGRATION_GUIDE.md airhelie section
NOTES
