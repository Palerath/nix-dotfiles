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

   services.displayManager.gdm.enable = true;

}
