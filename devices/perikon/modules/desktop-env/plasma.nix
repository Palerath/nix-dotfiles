{
	services.xserver.enable = true;
	services.xserver.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	services.xserver.desktopManager.plasma6.enable = true;
	services.displayManager.defaultSession = "plasma";
}
