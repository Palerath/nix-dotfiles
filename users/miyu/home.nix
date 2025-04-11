{config, pkgs, ...}:
{
	home.username = "miyu";
	home.homeDirectory = "/home/miyu"

	home.stateVersion = "24.11";

	home.packages = with pkgs; [
		git
	];
}
