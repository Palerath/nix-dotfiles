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
      discord
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
      qolibri
      yt-dlp
      ffmpeg
      ffmpegthumbnailer

      # fonts
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      ipafont
      ipaexfont
      migu
      jigmo
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      powerline-fonts
      powerline-symbols
      noto-fonts-emoji
   ];

   programs.git = {
      enable = true;
      userName = "perihelie";
      userEmail = "archibaldmk4@gmail.com";

   };

   programs.fastfetch.settings = {
      logo = {
         source = "images/73712874.png";
         padding = { right = 1; };
      };
   };


   home.sessionVariables = {
      EDITOR = "neovim";
   };

   imports = [
      ./modules/zsh.nix
      ./modules/nvf.nix
      ./modules/alacritty.nix
      ./modules/mpv.nix
      ./modules/hypr/default.nix
   ];

   fonts.fontconfig.enable = true;


   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;
}
