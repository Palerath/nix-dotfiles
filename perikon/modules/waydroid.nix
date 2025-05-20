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
      adb
      nur.repos.ataraxiasjel.waydroi-script
   ];
   boot.kernelModules = [ "binder_linux" ];

}
