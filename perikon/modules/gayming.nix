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
      steam-devices-udev-rules
   ];

   xdg.portal.enable = true;
   xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

   programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # gamemode.enable = true;
   };


}
