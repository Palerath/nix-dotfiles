{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.fileSystems = {
    pkgs,
    lib,
    config,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
      cifs-utils
      samba
      rsync
    ];

    services = {
      udisks2.enable = true;
      samba.smbd.enable = true;
    };

    boot.supportedFilesystems = {
      btrfs = true;
      ntfs = true;
    };

    # SSD

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/bdf36744-9ab1-40c3-b4fe-593002e624dc";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd" "noatime"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6564-0E25";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/bdf36744-9ab1-40c3-b4fe-593002e624dc";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/bdf36744-9ab1-40c3-b4fe-593002e624dc";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/7a1fc992-b319-4883-85d2-6fa1bf9e2f2e";}
    ];

    # HDD

    fileSystems."/home/perihelie/drives/data" = {
      device = "/dev/disk/by-uuid/8be9887a-2767-468a-a59d-03904fd84adc";
      fsType = "btrfs";
      options = ["subvol=@data" "compress=zstd" "noatime" "nofail"];
    };

    fileSystems."/home/perihelie/drives/games" = {
      device = "/dev/disk/by-uuid/8be9887a-2767-468a-a59d-03904fd84adc";
      fsType = "btrfs";
      options = ["subvol=@games" "compress=zstd" "noatime" "nofail"];
    };

    # NVME
    fileSystems."/home/perihelie/drives/fdata" = {
      device = "/dev/disk/by-uuid/2a6420e1-9663-4f65-beb1-b7de08d6094c";
      fsType = "btrfs";
      options = ["subvol=@fdata" "compress=zstd" "noatime" "nofail"];
    };

    # External storage
    fileSystems."/mnt/disque44tours" = {
      device = "/dev/disk/by-uuid/DA88A9B988A99513";
      fsType = "ntfs3";
      options = [
        "force"
        "nofail"
        "uid=1000"
        "gid=100"
        "umask=0022"
      ];
    };

    # Samba shares
    imports = [self.nixosModules.sops];
    sops = {
      secrets.smb_username = {};
      secrets.smb_password = {};
      templates."smb-secrets" = {
        content = ''
          username=${config.sops.placeholder.smb_username}
          password=${config.sops.placeholder.smb_password}
        '';
        mode = "0400";
        path = "/run/sops/smb-secrets";
      };
    };

    fileSystems."/home/perihelie/shares/media" = {
      device = "//192.168.1.66/media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=/run/secrets-rendered/smb-secrets,uid=1000,gid=100,file_mode=0664,dir_mode=0775"];
    };

    fileSystems."/home/perihelie/shares/shared" = {
      device = "//192.168.1.66/shared";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=/run/secrets-rendered/smb-secrets,uid=1000,gid=100,file_mode=0664,dir_mode=0775"];
    };

    fileSystems."/home/perihelie/shares/perihelie" = {
      device = "//192.168.1.66/perihelie";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=/run/secrets-rendered/smb-secrets,uid=1000,gid=100,file_mode=0664,dir_mode=0775"];
    };

    networking.firewall.extraCommands = ''
      ${pkgs.iptables}/bin/iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
    '';

    # Fix permissions after mount
    systemd.tmpfiles.rules = [
      "d /home/perihelie/drives/games 0755 perihelie users -"
      "d /home/perihelie/drives/data 0755 perihelie users -"
      "d /home/perihelie/drives/fdata 0755 perihelie users -"

      "d /home/perihelie/shares 0755 perihelie users -"
    ];

    security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
