{ pkgs, ... }:
{

   environment.systemPackages = with pkgs; [
      # Gaming platforms
      lutris
      bottles
      ckan
      rpcs3
      pcsx2
      ryubing

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

   # temporary fix else it does not compile
   nixpkgs.overlays = [
      (final: prev: {
         argagg = prev.argagg.overrideAttrs (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
               "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
            ];
         });

         slop = prev.slop.overrideAttrs (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
               "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
            ];
         });
         allegro = prev.allegro.overrideAttrs (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
               "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
            ];
         });
      })
   ];
}
