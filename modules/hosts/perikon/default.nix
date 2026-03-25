{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.perikon = self.lib.mkHost {
    hostName = "perikon";
    hostModule = self.nixosModules.perikonConfiguration;
  };

  # flake.nixosConfigurations.perikon = inputs.nixpkgs.lib.nixosSystem {
  #   specialArgs = {
  #     inherit (inputs) hyprland aagl zen-browser;
  #     inherit self;
  #   };
  #   modules = [
  #     self.nixosModules.perikonConfiguration
  #   ];
  # };
}
