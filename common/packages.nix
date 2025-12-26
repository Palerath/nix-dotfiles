{pkgs, ...}:
{
    environment.systemPackages = with pkgs; [ 
        wl-clipboard
        uutils-coreutils-noprefix
        ffmpeg-full
        tree
        wget
        ripgrep
        fd
        bat
        eza
        zoxide
        fzf
        file

        unzip
        p7zip
      ];

      programs.nh.enable = true;
}
