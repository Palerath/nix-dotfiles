{config, pkgs, inputs, ...}:
{
   wayland.windowManager.hyprland = {
      enable = true;

      plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
         borders-plus-plus
      ];
      settings = {
         "$mod" = "SUPER";

         bindm = [
            # mouse movements
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"

         ];
      };
   };
   # ...
}
