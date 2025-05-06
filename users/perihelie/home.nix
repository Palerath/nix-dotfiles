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
      unrar
      p7zip
      unzip
      wget
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
      gnome-software
      flatpak
      anki
      nvtopPackages.nvidia
      texlab
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
      ./modules/alacritty.nix
      ./modules/mpv.nix
   ];

   fonts.fontconfig.enable = true;


   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
