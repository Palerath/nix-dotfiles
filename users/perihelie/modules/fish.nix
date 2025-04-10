{pkgs, lib, config, ...}:
{
	home.packages = with pkgs; [fish];

	options.programs.fish = {
		enable = lib.mkEnableOption "Enable the fish shell";
		package = lib.mkPackageOptions pkgs "fish" { };
		shellInit = lib.mkOption {
			type = lib.types.lines;
			default = "";
			description = "Shell initialization code sourced at startup";
		};
		
		
	};

	config = lib.mkIf config.programs.fish.enable {
		home.packages = [ config.programs.fish.package ];

		xdg.configFile."fish/config.fish".source = pkgs.writeText "fish-config.fish" '' 
			${config.programs.fish.shellInit}
		'';
	};
}
