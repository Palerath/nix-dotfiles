{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktopCompositors = {
    lib,
    pkgs,
    ...
  }: {
    imports = with self.nixosModules; [
      kdePlasma
      hyprland
    ];

    environment.systemPackages = with pkgs; [
      xwayland
      xwayland-satellite
    ];

    services.dbus.packages = with pkgs; [
      xdg-desktop-portal
    ];

    environment.sessionVariables = {
      NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";
      QML2_IMPORT_PATH = "/run/current-system/sw/lib/qt-6/qml";
      GDK_BACKEND = "wayland,x11";
      GTX_USE_PORTAL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    systemd.user.services.xdg-desktop-portal = {
      environment = {
        NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";
      };
    };
  };
}
