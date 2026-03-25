{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.perikon = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.perikonConfiguration
      self.nixosModules.perihelieConfiguration
      self.nixosModules.sops
      self.nixosModules.hyprland
    ];
  };
}
