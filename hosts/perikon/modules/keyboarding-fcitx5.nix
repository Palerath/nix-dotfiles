{pkgs , ... }:
{
   i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ 
         fcitx5-mozc         # Japanese conversion engine
         fcitx5-gtk          # GTK integration
         fcitx5-configtool    # Configuration GUI
      ];
      fcitx5.waylandFrontend = true; # Critical for Wayland compatibility
   };

   # QWERTY-FR
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
         XKB_DEFAULT_VARIANT = "";
      };
   };
   console.keyMap = "fr";
}
