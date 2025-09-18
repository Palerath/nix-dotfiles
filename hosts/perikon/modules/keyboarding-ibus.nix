{pkgs, ...}:
{
   i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ 
         mozc-ut
         m17n
      ];
   };

   environment.sessionVariables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
      IBUS_USE_SYSTEM_KEYBOARD_LAYOUT = "1";
   };
}
