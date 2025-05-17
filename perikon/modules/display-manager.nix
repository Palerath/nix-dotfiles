{
   services.displayManager = {
      enable = true;
      sddm = {
         enable = true;
         setupScript = ''
            unset QT_IM_MODULE
            unset GTK_IM_MODULE
         '';
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
