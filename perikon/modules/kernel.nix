{pkgs, ...}:
{
   boot = {
      kernelPackages = pkgs.linuxPackages_zen;

      # Enable early KMS for better graphics performance
      kernelParams = [ 
         "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Helps with suspend/resume
         "nvidia-drm.modeset=1"  # Required for some Wayland compositors
      ];

      blacklistedKernelModules = [ "nouveau" ];
   };
}
