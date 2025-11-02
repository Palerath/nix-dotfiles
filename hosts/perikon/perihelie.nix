{inputs, ...}:
{
    home.username = "perihelie";
    home.homeDirectory = "/home/perihelie";
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

    dconf = {
        settings = {
            "org.kde.keyboard" = {
                layouts = [ "qwerty-fr" ];
                defaultLayout = "qwerty-fr";
            };
        };

    };
}
