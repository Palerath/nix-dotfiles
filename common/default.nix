{...}: {
  # Shared settings across all hosts

  # Security
  security.sudo.wheelNeedsPassword = true;
  security.sudo.extraConfig = "Defaults pwfeedback";

  system.autoUpgrade.enable = true;
  nix.settings.auto-optimise-store = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
  nix.optimise.automatic = true;

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
