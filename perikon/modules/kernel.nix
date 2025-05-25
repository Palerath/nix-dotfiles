{pkgs, ...}:
{
   boot = {
      kernelPackages = pkgs.linuxPackages_zen;

      kernelModules = [ "kvm-intel" "kvm-amd" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
      kernelParams = [
         "amd_iommu=on"  
         "iommu=pt"
         "default_hugepagesz=1G"
         "hugepagesz=1G"
         "hugepages=16"  # Adjust based on your RAM
      ];

      # Blacklist GPU driver for second GPU (replace with your GPU's PCI ID)
      extraModprobeConfig = ''
      softdep drm pre: vfio-pci
      # Find it with: lspci -nn | grep VGA
      options vfio-pci ids=10de:1f82,10de:5678
      '';
   };
}
