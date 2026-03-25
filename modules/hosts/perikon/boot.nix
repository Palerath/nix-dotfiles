{
  self,
  init,
  ...
}: {
  flake.nixosModules.init = {
    pkgs,
    config,
    ...
  }: {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        "usbcore.autosuspend=-1"
        "pcie_aspm=off"
        "nvidia_drm.modeset=1"
        "nvidia_drm.fbdev=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "acpi_enforce_resources=lax"
        "preempt=full"
      ];

      kernelModules = [
        "uinput"
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
        "coretemp"
        "it87"
        "i2c-dev"
      ];

      kernel.sysctl = {
        "vm.stat_interval" = 10;
        "kernel.sched_rt_runtime_us" = -1;
      };

      extraModulePackages = with config.boot.kernelPackages; [it87];

      loader = {
        systemd-boot.enable = true;
        timeout = 10;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
    };
    environment.systemPackages = [pkgs.efibootmgr];
    powerManagement.cpuFreqGovernor = "performance";

    services.udev.extraRules = ''
      # uinput permissions for input simulation
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"

      # Allow input group to access event devices
      SUBSYSTEM=="input", GROUP="input", MODE="0660"

      # NVIDIA device nodes
      ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia0 c 195 0'"
      KERNEL=="nvidia*", MODE="0666"
      KERNEL=="nvidia_uvm", MODE="0666"
    '';
  };
}
