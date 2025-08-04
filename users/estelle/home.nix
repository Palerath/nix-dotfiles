{ config, pkgs, inputs, ... }:

{

  home.username = "estelle";
  home.homeDirectory = "/home/estelle";
  home.stateVersion = "24.05";


  imports = [
    ./logiciels.nix
  ];

}
