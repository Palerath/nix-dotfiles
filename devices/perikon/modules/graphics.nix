{
  # Enable graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Specify the NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;

    # Enable modesetting
    modesetting = {
      enable = true;
    };

    # Enable the NVIDIA settings tool
    nvidiaSettings = true;
  };
}
