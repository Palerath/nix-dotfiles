{pkgs, nur, ... }:
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
      nur.repos.ataraxiasjel.waydroid-script
   ];
   boot.kernelModules = [ "binder_linux" ];

}
