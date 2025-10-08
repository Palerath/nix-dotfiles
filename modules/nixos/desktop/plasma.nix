{ pkgs, ...}:
{
   services.desktopManager.plasma6.enable = true;
   services.desktopManager.plasma6.enableQt5Integration = true;

   environment.systemPackages = with pkgs; [
      kdePackages.plasma-workspace
      kdePackages.konsole
      kdePackages.plasma-systemmonitor
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.xwaylandvideobridge
      kdePackages.xdg-desktop-portal-kde
      kdePackages.plasma-desktop
      kdePackages.plasma-wayland-protocols
      kdePackages.audiocd-kio
      kdePackages.k3b
      kdePackages.qtwebengine
      kdePackages.filelight
   ];

   environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "KDE";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "KDE";
      MOZ_ENABLE_WAYLAND = "1";           # (optional) for Firefox Wayland support
      NIXOS_OZONE_WL = "1";              # for Chromium/Electron apps:contentReference[oaicite:8]{index=8}
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
   };

   xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable  = true;
      extraPortals = with pkgs; [
         xdg-desktop-portal-gtk
         xdg-desktop-portal-wlr
         kdePackages.xdg-desktop-portal-kde
      ];
      configPackages = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      config.common.default = [ "kde" ];
   };

}
