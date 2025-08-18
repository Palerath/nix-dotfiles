{ pkgs, ... }:
{
   boot.loader.systemd-boot.enable = false;
   boot.loader.timeout =  10;
   boot.loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
   };
   boot.loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 2000;
   };

   environment.systemPackages = with pkgs; [
      os-prober
   ];

}
