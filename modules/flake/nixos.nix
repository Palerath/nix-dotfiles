{ inputs, self, lib, ... }:

let
  mkHost =
    { hostName
    , system    ? "x86_64-linux"
    , useStable ? false
    }:
    let
      basePkgs  = if useStable then inputs.nixpkgs-stable else inputs.nixpkgs;
      hmInput   = if useStable then inputs.home-manager-stable else inputs.home-manager;
      extraPkgs = lib.optionalAttrs (!useStable) {
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      specialArgs = {
        inherit inputs hostName self;
        userConfigs = self.userConfigs;
      } // extraPkgs;
    in
    basePkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs;
      modules = [
        inputs.sops-nix.nixosModules.sops
        hmInput.nixosModules.home-manager
        {
          _module.args.inputs           = inputs;
          home-manager.extraSpecialArgs = specialArgs;
        }
        (self + /modules/hosts/${hostName}/hardware-configuration.nix)
        (self + /modules/hosts/${hostName}/configuration.nix)
        (self + /modules/common/nixos.nix)
      ];
    };

in
{
  flake = {
    # Consumed by host perihelie.nix / a-perihelie.nix via specialArgs.
    userConfigs = {
      perihelie = import (self + /modules/users/perihelie/home.nix);
      estelle   = import (self + /modules/users/estelle/home.nix);
      miyuyu    = import (self + /modules/users/miyuyu/home.nix);
    };

    nixosConfigurations = {
      perikon    = mkHost { hostName = "perikon"; };
      latitude   = mkHost { hostName = "latitude"; };
      linouce    = mkHost { hostName = "linouce";    useStable = true; };
      periserver = mkHost { hostName = "periserver"; useStable = true; };
    };
  };
}
