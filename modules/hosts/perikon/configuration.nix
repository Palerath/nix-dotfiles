{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.perikonConfiguration = {
    pkgs,
    lib,
    hostName,
    self,
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
      self.nixosModules.inputMethods
      self.nixosModules.tailscaleClient
      self.nixosModules.sunshine
      self.nixosModules.containerMachines
    ];

    sops.defaultSopsFile = ./perikon_secrets.yaml;

    networking.hostName = hostName;
    my.primaryUser = "perihelie";
    environment.systemPackages = [pkgs.ethtool];

    inputMethod = {
      type = "fcitx5";
      useMozcUT = true;
    };

    hardware.opentabletdriver.enable = true;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

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
