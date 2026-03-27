{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.perikon = self.lib.mkHost {
    hostName = "perikon";
    hostModule = self.nixosModules.perikonConfiguration;
  };
}
