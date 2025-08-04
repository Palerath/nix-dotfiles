
#! /usr/bin/env bash
set -euo pipefall

# Check if user is authorized
if [[ "USER" != "perihelie"]]; then
   echo "Erreur: utilisateur non-autorisé"
   exit 1
fi

# rebuild de linouce
cd /home/perihelie/dotfiles
nh os switch .#perikon "$@"
