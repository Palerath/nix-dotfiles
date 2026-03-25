{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    imports = [inputs.hyprland.nixosModules.default];
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.uswm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };

    nix.settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  flake.homeModules.perihelie.hyprland = {
    pkgs,
    config,
    lib,
    ...
  }: {
    config = lib.mkIf pkgs.stdenv.isLinux {
      xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        settings = {
          "$mod" = "SUPER";
          "$terminal" = "kitty";
          "$menu" = "wofi --show drun";

          monitor = [
            "DP-1,2560x1440@75,0x0,1"
            "HDMI-A-2,1920x1080@60,320x1440,1"
          ];

          exec-once = [
            "kbuildsycoca6"
            "uwsm app -- fcitx5"
            "uwsm app -- mako"
            "uwsm app -- waybar"
            "random-wallpaper"
            "hyprctl setcursor Adwaita 24"
            "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          ];

          input = {
            kb_layout = "qwerty-fr";
            follow_mouse = 1;
            sensitivity = 0;
          };

          cursor.no_hardware_cursors = 2;

          env = [
            "XCURSOR_THEME,Adwaita"
            "XCURSOR_SIZE,24"
            "LIBVA_DRIVER_NAME,nvidia"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
          ];

          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 2;
            "col.active_border" = "rgba(4c7899ff)";
            "col.inactive_border" = "rgba(333333ff)";
            layout = "dwindle";
          };

          bind = let
            screenshotDir = "${config.home.homeDirectory}/Pictures/Screenshots";
            # Use lib.getExe to make it more robust
            screenshot = pkgs.writeShellScript "screenshot" ''
              ${lib.getExe pkgs.grimblast} --notify copysave output ${screenshotDir}/Screenshot-$(date +%F_%H-%M-%S).png
            '';
          in
            [
              "$mod, Return, exec, uwsm app -- $terminal"
              "$mod, D, exec, uwsm app -- $menu"
              "$mod SHIFT, Q, killactive"
              "$mod, Escape, exec, uwsm app -- hyprlock"

              # Focus
              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              # Custom screenshot bind
              "$mod, 0x002e, exec, ${screenshot}"
            ]
            ++ (
              # Workspace loops (easier in Home Manager than manual wrapping!)
              builtins.concatLists (builtins.genList (
                  i: let
                    ws = i + 1;
                  in [
                    "$mod, code:1${toString i}, workspace, ${toString ws}"
                    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
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
  };
}
