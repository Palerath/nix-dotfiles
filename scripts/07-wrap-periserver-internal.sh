#!/usr/bin/env bash
# 07-wrap-periserver-internal.sh
# Wraps hosts/periserver/modules/*.nix into flake.nixosModules.periServer*
# Run from dotfiles root. periserver submodule must be initialized.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

SRC="hosts/periserver/modules"

[[ -d "$SRC" ]] || { echo "ERROR: $SRC not found"; exit 1; }

for f in "$SRC"/*.nix; do
    [[ -f "$f" ]] || continue
    stem="$(basename "$f" .nix)"

    # skip already-wrapped and non-module files
    if grep -q "flake.nixosModules" "$f"; then
        echo "  skip (already wrapped): $f"
        continue
    fi
    if [[ "$stem" == "secrets" ]] || [[ "$stem" == "grafana-dashboard" ]]; then
        echo "  skip: $f"
        continue
    fi

    # periServer + CamelCase: arr → periServerArr, desktop-env → periServerDesktopEnv
    camel="$(echo "$stem" | sed -E 's/(^|-)([a-z])/\U\2/g')"
    name="periServer${camel}"

    tmp="$(mktemp)"
    cat > "$tmp" <<NIXEOF
{ self, inputs, ... }: {
  flake.nixosModules.${name} =
$(cat "$f")
;
}
NIXEOF
    mv "$tmp" "$f"
    echo "  wrapped → $name ($f)"
done

echo ""
echo "Also wrap a-perihelie.nix and u-miyuyu.nix in hosts/periserver/ manually."
echo "Commit and push from inside hosts/periserver/."
