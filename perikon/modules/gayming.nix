{config, pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      gamemode
      protonup-ng
      protonup-qt
      lutris
      wine
      bottles
      mangohud
      xdg-desktop-portal-gtk
      steam-devices-udev-rules
      wineWowPackages.unstableFull
      winePackages.unstableFull
      wine64Packages.unstableFull
      dotnet-sdk
      winetricks
      protontricks
      dxvk
      vulkan-loader
      libGL
      libgcrypt
   ];

   xdg.portal.enable = true;
   xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

   programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;  
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;

      package = pkgs.steam.override {
         extraPkgs = pkgs: with pkgs; [
            libkrb5
            keyutils
         ];
      };
   };


}
