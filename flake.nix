{
    description = "Multi-host NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";

        # Optional: shared inputs for all hosts
        nvf = {
            url = "github:notashelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland = {
            url = "github:hyprwm/Hyprland";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
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
                # Import each host's flake and merge their nixosConfigurations
                nixosConfigurations =
                    let
                        # Helper to import host if it exists
                        importHost = name:
                            let 
                                hostPath = ./hosts/${name};
                                flakePath = hostPath + "/flake.nix";
                            in if builtins.pathExists flakePath
                                then 
                                let
                                    hostFlake = import flakePath;
                                    hostOutputs = hostFlake.outputs {
                                        inherit inputs self;
                                        commonModules = self.nixosModules;
                                        homeModules = self.homeModules;
                                    };
                                in hostOutputs.nixosConfigurations or {}
                            else 
                                builtins.trace "Warning: Host ${name} not found at ${toString hostPath}" {};

                        # List your hosts here
                        hosts = [ "perikon" ];

                        # Merge all host configurations
                        allConfigs = builtins.foldl'
                            (acc: host: acc // (importHost host))
                            {}
                            hosts;
                    in allConfigs;

                # Common modules available to all hosts
                nixosModules = {
                    common = import ./common;
                    common-packages = import ./common/packages.nix;
                };

                # Shared user configurations
                homeModules = {
                    perihelie = import ./common/users/perihelie.nix;
                    # anotheruser = import ./common/users/anotheruser.nix;
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
