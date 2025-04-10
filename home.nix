{config, pkgs, ...}:
{
	home.username = "perihelie";
	home.homeDirectory = if pkgs.stdenv.isDarwin then "Users/perihelie" else "home/perihelie";
	home.stateVersion = "24.11";
	
	home.packages = with pkgs; [
		git
		fish
		alacritty
		neovim
	];
	
	programs.git = {
		enable = true;
		userName = "perihelie";
		userEmail = "archibaldmk4@gmail.com";
	};
	
	home.file.".config/nvim/init.vim".text = '' 
		set number
		set relativenumber
		syntax on
	'';
		
}
