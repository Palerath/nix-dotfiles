{pkgs, ...}:
{
	boot.loader.systemd-boot.enable = false;
	boot.loader.timeout = 20;
	boot.loader.efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/boot";
	};
	boot.loader.grub = {
		enable = true;
		devices = [ "nodev" ];
		efiSupport = true;
		useOSProber = false;
		configurationLimit = 2000;
	};

	environment.systemPackages = [ pkgs.os-prober ];
}
