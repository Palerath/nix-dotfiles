{
  hostName,
  username,
}: let
  # Define dotfiles path based on hostname
  dotfilesPath = 
    if hostName == "periserver"
    then "/opt/dotfiles"
    else "/home/${username}/dotfiles";
in {
  kumit = "bash ${dotfilesPath}/scripts/kumit.sh";
  rebuild-nix = "sudo nixos-rebuild switch --flake 'path:${dotfilesPath}#${hostName}'";
  rebuild = "nh os switch ${dotfilesPath} -H ${hostName}";

  update-flakes = "cd ${dotfilesPath} && nix flake update && kumit 'update flakes.lock'";
  maj = "cd ${dotfilesPath} && git pull && git submodule update --remote && update-flakes && rebuild";

  dot = "z dot && tmux";

  # Git aliases
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

  # Common system aliases
  ls = "eza";
  ll = "eza -la";
  la = "eza -la";
  l = "eza -l";
  ".." = "z ..";
  "..." = "z ../..";

  core-ls = "ls";

  # Zoxide aliases
  zi = "zi";
}
