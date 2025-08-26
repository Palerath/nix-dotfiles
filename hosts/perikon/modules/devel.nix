{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      # PYTHON
      python3Full
      pipx
      poetry

      # RUST
      rustup
      rustc
      rust-analyzer
      cargo

      # C/C++
      gcc
      clang
      cmake
      pkg-config
      glib

      # OTHER
      openssl
      pkg-config
      sqlite
      claude-code
   ];

   environment.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
   };
}
