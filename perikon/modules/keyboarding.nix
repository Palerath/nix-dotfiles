{ pkgs, lib, ... }:
{
   environment.systemPackages = with pkgs; [ 
      ibus 
      qwerty-fr
   ];

   i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
      # fcitx5.addons = with pkgs; [ fcitx5-gtk fcitx5-configtool pkgs.fcitx5-mozc ];
      # fcitx5.waylandFrontend = true;   # Wayland mode (suppress env warnings):contentReference[oaicite:3]{index=3}
   };


   services.xserver = {
      xkb = {
         layout = "us,fr";
         variant = ",";
         options = "grp:alt_shift_toggle,grp_led:scroll";
      };
   };

   # Set environment variables for fcitx5
   environment.variables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE  = "ibus";
      XMODIFIERS    = lib.mkDefault "@im=ibus";
      XIM_PROGRAM   = "ibus-daemon";
   };

   # Locales and keyboard layout toggling
   i18n.defaultLocale   = "en_US.UTF-8";
   i18n.extraLocales = [ "en_US.UTF-8" "fr_FR.UTF-8" "ja_JP.UTF-8" ];
   # XKB (for console/Wayland clients): US and French QWERTY, toggle with Alt+Shift
   environment.variables.XKB_DEFAULT_LAYOUT = "us,fr";
   environment.variables.XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";


   # boot.kernelParams = [ "vm.vfs_cache_pressure=50" ];
   # systemd.user.extraConfig = ''
   #   DefaultLimitDATA=4G
   #   DefaultLimitRSS=4G
   # '';
}

