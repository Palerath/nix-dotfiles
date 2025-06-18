{ pkgs, config, ... }:
{
   hardware = {
      # OpenGL/Graphics support (24.05+ uses hardware.graphics)
      graphics = {
         enable = true;
         enable32Bit = true;  # Required for 32-bit games

         # Additional packages for gaming
         extraPackages = with pkgs; [
            vaapiVdpau
            libvdpau-va-gl
            nvidia-vaapi-driver
         ];

         extraPackages32 = with pkgs.pkgsi686Linux; [
            vaapiVdpau
            libvdpau-va-gl
         ];
      };

      nvidia = {
         package = config.boot.kernelPackages.nvidiaPackages.stable;
         modesetting.enable = true;

         # Enable NVIDIA settings menu
         nvidiaSettings = true;

         # Power management (experimental)
         powerManagement.enable = true;
         powerManagement.finegrained = false;

         # Open source kernel module (experimental)
         open = true;
      };

   };

   services.xserver = {
         enable = true;
         videoDrivers = [ "nvidia" ];
      };

   boot = {
      kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # For suspend/resume
      "nvidia_drm.fbdev=1"
      ];

      kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      ];
   };

   environment.sessionVariables = {
    # NVIDIA Wayland support
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";

  };

}
