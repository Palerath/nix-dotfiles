#!/usr/bin/env bash
# check-migration.sh
# Reports migration status: which hosts are wired, which modules are wrapped,
# which references still point to old paths.
# Safe to run at any point during migration.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

OK=0
WARN=0
ERR=0

pass()  { echo "  ✓ $*"; (( OK++  || true )); }
warn()  { echo "  ⚠ $*"; (( WARN++ || true )); }
fail()  { echo "  ✗ $*"; (( ERR++  || true )); }

echo "═══ Branch ═══"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "feat/dendritic" ]]; then
    pass "On branch feat/dendritic"
else
    warn "Not on feat/dendritic (current: $BRANCH)"
fi

echo ""
echo "═══ flake.nix ═══"
if grep -q "import-tree" flake.nix; then
    pass "import-tree present in flake.nix"
else
    fail "flake.nix still uses old structure"
fi
if grep -q "lib.mkHost" flake.nix; then
    warn "flake.nix still references lib.mkHost (old pattern)"
fi
if grep -q "userConfigs" flake.nix; then
    warn "flake.nix still references userConfigs (old pattern)"
fi

echo ""
echo "═══ modules/ directory ═══"
for d in modules/system modules/home modules/hosts modules/pkgs; do
    if [[ -d "$d" ]]; then
        COUNT="$(find "$d" -name '*.nix' | wc -l | tr -d ' ')"
        pass "$d exists ($COUNT .nix files)"
    else
        fail "$d missing"
    fi
done

echo ""
echo "═══ Host wiring ═══"
for HOST in perikon latitude linouce periserver; do
    ENTRY="modules/hosts/$HOST/default.nix"
    if [[ -f "$ENTRY" ]]; then
        if grep -q "nixosConfigurations.$HOST" "$ENTRY"; then
            pass "$HOST: entry point wired"
        else
            warn "$HOST: default.nix exists but no nixosConfigurations.$HOST"
        fi
    else
        fail "$HOST: no entry point (modules/hosts/$HOST/default.nix missing)"
    fi
done

echo ""
echo "═══ Stale path references in modules/ ═══"
# Look for patterns that reference old local paths
OLD_PATTERNS=(
    "\./system-modules"
    "\./perihelie-modules"
    "\./common/"
    "self \+ /hosts/"
    "self \+ /users/"
    "userConfigs\."
    "lib\.mkHost"
)
FOUND_STALE=false
for pat in "${OLD_PATTERNS[@]}"; do
    HITS="$(grep -r --include='*.nix' -l "$pat" modules/ 2>/dev/null || true)"
    if [[ -n "$HITS" ]]; then
        warn "Stale pattern '$pat' found in:"
        echo "$HITS" | sed 's/^/      /'
        FOUND_STALE=true
    fi
done
$FOUND_STALE || pass "No stale path references found"

echo ""
echo "═══ Summary ═══"
echo "  ✓ $OK  ⚠ $WARN  ✗ $ERR"
echo ""
if [[ $ERR -gt 0 ]]; then
    echo "Migration incomplete. See errors above."
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo "Migration mostly complete but has warnings."
    exit 0
else
    echo "Migration looks complete. Run: nix flake check"
fi
