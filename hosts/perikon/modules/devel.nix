{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      # PYTHON
      pipx
      
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
   ];

   environment.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
   };
}
