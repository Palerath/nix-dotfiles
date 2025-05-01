{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [ 
      ntfs3g
      udiskie
   ];
   boot.supportedFilesystems = ["ntfs-3g"];
   fileSystems."/mnt/hdd" = {
      device = "/dev/sda4";
      fsType = "ntfs-3g";
      options = [ 
         "defaults"  "rw" "exec" "auto" "nofail" 
         "uid=1000" 
         "umask=0022" 
         "gid=1000" 
         "dmask=000" 
         "fmask=111"
      ];
   };

   fileSystems."/mnt/nvme" = {
      device = "/dev/nvme0n1p5";
      fsType = "ntfs-3g";
      options = [ 
         "defaults" "rw" "exec" "auto" "nofail" 
         "uid=1000" 
         "umask=0022" 
         "gid=1000" 
         "dmask=007" 
         "fmask=117"
      ];
   };
}

