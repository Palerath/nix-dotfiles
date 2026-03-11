{
  hostName,
  config,
  ...
}: let
  aliases = import ./aliases.nix {
    inherit hostName;
    username = config.custom.username;
  };
in {
  programs.bash.shellAliases = aliases.shellAliases;
  programs.zoxide.enable = true;
}
