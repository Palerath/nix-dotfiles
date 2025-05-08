# source: https://github.com/Andrey0189/nixos-config-reborn/blob/master/home-manager/modules/hyprland/main.nix
{pkgs, inputs, ...}:
{
   wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
         # borders-plus-plus
      ];

      settings = {

         env = [
            # Hint Electron apps to use Wayland
            "NIXOS_OZONE_WL,1"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "QT_QPA_PLATFORM,wayland"
            "XDG_SCREENSHOTS_DIR,$HOME/screens"
         ];
         monitor = [
            "AUS PA278QV, 2560x1440@75, 0x0, 1"
            "WAC Cintiq 16, 1920x1080@60, 0x1440, 1"
         ];

         exec-once = [
            "waybar"
         ];

         "$mainMod" = "SUPER";
         "$terminal" = "alacritty";
         "$fileManager" = "dolphin";
         #  "$fileManager" = "$terminal -e sh -c 'dolphin'";
         "$menu" = "rofi";

         general = {
            gaps_in = 0;
            gaps_out = 0;

            border_size = 2;

            "col.active_border" = "rgba(d65d0eff) rgba(98971aff) 45deg";
            "col.inactive_border" = "rgba(3c3836ff)";

            resize_on_border = true;

            allow_tearing = false;
            layout = "master";
         };

         decoration = {
            rounding = 0;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
               enabled = false;
            };

            blur = {
               enabled = true;
            };
         };

         animations = {
            enabled = true;
         };

         input = {
            kb_layout = "us";
            kb_options = "grp:caps_toggle";
         };

         gestures = {
            workspace_swipe = true;
            workspace_swipe_invert = false;
            workspace_swipe_forever	= true;
         };

         misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
         };
        
         bindm = [
            # mouse movements
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
            "$mainMod ALT, mouse:272, resizewindow"

         ];
      };
   };
}
