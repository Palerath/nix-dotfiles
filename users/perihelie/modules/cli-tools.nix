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
      nvtopPackages.nvidia
      glances
      slurp
      lf
      tmux
      ffmpeg
      ffmpegthumbnailer
      chafa
      kitty-img
      libsixel
      dconf
      
   ];

   dconf.settings = {
      "org.kde.keyboard" = {
         layouts = [ "qwerty-fr" ];
         defaultLayout = "qwerty-fr";
      };
   };
}
