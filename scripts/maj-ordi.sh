#!/bin/bash

# Script de mise à jour automatique pour l'ordinateur d'Estelle
# Usage: ./maj-ordi.sh [message optionnel]
# Exemple: ./maj-ordi.sh "nouveau fond d'écran"
# Exemple: ./maj-ordi.sh (utilise un message automatique)

clear
echo "🌸 === MISE À JOUR DE L'ORDINATEUR === 🌸"
echo ""

# Message de commit (optionnel)
COMMIT_MSG="$1"
if [ -z "$COMMIT_MSG" ]; then
   COMMIT_MSG="Mise à jour automatique du $(date '+%d/%m/%Y à %H:%M')"
fi

echo "📝 Message: $COMMIT_MSG"
echo ""

# Répertoire des configurations
DOTFILES_DIR="/home/estelle/dotfiles"

# Couleurs pour l'affichage
VERT='\033[0;32m'
BLEU='\033[0;34m'
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
NORMAL='\033[0m'

# Fonction pour afficher les étapes
etape() {
   echo -e "${BLEU}▶ $1${NORMAL}"
}

# Fonction pour afficher les succès
succes() {
   echo -e "${VERT}✓ $1${NORMAL}"
}

# Fonction pour afficher les erreurs
erreur() {
   echo -e "${ROUGE}✗ $1${NORMAL}"
}

# Fonction pour sauvegarder et synchroniser un dossier
sauvegarder() {
   local dossier=$1
   local nom=$(basename "$dossier" 2>/dev/null || echo "$dossier")
   
   etape "Sauvegarde de $nom..."
   
   if [ ! -d "$dossier" ]; then
      erreur "Le dossier $dossier n'existe pas"
      return 1
   fi
   
   cd "$dossier" || { erreur "Impossible d'accéder à $dossier"; return 1; }
   
   # Vérifier si c'est un dépôt git
   if [ ! -d ".git" ]; then
      erreur "$nom n'est pas un dépôt git"
      cd - > /dev/null || exit
      return 1
   fi
   
   # Ajouter tous les changements
   git add -A
   
   # Vérifier s'il y a des changements
   if ! git diff --cached --quiet; then
      git commit -m "$COMMIT_MSG"
      if [ $? -eq 0 ]; then
         git push
         if [ $? -eq 0 ]; then
            succes "$nom sauvegardé avec succès"
         else
            erreur "Échec de l'envoi pour $nom"
         fi
      else
         erreur "Échec de la sauvegarde pour $nom"
      fi
   else
      echo -e "${JAUNE}  Aucun changement dans $nom${NORMAL}"
   fi
   
   cd - > /dev/null || exit
}

# Vérification initiale
etape "Vérification du système..."

if [ ! -d "$DOTFILES_DIR" ]; then
   erreur "Le dossier de configuration n'existe pas !"
   echo "Contactez votre administrateur système."
   exit 1
fi

cd "$DOTFILES_DIR" || { erreur "Impossible d'accéder aux configurations"; exit 1; }

# Mise à jour des sous-modules git
etape "Mise à jour des modules..."
git submodule update --init --recursive > /dev/null 2>&1

# Liste des dossiers à sauvegarder
echo ""
etape "🔄 Début de la sauvegarde..."
echo ""

# Sauvegarder les configurations utilisateur
sauvegarder "$DOTFILES_DIR/users/estelle"

# Sauvegarder les configurations de l'ordinateur
sauvegarder "$DOTFILES_DIR/hosts/linouce"

# Sauvegarder le dossier principal
sauvegarder "$DOTFILES_DIR"

echo ""
etape "🔄 Mise à jour du système..."

# Mettre à jour les paquets disponibles
echo -e "${JAUNE}  Recherche des nouvelles versions...${NORMAL}"
nix flake update > /dev/null 2>&1

if [ $? -eq 0 ]; then
   succes "Liste des paquets mise à jour"
else
   erreur "Problème lors de la mise à jour des paquets"
fi

# Appliquer les changements au système
echo -e "${JAUNE}  Application des changements...${NORMAL}"
nh os switch '.?submodules=1' --hostname linouce

if [ $? -eq 0 ]; then
   succes "Système mis à jour avec succès !"
else
   erreur "Problème lors de la mise à jour du système"
   echo "Le système fonctionne toujours, mais certains changements n'ont pas été appliqués."
fi

echo ""
echo -e "${VERT}🎉 === MISE À JOUR TERMINÉE === 🎉${NORMAL}"
echo ""
echo "📋 Résumé:"
echo "   • Configurations sauvegardées"
echo "   • Système mis à jour"
echo ""

