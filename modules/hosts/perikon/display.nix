{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.display = {
    pkgs,
    lib,
    ...
  }: {
    services = {
      displayManager = {
        enable = true;

        autoLogin = {
          enable = false;
          user = "perihelie";
        };

        sddm = {
          enable = false;
          wayland.enable = true;
        };
        gdm = {
          enable = false;
          wayland = true;
        };
        ly.enable = true;
        defaultSession = "hyprland";
      };
    };

    environment.systemPackages = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      kdePackages.plasma-workspace
      kdePackages.plasma-desktop
      kdePackages.plasma-wayland-protocols
      kdePackages.qtwayland
      kdePackages.kirigami-addons
      kdePackages.kscreen
    ];

    services.desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
      gnome.enable = false;
    };

    systemd.services.display-manager = {
      after = ["systemd-udev-settle.service" "plymouth-quit.service"];
      wants = ["systemd-udev-settle.service"];
    };
    systemd.packages = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common = {
          default = ["kde"];
        };
        hyprland = {
          default = ["hyprland" "kde"];
          "org.freedesktop.impl.portal.FileChooser" = ["kde"];
          "org.freedesktop.impl.portal.Settings" = ["kde"];
          "org.freedesktop.impl.portal.Inhibit" = ["kde"];
        };
        plasmax11 = {
          default = ["kde"];
        };
        plasma = {
          default = ["kde"];
        };
      };
    };

    environment.variables = {
      GTK_USE_PORTAL = "1";
    };

    services.dbus.packages = with pkgs; [
      xdg-desktop-portal
    ];

    environment.sessionVariables = {
      NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";
    };

    systemd.user.services.xdg-desktop-portal = {
      environment = {
        NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";
      };
    };
  };
}
