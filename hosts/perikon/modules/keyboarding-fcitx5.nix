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
}
