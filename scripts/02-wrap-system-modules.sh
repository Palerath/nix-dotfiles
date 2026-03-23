#!/usr/bin/env bash
# 02-wrap-system-modules.sh
# Batch-wraps hosts/perikon/system-modules/*.nix → modules/system/
# Source is perikon's system-modules (the most complete set).

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

WRAP="bash scripts/wrap-module.sh"
SRC="hosts/perikon/system-modules"
DST="modules/system"

[[ -d "$SRC" ]] || { echo "ERROR: $SRC not found. Is the perikon submodule initialized?"; exit 1; }

mkdir -p "$DST"

SKIPPED=()
WRAPPED=()

for f in "$SRC"/*.nix; do
    [[ -f "$f" ]] || continue
    stem="$(basename "$f" .nix)"

    # default.nix is replaced by import-tree
    if [[ "$stem" == "default" ]]; then
        SKIPPED+=("$f (default.nix — import-tree replaces it)")
        continue
    fi

    out="$DST/${stem}.nix"
    $WRAP "$f" -o "$out"
    WRAPPED+=("$f → $out")
done

# cachix/ subdirectory
mkdir -p "$DST/cachix"
for f in "$SRC/cachix"/*.nix; do
    [[ -f "$f" ]] || continue
    stem="$(basename "$f" .nix)"
    $WRAP "$f" -n "cachix_${stem}" -o "$DST/cachix/${stem}.nix"
    WRAPPED+=("$f → $DST/cachix/${stem}.nix")
done

# symbols/ — raw XKB data, copy as-is
if [[ -d "$SRC/symbols" ]]; then
    mkdir -p "$DST/symbols"
    cp "$SRC/symbols/"* "$DST/symbols/"
    echo "  copied symbols/"
fi

echo ""
echo "═══ Wrapped ═══"
for w in "${WRAPPED[@]}"; do echo "  ✓ $w"; done

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
    echo ""
    echo "═══ Skipped ═══"
    for s in "${SKIPPED[@]}"; do echo "  ⚠ $s"; done
fi

cat <<'NOTES'

Manual fixups required after this script:

1. modules/system/qwerty-fr.nix — fix symbols path:
   Change:  symbolsFile = ./symbols/us_qwerty-fr;
   To:      symbolsFile = "${./symbols/us_qwerty-fr}";

2. modules/system/cachix.nix — fix builtins.readDir path:
   Change:  folder = ./cachix;
   To:      folder = "${./cachix}";

3. modules/system/input-methods.nix — fix inner import and add self to args:
   Change inner module args to: { self, pkgs, lib, config, ... }:
   Change:  imports = [ ./qwerty-fr.nix ];
   To:      imports = [ self.nixosModules.qwertyFr ];

Next step: run 03-wrap-home-modules.sh
NOTES
