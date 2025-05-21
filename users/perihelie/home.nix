{  pkgs, ... }:

{
   # Home Manager needs a bit of information about you and the paths it should
   # manage.
   home.username = "perihelie";
   home.homeDirectory = "/home/perihelie";

   home.stateVersion = "25.05"; # Please read the comment before changing.

   nixpkgs.config.allowUnfree = true;

   home.packages = with pkgs; [
      git
      discord
      tree
      ueberzug
      prismlauncher
      unrar
      p7zip
      unzip
      wget
      vesktop
      btop
      qbittorrent
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
      qolibri
      yt-dlp
      ffmpeg
      ffmpegthumbnailer
      chafa
      kitty-img
      libsixel
      krita
      dconf
      glances
   ];

   programs.git = {
      enable = true;
      userName = "perihelie";
      userEmail = "archibaldmk4@gmail.com";

   };

   home.sessionVariables = {
      EDITOR = "nvim";
   };

   imports = [
      ./modules/zsh.nix
      ./modules/nvf.nix
      ./modules/alacritty.nix
      ./modules/wezterm.nix
      ./modules/mpv.nix
      ./modules/hypr/default.nix
      ./modules/fastfetch.nix
      ./modules/session-variables.nix
      ./modules/redshift.nix
      # ./modules/peridroid.nix
   ];

   fonts.fontconfig.enable = true;


   dconf.settings = {
      "org.kde.keyboard" = {
         layouts = [ "qwerty-fr" ];
         defaultLayout = "qwerty-fr";
      };
   };


   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
