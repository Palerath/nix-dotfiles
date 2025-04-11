{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
	url = "github:nix-darwin/nix-darwin/master";
	inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin }: 
	let 
		lib = nixpkgs.lib;
		pkgs = nixpkgs.legacyPackages."x86_64-linux";
	in
	{
	nixosConfigurations = {
		perikon = lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ 
				./devices/perikon/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages =true;
					home-manager.users.perihelie = ./users/perihelie/home.nix;

					# home-manager.extraSpecialArgs = [];
				}
			];
		};
	};

	darwinConfigurations = {
		"perihelie@air" = nix-darwin.lib.darwinSystem {
			modules = [ ./devices/macbook-air/darwin-configuration.nix ];
		};
	};

 	homeConfigurations = {
 		"perihelie@air" = home-manager.lib.homeManagerConfiguration {
 			system = nixpkgs.legacyPackages."aarch64-darwin";
 			modules = [ ./users/perihelie/home.nix ];
 		};
 	};

  };
}
