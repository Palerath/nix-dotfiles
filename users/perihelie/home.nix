{ config, pkgs, ... }:

{
# Home Manager needs a bit of information about you and the paths it should
# manage.
	home.username = "perihelie";
	home.homeDirectory = "/home/perihelie";

	home.stateVersion = "24.11"; # Please read the comment before changing.

		home.packages = with pkgs; [
			neovim
			git
			nerd-fonts.iosevka
		];


	home.file.".confuig/nvim/init.vim".text = '' 
		set number
		set relativenumber
		syntax on
		'';

	programs.git = {
		enable = true;
		userName = "perihelie";
		userEmail = "archibaldmk4@gmail.com";		

	};

	home.sessionVariables = {
		EDITOR = "neovim";
	};

	imports = [
		./modules/zsh.nix
	];

	fonts.fontconfig.enable = true;


# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
