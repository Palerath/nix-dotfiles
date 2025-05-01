{config, pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      steam
      gamemode
      protonup-ng
      protonup-qt
      lutris
      wine
      bottles
      mangohud
      xdg-desktop-portal-gtk
   ];
   
   xdg.portal.enable = true;
   xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
   xdg.portal.config.common.default = [ "gtk" ];

   programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # gamemode.enable = true;
   };


}
