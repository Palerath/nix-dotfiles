{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
	nixosConfigurations = {
		perikon = lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ ./configuration.nix];
		};
	};
	homeConfigurations = {
		"perihelie@perikon" = home-manager.lib.homeManagerConfiguration {
			system = "x86_64-linux";
			username = "perihelie";
			homeDirectory = "/home/perihelie";
			configuration.imports = [ ./home.nix ];
		};
		"perihelie@air" = home-manager.lib.homeManagerConfiguration {
			system = "'aarch64-darwin";
			username = "perihelie";
			homeDirectory = "Users/perihelie";
			configuration.imports = [ ./home.nix ];
		};
	};

  };
}
