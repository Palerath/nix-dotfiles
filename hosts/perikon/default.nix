{ inputs, self }:

let
    system = "x86_64-linux";
    hostname = "perikon";

    # Get pkgs with overlays
    pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
    };

in inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { 
            inherit inputs self hostname;
        };

        modules = [
            ./configuration.nix

            # Import common modules from main flake
            self.nixosModules.common
            self.nixosModules.hardware

            # Home Manager
            inputs.home-manager.nixosModules.home-manager
            {
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = { inherit inputs; };

                    # Import user configurations from main repo or local overrides
                    users = import ./users.nix { inherit self pkgs; };
                };
            }

            # Set hostname
            { networking.hostName = hostname; }
        ];
    }
