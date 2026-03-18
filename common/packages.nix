{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sops

    wl-clipboard
    libinput
    uutils-coreutils-noprefix
    findutils
    ffmpeg-full
    tree
    wget
    ripgrep
    fd
    bat
    eza
    xh
    zoxide
    fzf
    file
    unzip
    p7zip
    toybox
    net-tools
    du-dust
    dua

    # File formats
    rar
    zip
    xz
  ];

  programs.nh.enable = true;
}
