#!/usr/bin/env bash
# Re-registers host/user repos as submodules at their new paths.
# Run from repo root on the dendritic branch.
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

declare -A SUBMODULES=(
	["modules/hosts/perikon"]="git@github.com:Palerath/dotfiles-perikon.git"
	["modules/hosts/periserver"]="git@github.com:Palerath/periserver.git"
	["modules/hosts/airhelie"]="git@github.com:Palerath/dotfiles-airhelie.git"
	["modules/hosts/latitude"]="git@github.com:Palerath/dotfiles-latitude.git"
	["modules/hosts/linouce"]="git@github.com:Palerath/dotfiles-linouce.git"
	["modules/users/perihelie"]="git@github.com:Palerath/dotfiles-perihelie.git"
	["modules/users/miyuyu"]="git@github.com:Palerath/dotfiles-miyuyu.git"
	["modules/users/estelle"]="git@github.com:Palerath/dotfiles-estelle.git"
	["modules/common/vim"]="git@github.com:Palerath/vim-config.git"
)

# 1. Rewrite .gitmodules
cat >.gitmodules <<'GITMODULES'
[submodule "modules/hosts/perikon"]
	path = modules/hosts/perikon
	url = git@github.com:Palerath/dotfiles-perikon.git
[submodule "modules/hosts/periserver"]
	path = modules/hosts/periserver
	url = git@github.com:Palerath/periserver.git
[submodule "modules/hosts/airhelie"]
	path = modules/hosts/airhelie
	url = git@github.com:Palerath/dotfiles-airhelie.git
[submodule "modules/hosts/latitude"]
	path = modules/hosts/latitude
	url = git@github.com:Palerath/dotfiles-latitude.git
[submodule "modules/hosts/linouce"]
	path = modules/hosts/linouce
	url = git@github.com:Palerath/dotfiles-linouce.git
[submodule "modules/users/perihelie"]
	path = modules/users/perihelie
	url = git@github.com:Palerath/dotfiles-perihelie.git
[submodule "modules/users/miyuyu"]
	path = modules/users/miyuyu
	url = git@github.com:Palerath/dotfiles-miyuyu.git
[submodule "modules/users/estelle"]
	path = modules/users/estelle
	url = git@github.com:Palerath/dotfiles-estelle.git
[submodule "modules/common/vim"]
	path = modules/common/vim
	url = git@github.com:Palerath/vim-config.git
GITMODULES

# 2. Register each URL in .git/config (required before absorbgitdirs)
for path in "${!SUBMODULES[@]}"; do
	git config "submodule.${path}.url" "${SUBMODULES[$path]}"
done

# 3. Move embedded .git/ dirs into .git/modules/ and replace with gitlinks
git submodule absorbgitdirs

# 4. Stage each submodule as a gitlink (160000 mode)
for path in "${!SUBMODULES[@]}"; do
	if [ -e "$path/.git" ]; then
		sha=$(git -C "$path" rev-parse HEAD)
		git update-index --add --cacheinfo "160000,${sha},${path}"
	else
		echo "WARNING: $path missing, skipping"
	fi
done

git add .gitmodules
echo "Done. Review with 'git status', then commit and push."
