{pkgs, ...}:  
{
   environment.systemPackages = with pkgs; [
      qemu_kvm
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      looking-glass-client
      scream
   ];

   programs.adb.enable = true;

   boot = {
      initrd.kernelModules = [
         "vfio_pci"
         "vfio"
         "vfio_iommu_type1"
      ];

      initrd.availableKernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];

      kernelModules = [ 
         "kvm-amd" 
         "vfio" 
         "vfio_iommu_type1" 
         "vfio_pci" 
         "vfio_virqfd" 
      ];

      kernelParams = [
         "amd_iommu=on"  
         "iommu=pt"
         "vfio-pci.ids=10de:1f82,10de:10fa"
         "default_hugepagesz=1G"
         "hugepagesz=1G"
         "hugepages=16"
         # CRITICAL: More aggressive ACS override to break up IOMMU groups
         "pcie_acs_override=downstream,multifunction"
      ];

      # Blacklist GPU drivers only
      extraModprobeConfig = ''
      softdep drm pre: vfio-pci
      options vfio-pci ids=10de:1f82,10de:10fa
      blacklist nouveau
      '';

   };

   # Add user to required groups
   users.users.perihelie.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];

   # Enable KVM and virtualization
   virtualisation = {
      libvirtd = {
         enable = true;
         qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            ovmf = {
               enable = true;
               packages = [ pkgs.OVMFFull.fd ];
            };
         };
      };
      spiceUSBRedirection.enable = true;
   };

   # Ensure libvirt daemon starts automatically
   systemd.services.libvirtd = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
   };

   # Enable libvirt socket activation
   systemd.sockets.libvirtd = {
      enable = true;
      wantedBy = [ "sockets.target" ];
   };

   # Add environment variables for OpenGL support
   environment.sessionVariables = {
      LIBGL_ALWAYS_SOFTWARE = "0";
      MESA_GL_VERSION_OVERRIDE = "3.3";
   };
}
