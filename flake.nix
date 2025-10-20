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

      flake-utils.url = "github:numtide/flake-utils";
   };

   outputs =
      {
      self,
      nixpkgs,
      home-manager,
      nvf,
      hyprland,
      hyprland-plugins,
      nix-colors,
      zen-browser,
      flake-utils,
      ...
      }@inputs:
      let
         lib = nixpkgs.lib;

         # Helper function to create NixOS systems
         mkSystem =
            hostname: system: extraModules:
            lib.nixosSystem {
               inherit system;
               specialArgs = { inherit inputs; };
               modules = [
                  # Core system configuration
                  ./hosts/${hostname}/configuration.nix
                  ./hosts/common

                  # Home Manager as NixOS module
                  home-manager.nixosModules.home-manager
                  {
                     home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = { inherit inputs; };
                     };
                  }
               ]
                  ++ extraModules;
            };
      in
         {
         # NixOS configurations for each machine
         nixosConfigurations = {
            # perikon
            perikon = mkSystem "perikon" "x86_64-linux" [
               {
                  # Home-manager as a module
                  home-manager.users.perihelie = import [
                     ./users/perihelie/home.nix
                  ];
               }
            ];

            # linouce
            #            linouce = mkSystem "linouce" "x86_64-linux" [
            #{
            #      home-manager.users.estelle = import ./users/estelle/home.nix;
            #  }
            #];
            #};

            # Standalone home-manager configurations
            # Useful for updating user configs independently
            #homeConfigurations = {
            #  "perihelie@perikon" = home-manager.lib.homeManagerConfiguration {
            #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
            #     modules = [
            #     ./users/perihelie/home.nix
            #        nvf.homeManagerModules.nvf
            #     ];
            #     extraSpecialArgs = { inherit inputs; };
            #  };

            #  "estelle@linouce" = home-manager.lib.homeManagerConfiguration {
            #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
            #     modules = [
            #     ./users/estelle/home.nix
            #     ];
            #     extraSpecialArgs = { inherit inputs; };
            #  };
         };
      };
}
