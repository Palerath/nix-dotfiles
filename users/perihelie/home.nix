{  pkgs, inputs, ... }:

{
   # Home Manager needs a bit of information about you and the paths it should
   # manage.
   home.username = "perihelie";
   home.homeDirectory = "/home/perihelie";

   home.stateVersion = "24.11"; # Please read the comment before changing.

   nixpkgs.config.allowUnfree = true;

   home.packages = with pkgs; [
      git
      discord
      prismlauncher
      vesktop
      qbittorrent
      obsidian
      go
      vlc
      gnome-software
      flatpak
      anki
      texlab
      qolibri
      yt-dlp
      krita
      audacious
      protonvpn-gui
      sqlite
      dbeaver-bin
      ladybird
      vivaldi
   ];

   programs.git = {
      enable = true;
      userName = "perihelie";
      userEmail = "archibaldmk4@gmail.com";

   };

   programs.zen-browser = {
      enable = true;
   };

   home.sessionVariables = {
      EDITOR = "nvim";
   };

   imports = [
      ./modules/fish.nix
      ./modules/nushell.nix
      ./modules/zsh.nix
      ./modules/nvf.nix
      ./modules/alacritty.nix
      ./modules/wezterm.nix
      ./modules/mpv.nix
      ./modules/hypr/default.nix
      ./modules/fastfetch.nix
      ./modules/session-variables.nix
      ./modules/desktop-entries.nix
      ./modules/cli-tools.nix
      # ./modules/perilization.nix
      ./modules/emacs.nix
      inputs.zen-browser.homeModules.beta
   ];

   fonts.fontconfig.enable = true;

   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
