{
   # CMake < 3.5

   nixpkgs.overlays = [
      (final: prev: 
         let
            # Helper function to add cmake policy flag
            fixCmake = pkg: pkg.overrideAttrs (old: {
               cmakeFlags = (old.cmakeFlags or []) ++ [
                  "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
               ];
            });
         in
            {
            argagg = fixCmake prev.argagg;
            slop = fixCmake prev.slop;
            allegro = fixCmake.prev.allegro;
         }
      )
   ];
}
