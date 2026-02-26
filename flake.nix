{
  description = "Multi-host NixOS configuration";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-virtual-desktops = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    home-manager-stable,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      flake = {
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
          basePkgs =
            if useStable
            then nixpkgs-stable
            else nixpkgs;
          hmInput =
            if useStable
            then home-manager-stable
            else home-manager;

          mkPkgs = chan:
            import chan {
              inherit system;
              config.allowUnfree = true;
            };

          extraPkgs = nixpkgs.lib.optionalAttrs (!useStable) {
            pkgs-stable = mkPkgs nixpkgs-stable;
          };

          specialArgs =
            {
              inherit inputs hostName self;
              userConfigs = self.userConfigs;
            }
            // extraPkgs;
        in
          basePkgs.lib.nixosSystem {
            inherit system;
            specialArgs = specialArgs;
            modules = [
              hmInput.nixosModules.home-manager
              {
                _module.args = {inherit inputs;};
                home-manager.extraSpecialArgs = specialArgs;
              }
              (self + /hosts/${hostName}/hardware-configuration.nix)
              (self + /hosts/${hostName}/configuration.nix)
              (self + /common)
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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [git nh nixos-rebuild];
          shellHook = ''
            echo "NixOS development environment loaded"
            echo "Tools: nh, nixos-rebuild, git"
          '';
        };
      };
    };
}
