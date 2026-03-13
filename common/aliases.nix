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
<<<<<<< HEAD
    # then "darwin-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'"
    then "nh os switch ${dotfilesPath} -H ${hostName}"
=======
    then "sudo darwin-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'"
>>>>>>> a728de98bad5b628d892c96cc17f24a17636c163
    else "nh os switch ${dotfilesPath} -H ${hostName}";

  rebuildNixCmd =
    if isDarwin
    then "sudo darwin-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'"
    else "sudo nixos-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'";
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
