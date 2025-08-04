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

   };

   outputs = { self, nixpkgs, home-manager, nvf, hyprland, hyprland-plugins, nix-colors, zen-browser, ... }@inputs:
      let 
         lib = nixpkgs.lib;
      in
         {
         # PERIKON
         nixosConfigurations = {
            perikon = lib.nixosSystem {
               system = "x86_64-linux";
               specialArgs = {inherit inputs;};
               modules = [ 
                  /etc/nixos-dotfiles/hosts/perikon/configuration.nix
               ];        
            };

            homeConfigurations = {
               "perihelie" = home-manager.lib.homeManagerConfiguration {
                  pkgs = nixpkgs.legacyPackages."x86_64-linux";
                  modules = [ 
                     /etc/nixos-dotfiles/users/perihelie/home.nix
                     nvf.homeManagerModules.nvf
                  ];
                  extraSpecialArgs = {inherit inputs;};
               };

            };


            # LINOUCE
            linouce = lib.nixosSystem {
               system = "x86_64-linux";
               specialArgs = {inherit inputs;};
               modules = [
                  /etc/nixos-dotfiles/hosts/linouce/configuration.nix
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
      };

}
