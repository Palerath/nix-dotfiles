{ hostName, ... }:
let
    flakePath = "/home/perihelie/dotfiles";
    aliases = {
        kumit = "bash ${flakePath}/scripts/kumit.sh";
        rebuild = "sudo nixos-rebuild switch --flake 'path:${flakePath}#${hostName}'";
        rebuild-nh = "nh os switch ${flakePath} -H ${hostName}";

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
    };
in
    {

    programs.bash = {
        enable = true;
        shellAliases = aliases;
    };

     programs.zoxide = {
        enable = true;
        enableBashIntegration = true;  
        enableFishIntegration = true;  
   };

}
