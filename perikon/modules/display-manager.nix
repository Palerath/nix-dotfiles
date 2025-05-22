{
   services.displayManager = {
      enable = true;
      sddm = {
         enable = false;
         wayland.enable = true;
         settings = {
            WaylandSession.inputMethod = "ibus";
         };
      };
      defaultSession = "plasma";
   };

   services.xserver.displayManager = {
      gdm.enable = true;
      lightdm.enable = false;
   };

   systemd.services."lightdm.service" = {
      enable = false;
      # masked = true;
   };

}
