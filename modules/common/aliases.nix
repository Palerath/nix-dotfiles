{
  dotfilesPath,
  hostName,
  isDarwin,
  ...
}: let
  rebuildCmd =
    if isDarwin
    then "nh darwin switch ${dotfilesPath} -H ${hostName}"
    else "nh os switch ${dotfilesPath} -H ${hostName}";
in {
  kumit = "bash ${dotfilesPath}/scripts/kumit.sh";
  rebuild = rebuildCmd;
  update-flakes = "cd ${dotfilesPath} && nix flake update && kumit 'update flakes.lock'";

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
}
