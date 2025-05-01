{config, pkgs, ...}:
{
	boot.loader.systemd-boot.enable = false;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.grub = {
		enable = true;
		devices = [ "nodev" ];
		efiSupport = true;
		useOSProber = true;
		configurationLimit = 2000;
	};

}
