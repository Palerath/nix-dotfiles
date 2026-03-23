#!/usr/bin/env bash
# 03-wrap-home-modules.sh
# Wraps users/perihelie/perihelie-modules/*.nix → modules/home/
# These become flake.homeManagerModules.*

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

WRAP="bash scripts/wrap-module.sh"
SRC="users/perihelie/perihelie-modules"
DST="modules/home"

[[ -d "$SRC" ]] || { echo "ERROR: $SRC not found. Is the perihelie submodule initialized?"; exit 1; }

mkdir -p "$DST"

WRAPPED=()

for f in "$SRC"/*.nix; do
    [[ -f "$f" ]] || continue
    stem="$(basename "$f" .nix)"

    # default.nix is replaced by import-tree
    if [[ "$stem" == "default" ]]; then
        echo "  skip: default.nix (import-tree replaces it)"
        continue
    fi

    out="$DST/${stem}.nix"
    $WRAP "$f" --hm -o "$out"
    WRAPPED+=("$f → $out")
done

# CSS and images — referenced by waybar.nix and fastfetch.nix
cp "$SRC"/*.css "$DST/" 2>/dev/null && echo "  copied CSS files" || true
if [[ -d "$SRC/images" ]]; then
    cp -r "$SRC/images" "$DST/images"
    echo "  copied images/"
fi

echo ""
echo "═══ Wrapped ═══"
for w in "${WRAPPED[@]}"; do echo "  ✓ $w"; done

cat <<'NOTES'

Manual fixups required:

1. modules/home/window-manager-master.nix — fix inner imports and add self to args:
   Change inner module args to: { self, pkgs, config, ... }:
   Change:  imports = [ ./hypr.nix ./waybar.nix ./wallpaper.nix ];
   To:      imports = [ self.homeManagerModules.hypr
                        self.homeManagerModules.waybar
                        self.homeManagerModules.wallpaper ];

2. modules/home/nvim.nix — add self to inner module args:
   { self, config, pkgs, ... }:

3. users/perihelie/perihelie-modules/helix.nix — fix pkgs-stable:
   Change args: { pkgs, lib, inputs, ... }:
   Add before the attrset:
     let pkgs-stable = import inputs.nixpkgs-stable {
           inherit (pkgs) system;
           config.allowUnfree = true;
         }; in

4. waybar.nix: builtins.readFile ./waybar.css — path still valid (same dir). No change.
5. fastfetch.nix: ./images/cirno.png — path still valid (same dir). No change.

Next step: run 04-create-host-modules.sh
NOTES
