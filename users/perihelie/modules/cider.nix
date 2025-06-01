{pkgs, ...}:
{
   home.packages = with pkgs; [
      (let
         cider = stdenv.mkDerivation rec {
            pname = "cider";
            version = "3.0.2"; 

            src = /home/perihelie/Desktop/Cider.AppImage; # path to extracted files

            nativeBuildInputs = [ makeWrapper ];

            installPhase = ''
        mkdir -p $out/bin $out/share/cider
        cp -r * $out/share/cider/
        makeWrapper $out/share/cider/cider $out/bin/cider \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib gtk3 glib ]}
            '';
         };
      in cider)
   ];
}
