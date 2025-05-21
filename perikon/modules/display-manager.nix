{pkgs,  ... }:
{
   services.displayManager = {
      enable = true;
      sddm = {
         enable = true;
         wayland.enable = true;
         settings = {
            WaylandSession.inputMethod = "ibus";
         };
      };
      defaultSession = "plasma";
   };

   services.xserver.displayManager = {
      gdm.enable = false;
      lightdm.enable = false;
   };

   systemd.services."lightdm.service" = {
      enable = false;
      # masked = true;
   };

}
