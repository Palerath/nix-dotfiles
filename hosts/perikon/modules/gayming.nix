{pkgs, ... }:
{
   environment.systemPackages = with pkgs; [
      # Gaming platforms and launchers
      lutris
      bottles
      steam-run

      # Wine and Proton
      wine
      wine-wayland
      wine64
      winetricks
      protonup-ng
      protonup-qt
      protontricks
      wineWowPackages.stable
      winePackages.stable
      wine64Packages.stable

      # Gaming utilities
      gamemode
      gamescope
      mangohud
      goverlay
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
      libpulseaudio
      libvdpau
      pavucontrol
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
            glib-networking
            libgudev
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



}
