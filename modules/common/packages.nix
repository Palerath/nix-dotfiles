{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      sops
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
      dust
      dua

      rar
      zip
      xz
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      wl-clipboard
    ];
}
