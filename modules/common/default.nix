{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.common = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.commonVim
      self.nixosModules.commonAliases
      self.nixosModules.commonOptions
      self.nixosModules.cachix
    ];

    environment.systemPackages = with pkgs;
      [
        libinput
        uutils-coreutils-noprefix
        findutils
        ffmpeg-full
        tree
        wget
        ripgrep
        fd
        bat
        eza
        zoxide
        fzf
        file
        toybox
        net-tools
        dust
        dua

        nix-tree
        nix-diff
        statix
        deadnix

        rar
        unrar
        unzip
        p7zip
        zip
        xz
      ]
      ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        wl-clipboard
      ];

    programs = {
      dconf.enable = true;
      direnv.enable = true;
    };

    security.sudo.wheelNeedsPassword = true;
    security.sudo.extraConfig = "Defaults pwfeedback";

    system.autoUpgrade.enable = true;

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    nix.optimise.automatic = true;

    nixpkgs.config.allowBroken = true;
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root"];
      auto-optimise-store = false;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  flake.nixosModules.commonOptions = {lib, ...}: {
    options.my.primaryUser = lib.mkOption {
      type = lib.types.str;
      default = "root";
    };
  };
}
