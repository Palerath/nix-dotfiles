{config, pkgs, ...}:

{
	imports = [
		../../common/darwin_commmon.nix
	];

	nix.settings.experimental-features = [ "nix-command" "flakes"];
	nixpkgs.config.allowUnfree = true;
	
	environment.systemPackages = with pkgs; [
		home-manager
	];

	networking.hostName = "air";


}
