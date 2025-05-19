{pkgs, lib, ... }:
{
   services.redshift = {
      enable = true;
      package = pkgs.redshift;
      tray = true;
      enableVerboseLogging  = false;    
      latitude = "49.433331";
      longitude = "1.08333";
      # temperature.day       = 6500;  
      # temperature.night     = 3400;
      dawnTime = "07:00";
      duskTime = "21:00";
      settings = {
         redshift = {
            adjustement-method = "randr";
            # brightness-day = "1.0";   
            # brightness-night = "0.7";
            temp-day = lib.mkDefault "6500";
            temp-night = lib.mkDefault "3700";
            transition = true;
         };
         randr = {
            screen = 0;
         };

      };

   };
}
