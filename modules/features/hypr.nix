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

    programs.uwsm = {
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

  flake.homeModules.hyprland = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [self.homeModules.wallpapers];

    config = lib.mkIf pkgs.stdenv.isLinux {
      xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      services.mako = {
        enable = true;
        extraConfig = ''
          background-color=#202020
          text-color=#9b8d7f
          border-color=#9b8d7f
          border-radius=10
          default-timeout=5000
          layer=overlay
        '';
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "hyprlock";
            before_sleep_cmd = "hyprlock";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 600;
              on-timeout = "hyprlock";
            }
            {
              timeout = 900;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";

        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
      };

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
            "fcitx5"
            "mako"
            "waybar"
            "random-wallpaper"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "hyprctl setcursor Adwaita 24"
            "sleep 2 && systemctl --user restart xdg-desktop-portal-hyprland && systemctl --user restart xdg-desktop-portal"
            "systemctl --user import-environment GTK_USE_PORTAL"
            "dbus-update-activation-environment --systemd GTK_USE_PORTAL"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
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
            screenshotDir = "${config.home.homeDirectory}/drives/data/Pictures/Screenshots";
            screenshot = pkgs.writeShellScript "screenshot" ''
              PATH=${pkgs.libnotify}/bin:${pkgs.grimblast}/bin:$PATH
              grimblast --notify copysave output ${screenshotDir}/Screenshot-$(date +%F_%H-%M-%S).png
            '';
            screenshot-area = pkgs.writeShellScript "screenshot-area" ''
              PATH=${pkgs.libnotify}/bin:${pkgs.grimblast}/bin:$PATH
              grimblast --notify copysave area ${screenshotDir}/Screenshot-$(date +%F_%H-%M-%S).png
            '';
          in
            [
              "$mod, Return, exec, $terminal"
              "$mod, D, exec, $menu"
              "$mod, B, exec, zen-beta"
              "$mod SHIFT, Q, killactive"
              "$mod SHIFT, E, exit"
              "$mod SHIFT, Space, togglefloating"
              "$mod, F, fullscreen"

              # Focus
              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              # Lock
              "$mod, Escape, exec, hyprlock"
              # Reload config
              "$mod SHIFT, C, exec, hyprctl reload"

              # Screenshots
              "$mod, 0x002e, exec, ${screenshot}"
              "$mod SHIFT, 0x002e, exec, ${screenshot-area}"

              # Wallpapers
              "$mod, W, exec, random-wallpaper"
              "$mod SHIFT, P, exec, random-wallpaper --image"
              "$mod SHIFT, O, exec, random-wallpaper --gif"
              "$mod SHIFT, L, exec, random-wallpaper --video"
              "$mod SHIFT, M, exec, toggle-wallpaper-audio"

              # Focus
              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              # Move windows
              "$mod SHIFT, H, movewindow, l"
              "$mod SHIFT, L, movewindow, r"
              "$mod SHIFT, K, movewindow, u"
              "$mod SHIFT, J, movewindow, d"

              # Split direction
              "$mod, V, layoutmsg, togglesplit"
            ]
            ++ (
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

          binde = [
            "$mod CTRL, H, resizeactive, -20 0"
            "$mod CTRL, L, resizeactive, 20 0"
            "$mod CTRL, K, resizeactive, 0 -20"
            "$mod CTRL, J, resizeactive, 0 20"
          ];

          extraConfig = ''
            bind = $mod, R, submap, resize
            submap = resize
            binde = , H, resizeactive, -20 0
            binde = , L, resizeactive, 20 0
            binde = , K, resizeactive, 0 -20
            binde = , J, resizeactive, 0 20
            bind = , escape, submap, reset
            bind = , return, submap, reset
            submap = reset
          '';
        };
      };
    };
  };
}
