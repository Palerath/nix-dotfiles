{pkgs, ... }:
{
   environment.systemPackages = with pkgs; [
      # Gaming platforms and launchers
      lutris
      bottles
      steam-run
      gamescope

      # Wine and Proton
      wine
      winetricks
      protonup-ng
      protonup-qt
      protontricks
      wineWowPackages.unstableFull
      winePackages.unstableFull
      wine64Packages.unstableFull

      # Gaming utilities
      gamemode
      mangohud
      dxvk

      # Graphics and system dependencies
      vulkan-loader
      vulkan-tools
      libGL
      libgcrypt

      # Desktop integration
      xdg-desktop-portal-gtk
      steam-devices-udev-rules

      # Additional dependencies
      dotnet-sdk
   ];

   xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
         xdg-desktop-portal-gtk
      ];
   };   


   # Steam configuration
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

   programs.gamemode = {
      enable = true;
      settings = {
         general = {
            renice = 10;  # Process priority when gaming
         };
      };
   };

   security.wrappers = {
      gamescope = {
         owner = "root";
         group = "root";
         capabilities = "cap_sys_nice+ep";
         source = "${pkgs.gamescope}/bin/gamescope";
      };
   };

}
