{config, pkgs, inputs, ...}:
let
   startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &

      sleep 1
      ${pkgs.swww}/bin/swww img ${./home/perihelie/drives/hdd/Pictures/Wallpapers/Ef8_RFsUEAEfowo.jpg} &
      '';
in
   {
   wayland.windowManager.hyprland = {
      enable = true;
   
      plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
         borders-plus-plus
      ];

      setting = {
         exec-once = ''${startupScript}/bin/start'';
         general = with config.colorScheme.colors; {
            "col.active_border" = "rgba(${base0E}ff) rdga(${base09}ff) 60deg";
            "col.inactive_border" = "rgba(${base00}ff)";
         };
         decoration = {
            shadow_offset = "0 5";
            "col.shadow" = "rgba(00000099)";
         };

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
