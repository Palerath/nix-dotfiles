{ config, pkgs, inputs, ... }:
{
    home.username = "perihelie";
    home.homeDirectory = "/home/perihelie";
    home.stateVersion = "24.05";

    programs.git = {
        enable = true;
        userName = "perihelie";
        userEmail = "archibaldmk4@gmail.com";
    };

    programs.home-manager.enable = true;

    imports = [ 
        ./perihelie-modules 
        inputs.zen-browser.homeModules.beta
        inputs.nvf.homeManagerModules.default
    ];

    home.packages = with pkgs; [
        vesktop
        qbittorrent
        obsidian
        vlc
        flatpak
        anki-bin
        texlab
        qolibri
        yt-dlp
        krita
        audacious
        protonvpn-gui
        sqlite
        dbeaver-bin
        localsend
    ];

    programs.zen-browser = {
        enable = true;
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    fonts.fontconfig.enable = true;
}
