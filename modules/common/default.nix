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
      inputs.sops-nix.nixosModules.sops
    ];

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
  };
}
