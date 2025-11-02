{pkgs, ...}:
{
    environment.systemPackages = with pkgs; [ 
        vim 
        wl-clipboard
        uutils-coreutils-noprefix
    ];
}
