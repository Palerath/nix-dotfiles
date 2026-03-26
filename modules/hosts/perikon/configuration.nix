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
      self.nixosModules.fileSystems
      self.nixosModules.init
      self.nixosModules.sops
      self.nixosModules.hyprland
      self.nixosModules.flatpak
      self.nixosModules.audio
      self.nixosModules.gayming
      self.nixosModules.graphics
      self.nixosModules.inputMehtods
    ];

    inputMethod = {
      type = "fcitx5";
      useMozcUT = true;
    };

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
