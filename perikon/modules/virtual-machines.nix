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
      looking-glass-client  # For low-latency display
      scream  # For audio passthrough
   ];

   # Add user to required groups
   users.users.perihelie.extraGroups = [ "libvirtd" "kvm" "input" ];


   # Network bridge for VM (optional)
   networking.bridges = {
      br0 = {
         interfaces = [ ];
      };
   };
   networking.interfaces.br0.useDHCP = true;
}
