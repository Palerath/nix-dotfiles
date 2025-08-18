{pkgs, ...}:
{
    home.packages = with pkgs; [
        vlc
        firefox
        spotify
    ];
}
