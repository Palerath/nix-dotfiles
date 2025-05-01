{config, pkgs, ...}:
{
   home.packages = with pkgs; [
      steam
      protonup-ng
      protonup-qt
      lutris
      wine
      bottles
      mangohud
   ];

   programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      gamemode.enable = true;
   };


}
