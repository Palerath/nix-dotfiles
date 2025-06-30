{pkgs, ... }:
{
   home.packages = with pkgs; [
      rustup
      openssl
      pkg-config
      sqlite
   ];

   services.ollama = {
      enable = true;
      acceleration = "cuda";
   };

   home.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
   };
}
