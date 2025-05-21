# source: https://github.com/Andrey0189/nixos-config-reborn/blob/master/home-manager/modules/hyprland/binds.nix
{pkgs, ...}:
{
   wayland.windowManager.hyprland.settings = {

      bind = [
         "$mainMod,     T, exec, $terminal"
         "$mainMod ALT, C, killactive,"
         "$mainMod ALT, Q, exit,"
         "$mainMod,     E, exec, $fileManager"
         "$mainMod      W, exec, $browser"
         "$mainMod,     F, togglefloating,"
         "$mainMod,     D, exec, $menu --show drun"
         "$mainMod,     P, pin,"
         "$mainMod,     J, togglesplit,"
         "$mainMod,     V, exec, cliphist list | $menu --dmenu | cliphist decode | wl-copy"
         "$mainMod,     B, exec, pkill -SIGUSR2 waybar"
         "$mainMod ALT, B, exec, pkill -SIGUSR1 waybar"
         "$mainMod,     L, exec, loginctl lock-session"
         "$mainMod,     P, exec, hyprpicker -an"
         ", Print, exec, grimblast --notify --freeze copysave area"

         # Moving focus
         "$mainMod, h, movefocus, l"
         "$mainMod, l, movefocus, r"
         "$mainMod, j, movefocus, u"
         "$mainMod, k, movefocus, d"

         # Moving windows
         "$mainMod SHIFT, h,  swapwindow, l"
         "$mainMod SHIFT, l, swapwindow, r"
         "$mainMod SHIFT, j,    swapwindow, u"
         "$mainMod SHIFT, k,  swapwindow, d"

         # Resizeing windows                   X  Y
         "$mainMod CTRL, h,  resizeactive, -60 0"
         "$mainMod CTRL, l, resizeactive,  60 0"
         "$mainMod CTRL, j,    resizeactive,  0 -60"
         "$mainMod CTRL, k,  resizeactive,  0  60"

         # Switching workspaces
         "$mainMod, 1, workspace, 1"
         "$mainMod, 2, workspace, 2"
         "$mainMod, 3, workspace, 3"
         "$mainMod, 4, workspace, 4"
         "$mainMod, 5, workspace, 5"
         "$mainMod, 6, workspace, 6"
         "$mainMod, 7, workspace, 7"
         "$mainMod, 8, workspace, 8"
         "$mainMod, 9, workspace, 9"
         "$mainMod, 0, workspace, 10"

         # Moving windows to workspaces
         "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
         "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
         "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
         "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
         "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
         "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
         "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
         "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
         "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
         "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
         "$mainMod, mouse:272, movewindow"
         "$mainMod, mouse:273, resizewindow"
      ];
   }; 
}
