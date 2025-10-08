{pkgs, ...}:  
{
   programs.virt-manager.enable = true;

   environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
   ];

   users.groups.libvirtd.members = ["perihelie"];
   users.users.perihelie.extraGroups = ["libvirtd"];

   virtualisation = {
      libvirtd = {
         enable = true;
         qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
   };

   services.spice-vdagentd.enable = true;
}
