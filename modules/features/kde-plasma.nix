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
    services.desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };

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

    home-manager.sharedModules = [
      {
        xdg.configFile."kwinrc".text = ''
          [Compositing]
          LatencyPolicy=Low
          RenderLoop=Threaded
        '';
        # auto start kbuildsyscoca6
        xdg.configFile."autostart/kbuildsycoca6.desktop".text = ''
          [Desktop Entry]
          Exec=kbuildsycoca6 --noincremental
          Icon=system-run
          Name=Rebuild KDE cache
          Type=Application
          X-KDE-autostart-phase=1
        '';
      }
    ];
  };
}
