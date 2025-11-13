{
    description = "Multi-host NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";

        # Optional: shared inputs
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
                # User configurations (as submodules in users/)
                # Each user has their own private repo
                userConfigs = {
                    perihelie = import ./users/perihelie/home.nix;
                    # userB = import ./users/userB/home.nix;
                };

                # Import each host's flake
                nixosConfigurations =
                    let
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
                                        userConfigs = self.userConfigs;
                                    };
                                in hostOutputs.nixosConfigurations or {}
                            else 
                                builtins.trace "Warning: Host ${name} not found" {};

                        hosts = [ "perikon" "latitude" ];

                        allConfigs = builtins.foldl'
                            (acc: host: acc // (importHost host))
                            {}
                            hosts;
                    in allConfigs;

                # Common modules available to all hosts
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
