{pkgs, ... }:
{
   environment.systemPackages = with pkgs; [
      # Gaming platforms and launchers
      lutris
      bottles
      steam-run
      steam-devices-udev-rules

      # Wine and Proton
      winetricks
      protonup-ng
      protonup-qt
      protontricks
      wineWowPackages.unstableFull
      winePackages.unstableFull
      wine64Packages.unstableFull

      # Gaming utilities
      gamemode
      gamescope
      mangohud
      goverlay
      dxvk

      # Desktop integration
      xdg-desktop-portal-gtk
      steam-devices-udev-rules

      # Additional dependencies
      dotnet-sdk
      libpulseaudio
      libvdpau
      pavucontrol
      mono
      glib-networking
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
      #package = pkgs.steam.override {
      #   extraPkgs = pkgs: with pkgs; [
      #      libkrb5
      #      keyutils
      #      glib-networking
      #      libgudev
      #   ];
      #  };
   };

   programs.gamemode.enable = true;

   # Enable udev rules for game controllers
   services.udev.packages = with pkgs; [
      steam-devices-udev-rules
   ];

   environment.sessionVariables = {
      LD_LIBRARY_PATH = [ 
         "${pkgs.gamemode}/lib" 
      ];
   };

}
