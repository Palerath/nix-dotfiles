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
      github-desktop
      discord
      prismlauncher
      vesktop
      qbittorrent
      obsidian
      go
      vlc
      gnome-software
      flatpak
      anki-bin
      texlab
      qolibri
      yt-dlp
      krita
      audacious
      protonvpn-gui
      sqlite
      dbeaver-bin
      # ladybird
      localsend
   ];

   programs.git = {
      enable = true;
      settings.user = {
         name = "perihelie";
         email = "archibaldmk4@gmail.com";
      };
   };

   programs.zen-browser = {
      enable = true;
   };

   home.sessionVariables = {
      EDITOR = "nvim";
   };

   dconf = {
      settings = {
         "org.kde.keyboard" = {
            layouts = [ "qwerty-fr" ];
            defaultLayout = "qwerty-fr";
         };
      };

   };

   imports = [
      ./modules/fish.nix
      ./modules/nushell.nix
      ./modules/zsh.nix
      ./modules/nvf.nix
      # ./modules/test.nix
      ./modules/alacritty.nix
      ./modules/wezterm.nix
      ./modules/kitty.nix
      ./modules/mpv.nix
      ./modules/hypr/default.nix
      ./modules/fastfetch.nix
      ./modules/session-variables.nix
      ./modules/desktop-entries.nix
      ./modules/cli-tools.nix
      ./modules/tmux.nix
      ./modules/gallery-dl.nix
      # ./modules/emacs.nix
      inputs.zen-browser.homeModules.beta
      inputs.nvf.homeManagerModules.default
   ];

   fonts.fontconfig.enable = true;

   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
