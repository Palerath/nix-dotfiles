{pkgs, ...}:
{
   users.extraUsers.perihelie = {
      shell = pkgs.fish;
   };
   users.users.perihelie.ignoreShellProgramCheck = true;

   programs.bash = {
      shellAliases =
         let
            flakePath = "/home/perihelie/dotfiles";
         in{
            rebuild = "nh os switch";
            hms = "nh home switch";
            nv = "nvim";
            ls = "eza";
         };
   };
}
