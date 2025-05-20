{pkgs, ...}:
{
   home.packages = with pkgs; [
      zsh
      oh-my-zsh
   ];

   programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
       
      shellAliases =
         let
            flakePath = "/home/perihelie/dotfiles";
         in{
            rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
            hms = "home-manager switch --flake ${flakePath}";
            nv = "nvim .";
            nvim = "nvim .";
         };

      initContent = ''
         fastfetch
      '';
   };

   programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "agnoster";
   };

}

