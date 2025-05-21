{pkgs, lib, ... }:
{
   home.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";

      GIO_EXTRA_MODULES = "${pkgs.glib-networking}/lib/gio/modules";
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" [
         pkgs.gst_all_1.gst-plugins-base
         pkgs.gst_all_1.gst-plugins-good
         pkgs.gst_all_1.gst-plugins-bad
         pkgs.gst_all_1.gst-plugins-ugly
      ];
   };
}
