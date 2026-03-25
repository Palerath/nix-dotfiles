{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.perikonConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.perikonHardware
      self.nixosModules.perihelieConfiguration
      self.nixosModules.common
      self.nixosModules.sops
      self.nixosModules.hyprland
    ];

    # inputMethod = {
    #   type = "fcitx5";
    #   useMozcUT = true;
    # };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

    hardware.opentabletdriver.enable = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = ["root" "perihelie"];
    };

    security = {
      sudo.enable = true;
      polkit.enable = true;
      rtkit.enable = true;
    };

    system.stateVersion = "24.11";
  };
}
