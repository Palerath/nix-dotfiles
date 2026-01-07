{...}: {
  # Shared settings across all hosts

  # Security
  security.sudo.wheelNeedsPassword = true;
  security.sudo.extraConfig = "Defaults pwfeedback";
  # Auto-upgrade (optional)
  # system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Common services
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # Shared environment variables
  environment.variables = {
    EDITOR = "vim";
  };

  imports = [
    ./vim.nix
    ./shell.nix
    ./packages.nix
  ];
}
