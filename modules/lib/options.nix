{lib, ...}: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Home Manager modules exported by this flake.";
  };
}
