{ config, pkgs, ... }:

{
   # Home Manager needs a bit of information about you and the paths it should
   # manage.
   home.username = "perihelie";
   home.homeDirectory = "/home/perihelie";

   home.stateVersion = "24.11"; # Please read the comment before changing.
   
   nixpkgs.config.allowUnfree = true;

   home.packages = with pkgs; [
      git
      tree
      ueberzug
      prismlauncher
      lutris
      unrar
      p7zip
      unzip
      wget
      wine
      vesktop
      fastfetch
      btop
      qbittorrent
      dconf
      slurp
      wl-clipboard
      obsidian
      go
      vlc
      lf
      tmux
   ];

   programs.git = {
      enable = true;
      userName = "perihelie";
      userEmail = "archibaldmk4@gmail.com";		

   };

   home.sessionVariables = {
      EDITOR = "neovim";
   };

   imports = [
      ../../common/home_common.nix
      ./modules/zsh.nix
      ./modules/nvf.nix
      ./modules/steam.nix
      ./modules/alacritty.nix
   ];

   fonts.fontconfig.enable = true;


   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
