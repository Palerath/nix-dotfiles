{
    description = "Multi-host NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";

        nvf = {
            url = "github:notashelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs @ { self, flake-parts, nixpkgs, home-manager, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            systems = [ "x86_64-linux" ];

            flake = {
                # User configurations
                userConfigs = {
                    perihelie = import ./users/perihelie/home.nix;
                };

                # Define each host directly in main flake
                nixosConfigurations = {

                    # Perikon host
                    perikon = nixpkgs.lib.nixosSystem {
                        system = "x86_64-linux";
                        specialArgs = {
                            inherit inputs;
                            hostName = "perikon";
                            userConfigs = self.userConfigs;
                        };
                        modules = [
                            home-manager.nixosModules.home-manager
                            { _module.args = { inherit inputs; }; }
                            ./hosts/perikon/hardware-configuration.nix
                            ./hosts/perikon/configuration.nix
                        ];
                    };

                    # Latitude host
                    latitude = nixpkgs.lib.nixosSystem {
                        system = "x86_64-linux";
                        specialArgs = {
                            inherit inputs;
                            hostName = "latitude";
                            userConfigs = self.userConfigs;
                        };
                        modules = [
                            home-manager.nixosModules.home-manager
                            { _module.args = { inherit inputs; }; }
                            ./hosts/latitude/hardware-configuration.nix
                            ./hosts/latitude/configuration.nix
                        ];
                    };

                };

                # Common modules
                nixosModules = {
                    common = import ./common;
                };
            };

            perSystem = { pkgs, ... }: {
                devShells.default = pkgs.mkShell {
                    buildInputs = with pkgs; [
                        git
                        nh
                        nixos-rebuild
                    ];
                };
            };
        };
}
