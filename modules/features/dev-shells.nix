{
  self,
  inputs,
  ...
}: {
  flake.perSystem = {
    pkgs,
    lib,
    self',
    inputs',
    system,
    ...
  }: let
    commonPackages = with pkgs; [
      # version control
      git
      git-absorb
      delta

      # build
      gnumake
      just # modern make alternative

      # shell utils
      uutils-coreutils
      ripgrep
      fd
      bat
      jq
      yq-go
    ];
  in {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = commonPackages;
      };

      python = pkgs.mkShell {
        buildInputs =
          commonPackages
          ++ (with pkgs; [
            python3
            uv
            ruff
            pyright
            python3Packages.ipython
          ]);

        shellHook = ''
          export PYTHONDONTWRITEBYTECODE=1
          export PYTHONUNBUFFERED=1
        '';
      };

      rust = pkgs.mkShell {
        buildInputs =
          commonPackages
          ++ (with pkgs;
            [
              rustc
              cargo
              rustfmt
              clippy
              rust-analyzer
              cargo-watch
              cargo-expand
              cargo-deny
            ]
            ++ lib.optionals (!pkgs.stdenv.isDarwin) [pkgs.mold]);

        shellHook = ''
          export CARGO_NET_GIT_FETCH_WITH_CLI=true
          export RUST_BACKTRACE=1
        '';
      };

      nix = pkgs.mkShell {
        buildInputs =
          commonPackages
          ++ (with pkgs; [
            nil
            nixfmt-rfc-style
            nix-tree
            nix-diff
            statix
            deadnix
          ]);
      };
    };
  };
}
