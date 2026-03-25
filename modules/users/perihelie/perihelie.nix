{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.perihelieConfiguration = {pkgs, ...}: {
    environment.systemPackages = [pkgs.home-manager];
    users.users.perihelie = {
      isNormalUser = true;
      description = "perihelie";
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "users"
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs;};

        backupFileExtension = "backup";
      };
    };
  };

  flake.homeModules.perihelieHomeConfiguration = {config, ...}: {
    home.username = "perihelie";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "24.05";
  };
}
