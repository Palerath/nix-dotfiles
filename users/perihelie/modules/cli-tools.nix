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
      tmux
      zellij
      ffmpeg
      ffmpegthumbnailer
      chafa
      kitty-img
      libsixel
      dconf
      ripgrep
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
      fd                 
      fzf          
      glow         # Terminal markdown viewer
      pandoc       # Document converter
      eza
      unixtools.netstat
      prettierd
      nixfmt-rfc-style
   ];

   dconf = {
      settings = {
         "org.kde.keyboard" = {
            layouts = [ "qwerty-fr" ];
            defaultLayout = "qwerty-fr";
         };
      };

   };

   programs.oh-my-posh = {
      enable = true;
      useTheme = "hul10";
   };


   programs.command-not-found.enable = false;

}
