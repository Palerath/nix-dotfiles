{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.perikon = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit (inputs) hyprland aagl zen-browser;
      inherit self;
    };
    modules = [
      self.nixosModules.common
      self.nixosModules.perikonConfiguration
      self.nixosModules.perihelieConfiguration
      self.nixosModules.sops
      self.nixosModules.hyprland
    ];
  };
}
