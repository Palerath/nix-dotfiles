{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.kdePlasma = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      kdePackages.plasma-workspace
      kdePackages.plasma-desktop
      kdePackages.plasma-wayland-protocols
      # kdePackages.wallpaper-engine-plugin
      kdePackages.qtwayland
      kdePackages.kirigami-addons
      kdePackages.kscreen
      kdePackages.kompare
    ];

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

    services.desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };

    systemd.user.services.kbuildsycoca6 = {
      Unit = {
        Description = "Rebuild KDE cache";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental";
        RemainAfterExit = true;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    home-manager.sharedModules = [
      {
        xdg.configFile."kwinrc".text = ''
          [Compositing]
          LatencyPolicy=Low
          RenderLoop=Threaded
        '';
      }
    ];
  };
}
