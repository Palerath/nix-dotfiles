{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.gayming = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      inputs.aagl.nixosModules.default
    ];

    environment.systemPackages = with pkgs; [
      gamescope-wsi
      steam-run
      (bottles.override {removeWarningPopup = true;})

      wineWow64Packages.unstableFull
      winetricks
      dxvk
      vkd3d
      vkd3d-proton
      protonup-qt
      protonplus

      # Vulkan tools
      vulkan-tools
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
      vkbasalt
      libglvnd
    ];

    programs.steam = {
      enable = true;
      extest.enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    environment.sessionVariables = {
      PROTON_ENABLE_NVAPI = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      XALIA_DISABLE = "1";
      DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";
      VKD3D_CONFIG = "dxr";
    };

    nix.settings = inputs.aagl.nixConfig;
    programs = {
      # anime-games-launcher.enable = true;
      honkers-railway-launcher.enable = true;
      #    anime-game-launcher.enable = false;
      #    honkers-launcher.enable = false;
      #    wavey-launcher.enable = false;
      #    sleepy-launcher.enable = false;
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [steam-run];
    };

    services.udev.packages = with pkgs; [
      game-devices-udev-rules
    ];
  };
  flake.homeModules.gayming = {
    pkgs,
    pkgs-stable,
    ...
  }: {
    home.packages = [
      pkgs.lutris
      pkgs.ckan
      pkgs.rpcs3
      pkgs.gnushogi
      pkgs-stable.heroic
    ];

    programs.mangohud = {
      enable = true;
      settings = {
        toggle_hud = "Shift_R+F12";
        toggle_logging = "Shift_L+F2";

        position = "top-left";
        font_size = 24;
        background_alpha = 0.5;
        alpha = 1.0;

        fps_limit = 150;
        vsync = 0;

        fps = true;
        frametime = true;
        frame_timing = 1;

        gpu_stats = true;
        gpu_temp = true;
        gpu_power = true;
        gpu_load_change = true;
        gpu_junction_temp = true;
        gpu_mem_temp = true;

        cpu_stats = true;
        cpu_temp = true;
        cpu_power = true;

        ram = true;
        vram = true;

        throttling_status = true;
      };

      settingsPerApplication = {
        "WutheringWaves" = {
          fps_limit = "60";
          position = "top-right";
        };
      };
    };
  };
}
