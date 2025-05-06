{
   description = "A very basic flake";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

      home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      # darwin = {
      # url = "github:nix-darwin/nix-darwin/master";
      # inputs.nixpkgs.follows = "nixpkgs";
      # };

      nvf = {
         url = "github:notashelf/nvf";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprland.url = "github:hyprwm/Hyprland";
      hyprland-plugins = {
         url = "github:hyprwm/hyprland-plugins";
         inputs.hyprland.follows = "hyprland";   
      };
   };
   outputs = { self, nixpkgs, home-manager, nvf, hyprland, hyprland-plugins,  ... }@inputs:
      let 
         lib = nixpkgs.lib;
         pkgs = nixpkgs.legacyPackages."x86_64-linux";
      in
         {

         nixosConfigurations = {
            perikon = lib.nixosSystem {
               system = "x86_64-linux";
               modules = [ 
                  ./perikon/configuration.nix
                  # home-manager.nixosModules.home-manager {
                  # 	home-manager.useGlobalPkgs = true;
                  # 	home-manager.useUserPackages =true;
                  # 	home-manager.users.perihelie = ./users/perihelie/home.nix;
                  # home-manager.extraSpecialArgs = [];
                  # }

               ];
               specialArgs = {inherit inputs;};
            };
         };

         # darwinConfigurations = {
         # "perihelie@air" = darwin.lib.darwinSystem {
         # modules = [ 
         # ./devices/macbook-air/darwin-configuration.nix 
         # home-manager.darwinModules.home-manager {
         # home-manager.useGlobalPkgs = true;
         # home-manager.useUserPackages = true;
         # home-manager.users.perihelie = ./users/perihelie/home.nix;

         # home-manager.extraSpecialArgs = [];
         # }
         # ];
         # };
         # };

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
