{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.graphics = {
    pkgs,
    config,
    ...
  }: {
    nix.settings = {
      substituters = ["https://cache.nixos-cuda.org"];
      trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
    };

    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
      vulkan-volk
      vulkan-extension-layer
      vulkan-validation-layers

      mesa
      mesa-demos
      egl-wayland

      cudaPackages.cudatoolkit
      nvidia-vaapi-driver
      nvtopPackages.full
    ];

    services = {
      lact.enable = true;
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
        deviceSection = ''
          BusID "PCI:1:0:0"
          Option "AllowEmptyInitialConfiguration"
        '';
      };
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          libva-vdpau-driver
          libvdpau-va-gl
          nvidia-vaapi-driver
          vulkan-loader
          vulkan-validation-layers
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          libva-vdpau-driver
          libvdpau-va-gl
          vulkan-loader
        ];
      };

      nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement.enable = true;
        prime.offload.enable = false;
      };
    };
  };
}
