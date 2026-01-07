{
  hostName,
  username,
}: {
  kumit = "bash /home/${username}/dotfiles/scripts/kumit.sh";
  rebuild-nix = "sudo nixos-rebuild switch --flake 'path:'/home/${username}/dotfiles#${hostName}'";
  rebuild = "nh os switch /home/${username}/dotfiles -H ${hostName}";

  update-flakes = "nix flake update && kumit 'update flakes.lock'";
  maj = "cd /home/${username}/dotfiles && git pull && git submodule update --remote && update-flakes && rebuild";

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
