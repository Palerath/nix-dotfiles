{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          binPath = "${pkgs.hyprland}";
        };
      };
    };
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myHyprland = inputs.hyprland.lib.wrap {
      inherit pkgs;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun";

        monitor = [
          "DP-1,2560x1440@75,0x0,1"
          "HDMI-A-2,1920x1080@60,320x1440,1"
        ];

        exec-once = [
          "uwsm app -- fcitx5"
          "uwsm app -- mako"
          "uwsm app -- waybar"
          "hyprctl setcursor Adwaita 24"
        ];

        input = {
          kb_layout = "qwerty-fr";
          follow_mouse = 1;
        };

        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "NVD_BACKEND,direct"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(4c7899ff)";
          layout = "dwindle";
        };

        # Bindings
        bind =
          [
            "$mod, Return, exec, uwsm app -- $terminal"
            "$mod, D, exec, uwsm app -- $menu"
            "$mod SHIFT, Q, killactive"
            "$mod, F, fullscreen"
            # Focus
            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"
          ]
          ++ (
            # Workspace binds
            builtins.concatLists (builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${ws}"
                ]
              )
              9)
          );

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
