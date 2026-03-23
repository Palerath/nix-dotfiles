#!/usr/bin/env bash
# wrap-module.sh
# Wraps a single plain NixOS module into a flake-parts nixosModule.
# The original file is left untouched; output goes to stdout or -o FILE.
#
# Usage:
#   bash scripts/wrap-module.sh system-modules/audio.nix
#   bash scripts/wrap-module.sh system-modules/audio.nix -o modules/system/audio.nix
#   bash scripts/wrap-module.sh system-modules/audio.nix -n myCustomName -o modules/system/audio.nix
#
# The module name defaults to the filename stem (audio.nix → audio).
# For home-manager modules use --hm flag: they become homeManagerModules instead.

set -euo pipefail

usage() {
    echo "Usage: $0 <source.nix> [-n name] [-o output.nix] [--hm]"
    exit 1
}

SOURCE=""
NAME=""
OUTPUT=""
HM=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n) NAME="$2"; shift 2 ;;
        -o) OUTPUT="$2"; shift 2 ;;
        --hm) HM=true; shift ;;
        -h|--help) usage ;;
        -*) echo "Unknown flag: $1"; usage ;;
        *) SOURCE="$1"; shift ;;
    esac
done

[[ -z "$SOURCE" ]] && usage
[[ ! -f "$SOURCE" ]] && { echo "ERROR: $SOURCE not found"; exit 1; }

# Derive name from filename stem if not provided
if [[ -z "$NAME" ]]; then
    NAME="$(basename "$SOURCE" .nix)"
fi

# Sanitize: replace hyphens with camelCase  (e.g. desktop-env → desktopEnv)
CAMEL_NAME="$(echo "$NAME" | sed -E 's/-([a-z])/\U\1/g')"

if $HM; then
    MODULE_KEY="flake.homeManagerModules.${CAMEL_NAME}"
else
    MODULE_KEY="flake.nixosModules.${CAMEL_NAME}"
fi

# Read original args line (first line that starts with `{`)
ORIGINAL_ARGS="$(grep -m1 '^\s*{' "$SOURCE" | sed 's/{//' | sed 's/}:.*//' | xargs)"

WRAPPED=$(cat <<EOF
# Wrapped from: $SOURCE
{ self, inputs, ... }: {
  ${MODULE_KEY} =
    $(cat "$SOURCE");
}
EOF
)

if [[ -n "$OUTPUT" ]]; then
    mkdir -p "$(dirname "$OUTPUT")"
    echo "$WRAPPED" > "$OUTPUT"
    echo "Wrapped → $OUTPUT (module name: ${CAMEL_NAME})"
else
    echo "$WRAPPED"
fi
