{self, ...}: {
  flake = {
    nixosConfigurations = {
      perikon = self.lib.mkHost {hostName = "perikon";};
      latitude = self.lib.mkHost {
        hostName = "latitude";
        useStable = true;
      };
      linouce = self.lib.mkHost {
        hostName = "linouce";
        useStable = true;
      };
      periserver = self.lib.mkHost {
        hostName = "periserver";
        useStable = true;
      };
    };

    darwinConfigurations = {
      airhelie = self.lib.mkDarwinHost {hostName = "airhelie";};
    };
  };
}
