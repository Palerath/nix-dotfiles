{
   services.gammastep = {
      enable = true;
      provider = "manual";

      latitude = "49.43";
      longitude = "1.08";

      settings = {
         general = {
            temp-day = 6500;
            temp-night = 2700;
            gamma = 0.8;
            brightness-day = 1.0;
            brightness-night = 0.8;

            transition = 1;
            fade = 2;
         };
      };

      tray = true;

   };
}
