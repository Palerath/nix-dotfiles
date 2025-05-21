{pkgs, ... }:
{
   virtualisation.waydroid.enable = true;

   networking.firewall = {
      checkReversePath = "loose";
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
   };

  
   environment.systemPackages = with pkgs; [ 
      waydroid
      android-tools
      waydroid-helper
   ];
   boot.kernelModules = [ "binder_linux" ];

}
