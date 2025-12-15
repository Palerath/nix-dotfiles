{ hostName, lib, config, ... }:
let
    normalUsers = lib.filterAttrs (_: user: user.isNormalUser) config.users.users;
    primaryUser = lib.head (lib.attrNames normalUsers);
    flakePath = "/home/${primaryUser}/dotfiles";   
   
    aliases = {
        kumit = "bash ${flakePath}/scripts/kumit.sh";
        rebuild-nix = "sudo nixos-rebuild switch --flake 'path:${flakePath}#${hostName}'";
        rebuild = "nh os switch ${flakePath} -H ${hostName}";

        update-flakes = "nix flake update && kumit 'update flakes.lock'";
        maj = "git submodule update --remote && update-flakes && rebuild";

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
