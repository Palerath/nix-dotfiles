{config, ...}:
{
   home.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
   };

   home.sessionPath = [
      "${config.home.homeDirectory}/.config/emacs/bin:$PATH"
   ];

}
