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
      XDG_CURRENT_DESKTOP = "KDE";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "plasmawayland";
      MOZ_ENABLE_WAYLAND = "1";           # (optional) for Firefox Wayland support
      NIXOS_OZONE_WL = "1";              # for Chromium/Electron apps:contentReference[oaicite:8]{index=8}
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
   };

   xdg.portal.config.common.default = [ "kde" ];
}
