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
