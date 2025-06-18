{pkgs, ...}:  
{

   boot.kernelModules = [ "kvm-amd" "vfio-pci" "vfio" "vfio_iommu_type1" ];

   # Enable virtualization support
   # This enables the KVM kernel module which provides hardware acceleration
   virtualisation = {
      # Enable libvirtd daemon - this manages virtual machines
      libvirtd = {
         enable = true;
         # QEMU package selection - we want the full QEMU with KVM support
         qemu = {
            package = pkgs.qemu_kvm;
            # Enable UEFI support for modern guest systems
            ovmf.enable = true;
            # Enable TPM emulation (useful for newer Android versions)
            swtpm.enable = true;
         };
      };

      # Enable SPICE USB redirection for better device support
      spiceUSBRedirection.enable = true;
   };

   # Install required packages system-wide
   environment.systemPackages = with pkgs; [
      # Main virtualization management GUI
      virt-manager
      # QEMU utilities (includes qemu-img for disk management)
      # qemu_kvm
      qemu_full
      # SPICE client for enhanced display and input
      spice
      # SPICE protocol support
      spice-protocol
      # USB redirection support
      spice-gtk
      # Additional QEMU tools
      qemu-utils
   ];

   # Add your user to the libvirtd group
   # Replace "yourusername" with your actual username
   users.users.perihelie.extraGroups = [ "libvirtd" "kvm" "adbusers" ];
}
