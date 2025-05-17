{ pkgs, lib, ... }:
{
   environment.systemPackages = with pkgs; [ 
      ibus
      ibus-engines.anthy
      qwerty-fr
      fcitx5
   ];

   programs.dconf.enable = true;

   i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus = { 
         engines = with pkgs.ibus-engines; [ anthy ];
         panel = null;
      };
      # fcitx5.addons = with pkgs; [ fcitx5-gtk fcitx5-configtool pkgs.fcitx5-mozc ];
      # fcitx5.waylandFrontend = true;   # Wayland mode (suppress env warnings):contentReference[oaicite:3]{index=3}
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

   # environment variables for fcitx5
   # environment.variables = {
   # GTK_IM_MODULE = "fcitx";
   # QT_IM_MODULE  = "fcitx";
   # XMODIFIERS    = lib.mkDefault "@im=fcitx5";
   # XIM_PROGRAM   = "fcitx5";
   # };

   # Ibus auto-start


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


   # boot.kernelParams = [ "vm.vfs_cache_pressure=50" ];
   # systemd.user.extraConfig = ''
   #   DefaultLimitDATA=4G
   #   DefaultLimitRSS=4G
   # '';
}

