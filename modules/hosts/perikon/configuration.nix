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
      self.nixosModules.gayming
    ];

    # inputMethod = {
    #   type = "fcitx5";
    #   useMozcUT = true;
    # };

    nix.settings = {
      substituters = ["https://cache.nixos-cuda.org"];
      trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
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
