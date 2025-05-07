{config, pkgs, ...}:
{
   services.desktopManager.plasma6.enable = true;

   environment.systemPackages = with pkgs; [
      kdePackages.plasma-workspace
      kdePackages.konsole
      kdePackages.plasma-systemmonitor
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.xwaylandvideobridge
      kdePackages.xdg-desktop-portal-kde
   ];

   environment.sessionVariables = {
      NIXOS_OZONE_NL = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
   };

   xdg.portal.config.common.default = [ "kde" ];
}
