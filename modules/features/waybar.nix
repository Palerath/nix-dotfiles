{
  self,
  inputs,
  ...
}: {
  flake.homeModules.waybar = {pkgs, ...}: let
    powerMenu = pkgs.writeShellScriptBin "waybar-power-menu" ''
      MENU="${pkgs.wofi}/bin/wofi --dmenu -i -p Power"
      OPTIONS="Lock\nLogout\nReboot\nShutdown"
      CHOICE=$(echo -e "$OPTIONS" | $MENU)

      case "$CHOICE" in
          "Lock")
          ${pkgs.swaylock-effects}/bin/swaylock -f
              ;;
          "Logout")
          ${pkgs.hyprland}/bin/hyprctl dispatch exit
              ;;
          "Reboot")
              systemctl reboot
              ;;
          "Shutdown")
              systemctl poweroff
              ;;
      esac
    '';
  in {
    home.packages = [pkgs.wofi powerMenu];

    programs.waybar = {
      enable = true;
      # style = builtins.readFile ./waybar.css;

      settings = [
        {
          layer = "top";
          position = "bottom";
          height = 30;
          reload_style_on_change = true;

          modules-left = ["hyprland/workspaces" "hyprland/mode"];
          modules-center = ["hyprland/window"];
          modules-right = [
            "tray"
            "cpu"
            "custom/gpu"
            "memory"
            "custom/separator"
            "network"
            "pulseaudio"
            "custom/separator"
            "clock"
            "custom/separator"
            "custom/power"
          ];

          # sway → hyprland modules
          "hyprland/window" = {
            max-length = 50;
          };

          "hyprland/workspaces" = {
            # optional extras; safe to remove if not needed
            all-outputs = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };

          "hyprland/mode" = {};

          # tray
          tray = {
            spacing = 10;
            tooltip = false;
          };

          # cpu
          cpu = {
            format = "cpu {usage}%";
            interval = 2;
            states = {
              critical = 90;
            };
          };

          # memory
          memory = {
            format = "mem {percentage}%";
            interval = 2;
            states = {
              critical = 80;
            };
          };

          # gpu
          "custom/gpu" = {
            exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print \"gpu \" $1\"%\"}'";
            format = "{}";
            interval = 2;
            tooltip = false;
          };

          # network
          network = {
            format-wifi = "wifi {bandwidthDownBits}";
            format-ethernet = "enth {bandwidthDownBits}";
            format-disconnected = "no network";
            interval = 5;
            tooltip = false;
          };

          # pulseaudio
          pulseaudio = {
            scroll-step = 5;
            max-volume = 150;
            format = "vol {volume}%";
            format-bluetooth = "vol {volume}%";
            nospacing = 1;
            on-click = "pavucontrol";
            tooltip = false;
          };

          # clock
          clock = {
            format = "{:%Y-%m-%d  %H:%M:%S}";
            interval = 1;
          };

          # custom separator
          "custom/separator" = {
            format = "::";
            interval = "once";
            tooltip = false;
          };

          # power menu
          "custom/power" = {
            format = "⏻";
            on-click = "waybar-power-menu";
            tooltip = false;
          };
        }
      ];
    };
  };
}
