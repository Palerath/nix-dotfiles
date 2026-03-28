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
      self.nixosModules.desktopCompositors
      self.nixosModules.flatpak
      self.nixosModules.audio
      self.nixosModules.gayming
      self.nixosModules.graphics
      self.nixosModules.qwertyFR
      self.nixosModules.inputMethods
      self.nixosModules.tailscaleClient
      self.nixosModules.sunshine
      self.nixosModules.containerMachines
      # self.nixosModules.openTv
      self.nixosModules.otherPrograms
    ];

    # sops.defaultSopsFile = ./perikon_secrets.yaml;

    inputMethod = {
      type = "fcitx5";
      useMozcUT = true;
    };

    networking.hostName = hostName;
    my.primaryUser = "perihelie";
    environment.systemPackages = [pkgs.ethtool];
    environment.sessionVariables = {
      NH_FLAKE = lib.mkDefault "/home/perihelie/dotfiles";
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
