{
  inputs,
  self,
  ...
}: let
  mkHost = {
    hostName,
    system ? "x86_64-linux",
    useStable ? false,
  }: let
    pkgsSrc =
      if useStable
      then inputs.nixpkgs-stable
      else inputs.nixpkgs;
    hmSrc =
      if useStable
      then inputs.home-manager-stable
      else inputs.home-manager;

    extraArgs = inputs.nixpkgs.lib.optionalAttrs (!useStable) {
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    specialArgs =
      {
        inherit inputs hostName self;
        userConfigs = self.userConfigs;
      }
      // extraArgs;
  in
    pkgsSrc.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs;
      modules = [
        inputs.sops-nix.nixosModules.sops
        hmSrc.nixosModules.home-manager
        {
          _module.args = {inherit inputs;};
          home-manager.extraSpecialArgs = specialArgs;
        }
        (self + /modules/hosts/${hostName}/hardware-configuration.nix)
        (self + /modules/hosts/${hostName}/configuration.nix)
        (self + /modules/common)
      ];
    };
in {
  flake = {
    userConfigs = {
      perihelie = import (self + /modules/users/perihelie/home.nix);
      estelle = import (self + /modules/users/estelle/home.nix);
      miyuyu = import (self + /modules/users/miyuyu/home.nix);
    };

    nixosConfigurations = {
      perikon = mkHost {hostName = "perikon";};
      latitude = mkHost {hostName = "latitude";};
      linouce = mkHost {
        hostName = "linouce";
        useStable = true;
      };
      periserver = mkHost {
        hostName = "periserver";
        useStable = true;
      };
    };
  };

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [git nh nixos-rebuild];
      shellHook = ''
        export NIXPKGS_ALLOW_UNFREE=1
      '';
    };
  };
}
