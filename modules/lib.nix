{
  self,
  inputs,
  ...
}: {
  flake.lib = {
    mkHost = {
      hostName,
      system ? "x86_64-linux",
      useStable ? false,
    }: let
      pkgsChan =
        if useStable
        then inputs.nixpkgs-stable
        else inputs.nixpkgs;
    in
      pkgsChan.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs hostName;};
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          self.nixosModules.common
          # Host specific hardware and config
          (self + "/hosts/${hostName}/hardware-configuration.nix")
          (self + "/hosts/${hostName}/configuration.nix")
        ];
      };

    mkDarwinHost = {
      hostName,
      system ? "aarch64-darwin",
    }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit self inputs hostName;};
        modules = [
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
          self.nixosModules.common
          (self + "/hosts/${hostName}/configuration.nix")
        ];
      };
  };
}
