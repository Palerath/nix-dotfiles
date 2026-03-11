{
  lib,
  config,
  ...
}: {
  options.custom.username = lib.mkOption {
    type = lib.types.str;
    default = lib.head (lib.attrNames (
      lib.filterAttrs (_: u: u.isNormalUser) config.users.users
    ));
    description = "Primary normal user of this system";
  };
}
