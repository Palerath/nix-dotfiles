{
   # CMake < 3.5
   nixpkgs.overlays = [
      (final: prev: {
         # Use cmake 3.28 which still has better compatibility
         cmake = prev.cmake_3_28 or prev.cmake;

         # Force stdenv to use the older cmake
         stdenv = prev.stdenv.override {
            cc = prev.stdenv.cc.override {
               bintools = prev.stdenv.cc.bintools.override {
                  # Ensure cmake is the older version
               };
            };
         };
      })
   ];
}
