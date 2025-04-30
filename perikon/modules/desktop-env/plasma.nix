{config, pkgs, ...}:
{
	services.desktopManager.plasma6.enable = true;
	
	environmnent.systemPackages = with pkgs; [
		plasma-workspace
		konsole
		plasma-systemmonitor
		kate
		dolphin
	];

	environment.sessionVariables = {
		NIXOS_OZONE_NL = "1";
		QT_QPA_PLATFORM = "wayland";
		GDK_BACKEND = "wayland";
	};
}
