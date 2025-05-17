{pkgs, ...}:
{
   # Enable graphics support
   hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs;[
         mesa
         vulkan-loader
      ];

   };

   # Specify the NVIDIA driver
   services.xserver.videoDrivers = [ "nvidia" ];

   hardware.nvidia = {
      open = true;
      videoAcceleration = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting = {
         enable = true;
      };

      nvidiaSettings = true;
   };

   xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
         xdg-desktop-portal-gtk
         xdg-desktop-portal-wlr
      ];
      configPackages = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
   };

   systemd.user.services."xdg-desktop-portal".enable = true;

   environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "KDE";
      # Tell QtWebEngine-based apps to use the portal
      QTWEBENGINE_USE_PORTAL = "1";

   };
}
