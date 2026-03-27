{
  self,
  inputs,
  ...
}: let
  perihelieHomeModule = {config, ...}: {
    home.username = "perihelie";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;

    imports = [
      self.homeModules.sops
      self.homeModules.shell
      self.homeModules.helix
      self.homeModules.hyprland
      self.homeModules.gayming
      self.homeModules.fonts
      self.homeModules.galleryDL
    ];
    sops.defaultSopsFile = ./perihelie_secrets.yaml;
  };
in {
  flake.nixosModules.perihelieConfiguration = {
    pkgs,
    hostName,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.locales
      self.nixosModules.fonts
    ];

    users.users.perihelie = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["networkmanager" "wheel" "video" "input" "users"];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs hostName;};
      backupFileExtension = "backup";

      users.perihelie = {...}: {
        imports = [perihelieHomeModule];
      };
    };
  };

  flake.homeModules.perihelieHome = perihelieHomeModule;
}
