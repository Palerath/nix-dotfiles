{pkgs, ...}:
{
   # Enable graphics support
   hardware.graphics = {
      enable = true;
      enable32Bit = true;
   };

   hardware.opengl = {
      enable = true;
      extraPackages = with pkgs;[
         mesa
         vulkan-loader
      ];
   };

   # Specify the NVIDIA driver
   services.xserver.videoDrivers = [ "nvidia" ];

   hardware.nvidia = {
      open = true;
      videoAcceleration = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting = {
         enable = true;
      };

      nvidiaSettings = true;
   };
}
