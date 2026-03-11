{
  description = "Multi-host NixOS configuration";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hyprland.url = "github:hyprwm/Hyprland";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    home-manager,
    home-manager-stable,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];

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
              inputs.sops-nix.nixosModules.sops
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

lib.mkDarwinHost = {
  hostName,
  system ? "aarch64-darwin",
}: let
  pkgs-stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  specialArgs = {
    inherit inputs hostName self pkgs-stable;
    userConfigs = self.userConfigs;
  };
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules = [
      home-manager.darwinModules.home-manager
      { _module.args = {inherit inputs;}; home-manager.extraSpecialArgs = specialArgs; }
      (self + /hosts/${hostName}/configuration.nix)
      (self + /common/darwin.nix)
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

        darwinConfigurations = {
          airhelie = self.lib.mkDarwinHost {hostName = "airhelie";};
        };
      };

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nh
            nixos-rebuild
            alejandra
            nil

            rustup
            pkg-config
            openssl

            python3
            uv

            just
            jq
            curl
            httpie
          ];
          shellHook = ''
            echo "Dev environment loaded"
            export NIXPKGS_ALLOW_UNFREE=1
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"

            # Rust: use rustup-managed toolchains in project-local dir
            export RUSTUP_HOME="$PWD/.rustup"
            export CARGO_HOME="$PWD/.cargo"
            export PATH="$CARGO_HOME/bin:$PATH"
          '';
        };
      };
    };
}
