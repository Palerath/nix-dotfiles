{...}: {
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

  environment.variables = {
    EDITOR = "vim";
  };

  imports = [
    ./vim.nix
    ./user.nix
    ./shell.nix
    ./packages.nix
    ./user.nix
  ];
}
