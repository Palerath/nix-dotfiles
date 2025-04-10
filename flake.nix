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
	homeConfigurations = {
		perihelie = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [ ./users/perihelie/home.nix ];
		};
	};

  };
}
