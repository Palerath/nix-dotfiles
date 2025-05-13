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
   };
   outputs = { self, nixpkgs, home-manager, nvf, hyprland, hyprland-plugins, nix-colors, ... }@inputs:
      let 
         lib = nixpkgs.lib;
         pkgs = nixpkgs.legacyPackages."x86_64-linux";
      in
         {

         nixosConfigurations = {
            perikon = lib.nixosSystem {
               system = "x86_64-linux";
               modules = [ 
                  ./perikon/configuration.nixnixpkgs

                  home-manager.nixosModules.home-manager {
                     home-manager.useGlobalPkgs = true;
                     home-manager.useUserPackages =true;
                     home-manager.users."perihelie" = ./users/perihelie/home.nix;
                  }

                  nvf.homeManagerModules.nvf
               ];
               specialArgs = {inherit inputs;};
            };
         };

         #homeConfigurations = {
         #  "perihelie" = home-manager.lib.homeManagerConfiguration {
         #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
         #     modules = [ 
         #     ./users/perihelie/home.nix 
         #        nvf.homeManagerModules.nvf
         #     ];
         #     extraSpecialArgs = {inherit inputs;};
         #  };
         #  };

      };

}
