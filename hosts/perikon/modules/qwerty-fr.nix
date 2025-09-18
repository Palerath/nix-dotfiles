{pkgs, ...}:
{
   environment.systemPackages = [ pkgs.qwerty-fr ];

   services.xserver.xkb = {
      extraLayouts.qwerty-fr = {
         description = "QWERTY-FR layout";
         languages = [ "fr" ];
         symbolsFile = ./symbols/us_qwerty-fr; # Local file path
      };

      layout = "qwerty-fr";
      variant = "";
   };

   systemd.services.display-manager = {
      environment = {
         XKB_DEFAULT_LAYOUT = "qwerty-fr";
         # XKB_DEFAULT_VARIANT = "";
      };
   };
  
   console.keyMap = "fr";
}
