{ config, pkgs, ... }:

{
    # Shared settings across all hosts

    # Security
    security.sudo.wheelNeedsPassword = true;

    # Auto-upgrade (optional)
    # system.autoUpgrade.enable = true;

    # Common services
    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
    };

    # Shared environment variables
    environment.variables = {
        EDITOR = "vim";
    };
}

