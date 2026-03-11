{
  pkgs,
  lib,
  config,
  hostName,
  ...
}: let
  username = config.custom.username;
  dotfilesPath = "/Users/${username}/dotfiles";
in {
  options.custom.username = lib.mkOption {
    type = lib.types.str;
    description = "Primary user of this system";
  };

  config = {
    nix.package = pkgs.lix;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      trusted-users = ["root" username];
    };

    nix.gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 15d";
    };
    nix.optimise.automatic = true;

    nixpkgs.config.allowBroken = true;
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      git
      eza
      bat
      fd
      ripgrep
      fzf
      zoxide
      tree
      wget
      unzip
      p7zip
      ffmpeg-full
    ];

    programs.zsh.enable = true;
    security.sudo.extraConfig = "Defaults pwfeedback";

    system.stateVersion = 5;
  };
}
