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
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
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
         gpu = {
            apply_gpu_optimisations = 1;
            gpu_device = 0;
         };
         custom = {
            start = "${pkgs.libglvnd}/bin/libglvnd";
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

   environment.variables = {
      # IMPORTANT: These help with NVIDIA and Vulkan performance
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_SIZE = "1073741824"; # 1GB shader cache
      PROTON_ENABLE_NVAPI = "1"; # For DLSS support in games
      VKD3D_CONFIG = "dxr"; # For DirectX raytracing support
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      WLR_RENDERER = "vulkan";

      # Optional: Use Gamescope for better performance in some games
      # GAMESCOPE_FORCE_FULLSCREEN = "1";
      # STEAM_GAMESCOPE_PATH_PREFIX 
   };


}
