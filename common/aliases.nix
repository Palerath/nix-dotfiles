{
  hostName,
  username,
  isDarwin ? false,
}: let
  dotfilesPath =
    if hostName == "periserver"
    then "/opt/dotfiles"
    else if isDarwin
    then "/Users/${username}/dotfiles"
    else "/home/${username}/dotfiles";

  rebuildCmd =
    if isDarwin
    then "nh darwin switch ${dotfilesPath} -H ${hostName}"
    else "rm /home/perihelie/.config/mimeapps.list.backup && nh os switch ${dotfilesPath} -H ${hostName}";

  rebuildNixCmd =
    if isDarwin
    then "sudo darwin-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'"
    else "rm /home/perihelie/.config/mimeapps.list.backup && sudo nixos-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'";
in {
  shellAliases = {
    kumit = "bash ${dotfilesPath}/scripts/kumit.sh";
    rebuild-nix = rebuildNixCmd;
    rebuild = rebuildCmd;

    update-flakes = "cd ${dotfilesPath} && nix flake update && kumit 'update flakes.lock'";
    maj = "cd ${dotfilesPath} && git pull && git submodule update --remote && update-flakes && rebuild";

    dot = "z dot && tmux";

    g = "git";
    ga = "git add .";
    gc = "git commit -am";
    gco = "git checkout";
    gd = "git diff";
    gl = "git log";
    gp = "git push";
    gpl = "git pull";
    gs = "git status";
    gb = "git branch";

    ls = "eza";
    ll = "eza -la";
    la = "eza -la";
    l = "eza -l";
    ".." = "z ..";
    "..." = "z ../..";

    core-ls = "ls";
    zi = "zi";
  };
}
