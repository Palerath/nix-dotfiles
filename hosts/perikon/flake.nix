{
    description = "NixOS configuration for perikon";

    # This flake is designed to be imported by the main flake
    # It receives inputs, commonModules, and homeModules from parent
    outputs = { inputs, self, commonModules ? {}, homeModules ? {} }:
        let
            system = "x86_64-linux";
            pkgs = import inputs.nixpkgs { inherit system; };
        in
            {
            nixosConfigurations.perikon = inputs.nixpkgs.lib.nixosSystem {
                inherit system;

                specialArgs = { 
                    inherit inputs;
                    hostName = "perikon";
                    inherit homeModules;  # Pass user configs to configuration.nix
                };

                modules = [
                    # Hardware configuration
                    ./hardware-configuration.nix

                    # Host-specific configuration
                    ./configuration.nix

                    # Home-manager
                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                    }

                    # Optional: import common modules from main flake
                    # commonModules.common
                    # commonModules.common-packages
                ];
            };
        };
}
