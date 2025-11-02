#!/usr/bin/env bash
# Script to quickly set up a new host configuration

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

function print_prompt() {
    echo -e "${YELLOW}[?]${NC} $1"
}

# Get host information
print_info "Setting up new NixOS host configuration"
echo ""

read -p "Enter hostname: " HOSTNAME
read -p "Enter system type (x86_64-linux/aarch64-linux): " SYSTEM
read -p "Will this host use existing shared users? (y/n): " USE_SHARED_USERS

SYSTEM=${SYSTEM:-x86_64-linux}

# Create directory structure
print_info "Creating directory structure..."

mkdir -p "$HOSTNAME"
cd "$HOSTNAME"

# Create default.nix
cat > default.nix << EOF
{ inputs, self }:

    let
    system = "$SYSTEM";
    hostname = "$HOSTNAME";

    pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
    };

in inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = { 
        inherit inputs self hostname;
    };

modules = [
./configuration.nix
self.nixosModules.common
self.nixosModules.hardware

inputs.home-manager.nixosModules.home-manager
{
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users = import ./users.nix { inherit self pkgs; };
    };
}

{ networking.hostName = hostname; }
];
}
EOF

# Create configuration.nix
cat > configuration.nix << 'EOF'
{ config, pkgs, inputs, hostname, ... }:

    {
        imports = [
        ./hardware-configuration.nix
        ];

        boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

    networking = {
        hostName = hostname;
        networkmanager.enable = true;
    };

time.timeZone = "Europe/Paris";
i18n.defaultLocale = "en_US.UTF-8";

# Define system users here
# (Corresponding home-manager configs go in users.nix)
users.users = {
    # Example:
    # username = {
    #   isNormalUser = true;
    #   description = "Full Name";
    #   extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    #   shell = pkgs.zsh;
    # };
};

environment.systemPackages = with pkgs; [
git
vim
wget
curl
btop
];

services = {
    xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
    };
};

system.stateVersion = "24.11";
}
EOF

# Create placeholder hardware config
cat > hardware-configuration.nix << 'EOF'
# This is a placeholder. Replace with output from:
# sudo nixos-generate-config --show-hardware-config

{ config, lib, pkgs, modulesPath, ... }:

    {
        imports = [ ];

        boot.initrd.availableKernelModules = [ ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
        };

    fileSystems."/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
    };

swapDevices = [ ];

networking.useDHCP = lib.mkDefault true;
nixpkgs.hostPlatform = lib.mkDefault "$SYSTEM";
}
EOF

sed -i "s/\$SYSTEM/$SYSTEM/g" hardware-configuration.nix

# Create users.nix based on whether using shared users
if [[ "$USE_SHARED_USERS" == "y" ]]; then
    cat > users.nix << 'EOF'
    { self, pkgs }:

        {
            # Import shared users from main repo
            # Example:
            # perihelie = import (self + "/users/perihelie") { inherit pkgs; };

            # Or with host-specific overrides:
            # perihelie = pkgs.lib.mkMerge [
            #   (import (self + "/users/perihelie") { inherit pkgs; })
            #   {
            #     home.packages = with pkgs; [ extra-package ];
            #   }
            # ];

            # Or define host-specific users:
            # localuser = {
            #   home.username = "localuser";
            #   home.homeDirectory = "/home/localuser";
            #   home.stateVersion = "24.11";
            #   programs.home-manager.enable = true;
            # };
        }
    EOF
else
    mkdir -p local-users
    cat > users.nix << 'EOF'
    { self, pkgs }:

        {
            # Define host-specific users here
            # Example:
            # username = import ./local-users/username.nix { inherit pkgs; };
        }
    EOF

    cat > local-users/example.nix << 'EOF'
    { pkgs, ... }:

        {
            home = {
                username = "username";
                homeDirectory = "/home/username";
                stateVersion = "24.11";

                packages = with pkgs; [
                firefox
                vscode
                ];
            };

        programs = {
            git = {
                enable = true;
                userName = "Your Name";
                userEmail = "your.email@example.com";
            };

        bash.enable = true;
        home-manager.enable = true;
    };
}
EOF
fi

# Initialize git repo
print_info "Initializing git repository..."
git init
git add .
git commit -m "Initial $HOSTNAME configuration"

print_info ""
print_info "Host configuration created successfully!"
print_info ""
print_info "Next steps:"
print_info "1. cd $HOSTNAME"
print_info "2. Update hardware-configuration.nix with actual hardware config:"
print_info "   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix"
print_info "3. Update configuration.nix with your system users"
print_info "4. Update users.nix to import shared users or define local ones"

if [[ "$USE_SHARED_USERS" == "y" ]]; then
    print_info "5. Make sure shared users exist in main repo's users/ directory"
fi

print_info "6. Create a git repository and push:"
print_info "   git remote add origin <your-repo-url>"
print_info "   git push -u origin main"
print_info "7. Add as submodule to main config:"
print_info "   cd /path/to/main/config"
print_info "   git submodule add <your-repo-url> hosts/$HOSTNAME"
print_info "8. Update main flake.nix to include $HOSTNAME"
print_info ""
