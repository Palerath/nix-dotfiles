{pkgs, ...}:
{
   fonts.packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      ipafont
      ipaexfont
      migu
      jigmo
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      powerline-fonts
      powerline-symbols
      noto-fonts-emoji
      nerd-fonts.agave
   ];
}
