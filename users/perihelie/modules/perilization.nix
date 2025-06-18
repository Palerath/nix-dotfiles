{ pkgs, ... }:
{
   # User-level packages for virtualization
   home.packages = with pkgs; [
      # Alternative VM manager - more modern interface than virt-manager
      gnome.gnome-boxes
      # QEMU monitor console (useful for debugging)
      qemu-utils
      # Looking glass client (if you ever want to try GPU passthrough later)
      looking-glass-client
   ];

   # Enable XDG desktop integration
   # This ensures VM applications show up properly in your KDE menu
   xdg = {
      enable = true;
      mimeApps.enable = true;
   };

   # Optional: Create desktop shortcuts for common tasks
   home.file.".local/share/applications/android-vm.desktop" = {
      text = ''
      [Desktop Entry]
      Type=Application
      Name=Android VM Manager
      Comment=Manage Android Virtual Machines
      Exec=virt-manager
      Icon=virt-manager
      Categories=System;Emulator;
      Terminal=false
      '';
   };

   # Configure environment variables for better Wayland support
   home.sessionVariables = {
      # Help Qt applications work better under Wayland
      QT_QPA_PLATFORM = "wayland;xcb";
      # Ensure QEMU can find its BIOS files
      QEMU_SYSTEM_PREFIX = "${pkgs.qemu_kvm}";
   };
}
