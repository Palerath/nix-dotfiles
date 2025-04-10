{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: 
	let 
		lib = nixpkgs.lib;
	in
	{
	nixosConfigurations = {
		perikon = lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ ./configuration.nix];
		};
	};
	homeConfigurations = {
		"perihelie@perikon" = home-manager.lib.homeManagerConfiguration {
			system = nixpkgs.legacyPackages."x86_64-linux";
			username = "perihelie";
			homeDirectory = "/home/perihelie";
			configuration.imports = [ ./home.nix ];
		};
		"perihelie@air" = home-manager.lib.homeManagerConfiguration {
			system = nixpkgs.legacyPackages."aarch64-darwin";
			username = "perihelie";
			homeDirectory = "Users/perihelie";
			configuration.imports = [ ./home.nix ];
		};
	};

  };
}
