{
   # CMake < 3.5

   nixpkgs.overlays = [
      (final: prev: {
         # Helper function to add cmake policy flag
         fixCmake = pkg: pkg.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [
               "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
            ];
         });
      })
      (final: prev: {
         # Fix known problematic packages
         argagg = final.fixCmake prev.argagg;
         slop = final.fixCmake prev.slop;
      })
   ];

}
