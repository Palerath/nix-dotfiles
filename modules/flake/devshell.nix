{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git nh nixos-rebuild alejandra nil
        rustup pkg-config openssl
        hyperfine python3 uv just jq curl httpie
      ];
      shellHook = ''
        export NIXPKGS_ALLOW_UNFREE=1
        export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
        export RUSTUP_HOME="$PWD/.rustup"
        export CARGO_HOME="$PWD/.cargo"
        export PATH="$CARGO_HOME/bin:$PATH"
        echo "Dev shell ready"
      '';
    };
  };
}
