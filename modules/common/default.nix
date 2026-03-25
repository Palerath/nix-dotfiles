{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.common = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.commonVim
      self.nixosModules.commonAliases
    ];

    security.sudo.wheelNeedsPassword = true;
    security.sudo.extraConfig = "Defaults pwfeedback";

    system.autoUpgrade.enable = true;

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

    nixpkgs.config.allowBroken = true;
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      # auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };
}
