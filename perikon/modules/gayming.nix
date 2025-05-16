{config, pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      gamemode
      protonup-ng
      protonup-qt
      wine
      bottles
      mangohud
      xdg-desktop-portal-gtk
      steam-devices-udev-rules
   ];

   xdg.portal.enable = true;
   xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

   programs.lutris-unwrapped = {
      enable = true;
      package = pkgs.lutris.override {
         extraPkgs = pkgs: with pkgs; [
            wineWowPackages
            winePackages
            vulkan-loader
            dxvk
            gamemode
         ];
         extraLibraries = pkgs: with pkgs; [
            libGL
            libgcrypt
         ];
      };

      env = ''
         export DXVK_HUD=full
      '';
   };

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
