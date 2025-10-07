{
   # CMake < 3.5


   nixpkgs.overlays = [
      (final: prev: {
         argagg = prev.argagg.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];
         });

         slop = prev.slop.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];
         });

         allegro = prev.allegro.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];
         });  

         libvdpau-va-gl =  prev.libvdpau-va-gl.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];
         });

      })
   ];

}
