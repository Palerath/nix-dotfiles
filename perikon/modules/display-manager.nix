{config, pkgs, ...}:
{
	services.xserver = {
		enable = true;
		displayManager.sddm.enable = true;
		displayManager.gdm.enable = false;

		displayManager.defaultSession = "plasma";
	};
}
