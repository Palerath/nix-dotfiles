{pkgs, ... }:
{
   services.redshift = {
      enable = true;
      latitude = "49.433331";
      longitude = "1.08333";
      temperature.day       = 6500;  
      temperature.night     = 3400;
      brightness.day        = "1.0";    
      brightness.night      = "0.7";
      extraOptions          = [ "-m" "randr" "-v" ];
      package               = pkgs.redshift;
      tray                  = true;
      enableVerboseLogging  = false;     
   };
}
