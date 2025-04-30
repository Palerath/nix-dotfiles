{config, pkgs, ...}:
{
	services.displayManager = {
		sddm = {
			enable = true;
			wayland = {
				enable = true;
			};
		};

		defaultSession = "plasma";
	};

	services.desktopManager.plasma6 = {
		enable = true;
		enableQt5Integration = false;
	};

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
	};

	environment.sessionVariables = {
		NIXOS_OZONE_NL = "1";
		QT_QPA_PLATFORM = "wayland";
		GDK_BACKEND = "wayland";
	};
}
