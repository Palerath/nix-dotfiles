{
   nixpkgs.overlays = [
      (final: prev: {
         # Override the default cmake in stdenv
         stdenv = prev.stdenv // {
            mkDerivation = args: prev.stdenv.mkDerivation (args // {
               cmakeFlags = (args.cmakeFlags or []) ++ [
                  "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
               ];
            });
         };
      })
   ];
}
