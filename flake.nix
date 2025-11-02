{
    description = "Multi-hosts and users main flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";

        # ======================================================================
        
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

        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.nixpkgs.follows = "nixpkgs";
        };


    };

    outputs =
        inputs @ {self, flake-parts, ... }: 
        flake-parts.lib.mkFlake { inherit inputs; } 
        {

            systems = [ "x86_64-linux" "aarch64-darwin"];

            nixosModules = {
                commons = import ./commons;
                hardware = import ./commons/hardware;
            };

            nixosConfigurations = {
                perikon = import ./hosts/perikon { inherit inputs self; };
                latitude = import ./hosts/latitude { inherit inputs self; };
            };

            homeModules = {
                perihelie = import ./users/perihelie;
            };

            perSystem = { config, self', inputs', pkgs, system, ... }: {
                devShells.default = pkgs.mkShell {
                    buildInputs = with pkgs; [
                        git
                        nixos-rebuild
                        home-manager
                    ];

                };
            };

        };
}
