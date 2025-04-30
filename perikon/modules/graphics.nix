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
    # Enable modesetting
    modesetting = {
      enable = true;
    };

    # Enable the NVIDIA settings tool
    nvidiaSettings = true;
  };
}
