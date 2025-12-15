{ hostName, lib, config, ... }:
let
    normalUsers = lib.filterAttrs (_: user: user.isNormalUser) config.users.users;
    primaryUser = lib.head (lib.attrNames normalUsers);
    aliases = import ./aliases.nix { inherit hostName; username = primaryUser; };
in
{
    programs.bash = {
        shellAliases = aliases;
    };

    programs.zoxide = {
        enable = true;
    };
}
