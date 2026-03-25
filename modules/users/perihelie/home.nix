{
  self,
  inputs,
  ...
}: {
  flake.homeModules.perihelieConfiguration = {config, ...}: {
    home.username = "perihelie";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "24.05";
  };
}
