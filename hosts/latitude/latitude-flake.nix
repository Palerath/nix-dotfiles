{inputs, ...}:
{
    flake = {
        nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./latitude-configuration.nix ];
        };
    };
}
