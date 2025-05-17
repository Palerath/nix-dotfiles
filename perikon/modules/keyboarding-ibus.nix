{ pkgs, lib, ... }:
{
   environment.systemPackages = with pkgs; [ 
      ibus
      ibus-engines.anthy
      qwerty-fr
   ];

   programs.dconf.enable = true;

   i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus = { 
         engines = with pkgs.ibus-engines; [ anthy ];
         panel = null;
      };
   };

   # Ibus env-variables
   environment.variables = {
      QT_IM_MODULE  = lib.mkForce null;
      GTK_IM_MODULE = lib.mkForce null;
      XMODIFIERS    = lib.mkDefault "@im=ibus";
      GTK_IM_MODULE_FOR_XWAYLAND = "xim";
   };

   # Ibus auto-start
   environment.pathsToLink = [ "/etc/xdg/autostart" ];
   environment.etc = {
      "xdg/autostart/ibus-wayland.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=IBus Wayland
      Exec=ibus-daemon --panel disable --xim
      OnlyShowIn=KDE;
      X-KDE-Wayland-ImKey=ibus
      '';
   };

   environment.etc = {
      "xdg/ibus-setup/anthy" = {
         text = ''
      [Engine]
      PagePeriod=0
      PageComma=0
         '';
         mode = "0644";
      };
   };


   services.xserver = {
      xkb = {
         layout = "us,fr";
         variant = ",";
         options = "grp:alt_shift_toggle,grp_led:scroll";
      };
   };

   # Locales and keyboard layout toggling
   i18n.defaultLocale   = "en_US.UTF-8";
   i18n.extraLocales = [ 
      "en_US.UTF-8" 
      "fr_FR.UTF-8" 
      "ja_JP.UTF-8" 
   ];

   # XKB (for console/Wayland clients): US and French QWERTY, toggle with Alt+Shift
   environment.variables.XKB_DEFAULT_LAYOUT = "us,fr";
   environment.variables.XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";

}

