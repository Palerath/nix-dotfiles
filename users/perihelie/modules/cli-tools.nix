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
      zellij
      ffmpeg
      ffmpegthumbnailer
      chafa
      libsixel
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
      cargo-info
      fselect
      delta
      tokei
      wiki-tui
      # presenterm
      fd                 
      fzf          
      glow         # Terminal markdown viewer
      pandoc       # Document converter
      eza
      unixtools.netstat
      prettierd
      nixfmt-rfc-style
      tmux
      pipes-rs
      dysk
   ];
   programs.oh-my-posh = {
      enable = true;
      useTheme = "hul10";
   };

   programs.command-not-found.enable = false;

}
