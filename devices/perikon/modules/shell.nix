{pkgs, ...}:
{
   users.extraUsers.perihelie = {
      shell = pkgs.zsh;
   };
   users.users.perihelie.ignoreShellProgramCheck = true;

   programs.bash = {
      shellAliases =
         let
            flakePath = "/home/perihelie/dotfiles";
         in{
            rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
            hms = "home-manager switch --flake ${flakePath}";
            nv = "nvim";

         };
   };
}
