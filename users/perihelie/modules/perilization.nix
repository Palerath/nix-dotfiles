{ pkgs, ... }:
{
   home.packages = with pkgs; [
      # QEMU and virtualization
      qemu_kvm
      qemu
      virt-manager
      virt-viewer

      # Android development tools
      android-tools

      # Additional GUI tools
      qtemu          # QEMU GUI frontend

      # Wayland utilities
      wlr-randr

      # Additional tools
      looking-glass-client
      barrier  # For sharing keyboard/mouse
   ];

   home.sessionVariables = {
      QEMU_AUDIO_DRV = "spice";
      DISPLAY = ":0";
      WAYLAND_DISPLAY = "wayland-1";
   };

   # Desktop entry for virt-manager with Android focus
   xdg.desktopEntries.android-virt-manager = {
      name = "Android Virtual Machine Manager";
      comment = "Create and manage Android VMs with GPU acceleration";
      exec = "${pkgs.virt-manager}/bin/virt-manager";
      icon = "virt-manager";
      categories = [ "Development" "Emulator" "System" ];
   };

   # Enable services
   services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
   };

}
