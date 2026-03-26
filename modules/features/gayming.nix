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
      self.homeModules.gayming
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
  }: {
    home.packages = [
      pkgs.lutris
      pkgs.ckan
      pkgs.rpcs3
      pkgs.gnushogi
      pkgs-stable.heroic
    ];
  };
}
