{ pkgs, ... }:
{
   home.packages = with pkgs; [
      tree
      ueberzug
      unrar
      p7zip
      unzip
      wget
      btop
      htop
      nvtopPackages.nvidia
      glances
      slurp
      # lf
      # tmux
      zellij
      ffmpeg
      ffmpegthumbnailer
      chafa
      kitty-img
      libsixel
      dconf
      ripgrep-all
      fd
      bat
      eza
      zoxide
      xh
      gitui
      dust
      dua
      yazi
      evil-helix
      cargo-info
      fselect
      delta
      tokei
      wiki-tui
      # presenterm
      oh-my-posh 
      sqlite
   ];

   dconf = {
      settings = {
         "org.kde.keyboard" = {
            layouts = [ "qwerty-fr" ];
            defaultLayout = "qwerty-fr";
         };
      };

   };

   # Oh My Posh with M365 Princess theme
   programs.oh-my-posh = {
      enable = true;
      # useTheme = "M365Princess";
      useTheme = "tokyo";
   };


   programs.command-not-found.enable = false;

}
