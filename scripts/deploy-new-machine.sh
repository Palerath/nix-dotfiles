#!/bin/bash
# Deploy dotfiles to a new machine with proper user isolation

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Configuration
HOSTNAME="${1:-$(hostname)}"
ADMIN_USER="${2:-$(whoami)}"
DOTFILES_REPO="${3:-$(git -C "$DOTFILES_DIR" remote get-url origin)}"

if [ -z "$HOSTNAME" ]; then
    echo "Usage: $0 <hostname> [admin_user] [dotfiles_repo_url]"
    exit 1
fi

echo "Deploying dotfiles for hostname: $HOSTNAME"
echo "Admin user: $ADMIN_USER"
echo "Repository: $DOTFILES_REPO"

# Create host configuration if it doesn't exist
HOST_CONFIG_DIR="$DOTFILES_DIR/hosts/$HOSTNAME"
if [ ! -d "$HOST_CONFIG_DIR" ]; then
    echo "Creating host configuration for $HOSTNAME..."
    
    # Copy template or create basic config
    mkdir -p "$HOST_CONFIG_DIR"
    
    cat > "$HOST_CONFIG_DIR/configuration.nix" << EOF
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "$HOSTNAME";
  
  # Enable users to manage their own configs
  nix.settings.allowed-users = [ "@wheel" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];
  
  # System packages and services
  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];
}
EOF

    mkdir -p "$HOST_CONFIG_DIR/modules"
    
    echo "Please generate hardware-configuration.nix and add it to $HOST_CONFIG_DIR/"
fi

# Update flake.nix to include new host
if ! grep -q "$HOSTNAME" "$DOTFILES_DIR/flake.nix"; then
    echo "Adding $HOSTNAME to flake.nix..."
    # This would need manual intervention or a more sophisticated script
    echo "Manual step: Add $HOSTNAME configuration to flake.nix"
fi

echo "Deployment template created for $HOSTNAME"
echo "Next steps:"
echo "1. Generate and copy hardware-configuration.nix"
echo "2. Update flake.nix with $HOSTNAME configuration"
echo "3. Run: nixos-rebuild switch --flake .#$HOSTNAME"