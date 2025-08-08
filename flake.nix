{
   description = "A very basic flake";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

      home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      nvf = {
         url = "github:notashelf/nvf";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprland.url = "github:hyprwm/Hyprland";
      hyprland-plugins = {
         url = "github:hyprwm/hyprland-plugins";
         inputs.hyprland.follows = "hyprland";   
      };

      nix-colors.url = "github:misterio77/nix-colors";

      zen-browser = {
         url = "github:0xc000022070/zen-browser-flake";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      rust-overlay = {
         url = "github:oxalica/rust-overlay";
         inputs.nixpkgs.follows = "nixpkgs";
      };

   };

   outputs = { self, nixpkgs, home-manager, nvf, hyprland, hyprland-plugins, nix-colors, zen-browser, rust-overlay, ... }@inputs:
      let 
         lib = nixpkgs.lib;
      in
         {
         nixosConfigurations = {
            # PERIKON
            perikon = lib.nixosSystem {
               system = "x86_64-linux";
               specialArgs = {inherit inputs;};
               modules = [ 
                  ./hosts/perikon/configuration.nix

                  ({ pkgs, ... }: {
                     nixpkgs.overlays = [ rust-overlay.overlays.default ];
                     environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
                  })
               ];        
            };

            # LINOUCE
            linouce = lib.nixosSystem {
               system = "x86_64-linux";
               specialArgs = {inherit inputs;};
               modules = [
                  ./hosts/linouce/configuration.nix
                  home-manager.nixosModules.home-manager
                  {
                     home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.estelle = import ./users/estelle/home.nix;
                        extraSpecialArgs = { inherit inputs; };
                     };
                  }
               ];
            };
         };

         # Perihelie
         homeConfigurations = {
            "perihelie" = home-manager.lib.homeManagerConfiguration {
               pkgs = nixpkgs.legacyPackages."x86_64-linux";
               modules = [ 
                  ./users/perihelie/home.nix
                  nvf.homeManagerModules.nvf
               ];
               extraSpecialArgs = {inherit inputs;};
            };

         };
      };

}
