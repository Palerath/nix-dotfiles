{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations.perihelie = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.homeModules.perihelieConfiguration
    ];
  };
}
