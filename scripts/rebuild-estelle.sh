#! /usr/bin/env bash
set -euo pipefall

# Check if user is authorized
if [[ "USER" != "estelle" && "USER" != "perihelie"]]; then
   echo "Erreur: utilisateur non-autorisé"
   exit 1
fi

# rebuild de linouce
cd /home/estelle/config
nh os switch .#linouce "$@"

