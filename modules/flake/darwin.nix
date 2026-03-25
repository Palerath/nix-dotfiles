{ inputs, self, ... }:

let
  mkDarwinHost =
    { hostName, system ? "aarch64-darwin" }:
    let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs hostName self pkgs-stable;
        userConfigs = self.userConfigs;
      };
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          _module.args.inputs           = inputs;
          home-manager.extraSpecialArgs = specialArgs;
        }
        (self + /modules/hosts/${hostName}/configuration.nix)
        (self + /modules/common/darwin.nix)
      ];
    };

in
{
  flake.darwinConfigurations.airhelie =
    mkDarwinHost { hostName = "airhelie"; };
}
