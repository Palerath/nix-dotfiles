{config, pkgs, ...}:
{
	boot.loader.systemd-boot.enable = false;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.grub = {
		enable = true;
		devices = [ "nodev" ];
		efiSupport = true;
		useOsProber = true;
		configurationLimit = 200;
	};

	system.nixos.label = "Sable $(date +%Y-%m-%d)";
}
