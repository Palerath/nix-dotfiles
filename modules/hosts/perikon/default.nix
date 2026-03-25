{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.perikon = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.perikonConfiguration
    ];
  };
}
