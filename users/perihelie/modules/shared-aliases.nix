# shared-aliases.nix
{ ... }:
let
   flakePath = "/home/perihelie/dotfiles";
   aliases = {
      rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
      hms = "home-manager switch --flake ${flakePath}";

      # Git aliases
      g = "git";
      ga = "git add *";
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

      # virt-manager
      android-vm = "virt-manager";
      adb-connect = "adb connect localhost:5555";
   };
in
   {

   # For traditional shells (zsh, fish, bash)
   shellAliases = aliases;

}
