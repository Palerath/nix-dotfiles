{lib, ...}: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.anything;
    default = {};
    description = "Home Manager modules exported by this flake.";
  };
}
