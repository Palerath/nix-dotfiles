{pkgs, ...}:
{
    environment.systemPackages = with pkgs; [ 
        wl-clipboard
        uutils-coreutils-noprefix
    ];
}
