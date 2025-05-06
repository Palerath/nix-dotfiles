{config, pkgs, ...}:
{
   services.desktopManager.plasma6.enable = true;

   environment.systemPackages = with pkgs; [
      kdePackages.plasma-workspace
      kdePackages.konsole
      kdePackages.plasma-systemmonitor
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.xwaylandvideobridge
      kdePackages.xdg-desktop-portal-kde
   ];

   environment.sessionVariables = {
      NIXOS_OZONE_NL = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
   };


   systemd.user.services."xdg-desktop-portal-kde" = {
      # Enable it so that `systemctl --user start xdg-desktop-portal-kde` works
      enable = true;                                        # :contentReference[oaicite:4]{index=4}

      # Provide the missing ExecStart
      serviceConfig = {
         Type       = "simple";
         ExecStart  = "${pkgs.kdePackages.xdg-desktop-portal-kde}/libexec/xdg-desktop-portal-kde";
         Restart    = "on-failure";
      };
      wantedBy = [ "default.target" ];
   };
}
