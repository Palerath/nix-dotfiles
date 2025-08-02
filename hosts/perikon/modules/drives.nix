{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [ 
      ntfs3g
      udiskie
   ];

   boot.supportedFilesystems = ["ntfs-3g"];

   fileSystems."/home/perihelie/drives/hdd" = {
      device = "/dev/sda4";
      fsType = "ntfs-3g";
      options = [ 
         "defaults"  "rw" "exec"
         "uid=1000" 
         "umask=0022" 
         "gid=1000" 
         "dmask=000" 
         "fmask=000"
         "permissions"
         "nofail" "auto"
         "big_writes"
         "windows_names"
      ];
   };

   fileSystems."/home/perihelie/drives/nvme" = {
      device = "/dev/nvme0n1p5";
      fsType = "ntfs-3g";
      options = [ 
         "defaults" "rw" "exec" 
         "uid=1000" 
         "umask=0022" 
         "gid=1000" 
         "dmask=000" 
         "fmask=000"
         "permissions"
         "nofail" "auto"
         "big_writes"
         "windows_names"

      ];
   };

}

