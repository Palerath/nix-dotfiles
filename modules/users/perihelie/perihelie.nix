{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.perihelieConfiguration = {pkgs, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    environment.systemPackages = [pkgs.home-manager];
    users.users.perihelie = {
      isNormalUser = true;
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "users"
      ];
    };
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};

      backupFileExtension = "backup";

      users.perihelie = {
        imports = [self.homeModules.perihelieHome];
      };
    };
  };

  flake.homeModules.perihelieHome = {config, ...}: {
    home.username = "perihelie";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;

    imports = [
      self.homeModules.perihelie.shell
      self.homeModules.perihelie.hyprland
    ];
  };
}
