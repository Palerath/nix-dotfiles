{
  description = "Multi-host NixOS configuration";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    home-manager-stable,
    determinate,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      flake = {
        # User configurations
        userConfigs = {
          perihelie = import (self + /users/perihelie/home.nix);
          estelle = import (self + /users/estelle/home.nix);
          miyuyu = import (self + /users/miyuyu/home.nix);
        };

        lib.mkHost = {
          hostName,
          system ? "x86_64-linux",
          useStable ? false,
        }: let
          # Always import both stable and unstable
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs-unstable = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          # Choose which one to use as the main pkgs
          basePkgs =
            if useStable
            then nixpkgs-stable
            else nixpkgs;
          hmInput =
            if useStable
            then home-manager-stable
            else home-manager;
        in
          basePkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs;
              inherit hostName;
              inherit pkgs-stable;
              inherit pkgs-unstable;
              userConfigs = self.userConfigs;
            };
            modules = [
              hmInput.nixosModules.home-manager
              {
                _module.args = {inherit inputs;};
                home-manager.extraSpecialArgs = {inherit inputs hostName self;};
              }
              (self + /hosts/${hostName}/hardware-configuration.nix)
              (self + /hosts/${hostName}/configuration.nix)

              # Common modules
              (self + /common)
              determinate.nixosModules.default
            ];
          };

        nixosConfigurations = {
          perikon = self.lib.mkHost {hostName = "perikon";};
          latitude = self.lib.mkHost {hostName = "latitude";};
          linouce = self.lib.mkHost {
            hostName = "linouce";
            useStable = true;
          };
          periserver = self.lib.mkHost {
            hostName = "periserver";
            useStable = true;
          };
        };
      };

      perSystem = {pkgs, ...}: {
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
