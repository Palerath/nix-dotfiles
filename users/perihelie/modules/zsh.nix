{pkgs, ...}:

let
   sharedAliases = import ./shared-aliases.nix { };
in{
   home.packages = with pkgs; [
      zsh
      oh-my-zsh
   ];

   programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = sharedAliases.shellAliases;

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

