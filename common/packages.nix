{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    uutils-coreutils-noprefix
    findutils
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
    toybox
    net-tools

    # File formats
    rar
    zip
  ];

  programs.nh.enable = true;
}
