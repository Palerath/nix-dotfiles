{pkgs, ... }:
{

   environment.systemPackages = with pkgs; [
      # Gaming platforms
      lutris
      bottles

      # Steam utilities
      gamescope
      mangohud
      goverlay

      # Wine and compatibility
      wineWowPackages.unstable
      winetricks
      protonup-ng
      protonup-qt

      # Vulkan tools
      vulkan-tools
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
   ];


   programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      # Additional Steam packages
      extraCompatPackages = with pkgs; [
         proton-ge-bin
      ];
   };

   programs.gamemode = {
      enable = true;
      settings = {
         general = {
            renice = 10;
         };
         gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 0;
            amd_performance_level = "high";
         };
      };
   };

   environment.sessionVariables = {
      PROTON_ENABLE_NVAPI = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
   };

   services.udev.packages = with pkgs; [
      game-devices-udev-rules
   ];
}
