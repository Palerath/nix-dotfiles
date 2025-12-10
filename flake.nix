{
    description = "Multi-host NixOS configuration";

    inputs = {
        self.submodules = true;
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

        nvf = {
            url = "github:notashelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        hyprland.url = "github:hyprwm/Hyprland";

        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
    };

    outputs = inputs @ { self, flake-parts, nixpkgs, home-manager, determinate, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            systems = [ "x86_64-linux" ];

            flake = {
                # User configurations
                userConfigs = {
                    perihelie = import (self + /users/perihelie/home.nix);
                };

                # Helper function to create host configurations
                lib.mkHost = { hostName, system ? "x86_64-linux" }: 
                    nixpkgs.lib.nixosSystem {
                        inherit system;
                        specialArgs = {
                            inherit inputs;
                            inherit hostName;
                            userConfigs = self.userConfigs;
                        };
                        modules = [
                            home-manager.nixosModules.home-manager
                            {
                                _module.args = { inherit inputs; };
                                home-manager.extraSpecialArgs = { inherit inputs hostName; };
                            }
                            (self + /hosts/${hostName}/hardware-configuration.nix)
                            (self + /hosts/${hostName}/configuration.nix)
                            # Optionally add common modules
                            self.nixosModules.common
                            determinate.nixosModules.default
                        ];
                    };

                # Define each host using the helper
                nixosConfigurations = {
                    perikon = self.lib.mkHost { hostName = "perikon"; };
                    latitude = self.lib.mkHost { hostName = "latitude"; };
                };

                # Common modules
                nixosModules = {
                    common = import (self + /common);
                };
            };

            perSystem = { pkgs, ... }: {
                devShells = {
                    default = pkgs.mkShell {
                        buildInputs = with pkgs; [
                            git
                            nh
                            nixos-rebuild
                        ];

                        shellHook = ''
                            echo "NixOS development environment loaded"
                            echo "Tools: nh, nixos-rebuild, git"
                        '';
                    };
                };
            };
        };
}
