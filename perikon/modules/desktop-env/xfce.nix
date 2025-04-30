{config, pkgs, ...}: 
{
	services.xserver.desktopManager.xfce.enable = true;

	environment.systemPackages = with pkgs; [
		xfce4-terminal
		thunar
		xfce4-power-manager
	];
}
