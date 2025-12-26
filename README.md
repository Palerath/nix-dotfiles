# Setup a new host / user
## Host files
### Configuration.nix

``` nix
{pkgs, lib, hostName, ...}:
{
    imports = [
        ./USERNAME.nix
        ./hardware-configuration.nix
    ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true; 

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    environment.sessionVariables = {
        NH_FLAKE = lib.mkDefault "/home/USERNAME/dotfiles";
    };

    programs.nh = {
        enable = true;
        flake = "/home/USERNAME/dotfiles";
    };
    networking = {
        hostName = hostName;
    };
}
```
### USERNAME.nix

``` nix
{ userConfigs, pkgs, inputs, ... }:
{

    environment.systemPackages = [ pkgs.home-manager ];

    users.users.USERNAME = {
        isNormalUser = true;
        description = "perihelie";
        shell = pkgs.fish;
        ignoreShellProgramCheck = true;
        extraGroups = [
            "networkmanager"
            "wheel"
            "video"
            "audio"
            "input"
        ];
    };


    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };  

        users.USERNAME = {
            imports = [
                userConfigs.USERNAME
                ./overrides/default.nix
            ];
        };
    };    
}

```
## home.nix

``` nix
{ config, pkgs, inputs, ... }:
{
    home.username = "USERNAME";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "24.05";

    programs.git = {
        enable = true;
        settings.user = {
            name = "name to use for git identification";
            email = "email@adress.xyz";
        };
    };

    programs.home-manager.enable = true;
```

## flake.nix
add these values to flake.nix:
``` nix
...};

outputs = inputs@{...}:flake-parts. ...{
    ...
flake = {
    userConfigs = {
        ...
        USERNAME = import (self + /users/USERNAME/home.nix);
    };

    lib.mkHost = {...};

        nixosConfigurations = {
        ...
            HOSTNAME = self.lib.mkHost { 
                hostName = "HOSTNAME";
                useStable = false;
            }
        };
    };
}
```

## Git process
- Seperate the host / user from the dotfiles and setup new private repo on github
- In the dotfiles, clone the new repo at its place and `git submodule add <ssh url> <path/to/new_submodule>` and then kumit the changes.


# Setup host / user
After install of nixos: `nix-shell -p git vim --experimental-features 'nix-command flakes'` then `git clone git@github.com:Palerath/nix-dotfiles.git <path/to/dotfiles>` 
To import a submodule, use `git submodule update --init <path/to/submodule>` then inside the imported submodule `git checkout <branch>`
