{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.openTv = {
    config,
    pkgs,
    ...
  }: {
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.oci-containers.containers.open-tv = {
      image = "ghcr.io/fredolx/open-tv:latest";
      autoStart = false;

      environment = {
        DISPLAY = ":0";
      };

      volumes = [
        "/tmp/.X11-unix:/tmp/.X11-unix:rw"
        "/root/.Xauthority:/root/.Xauthority:rw"
        "/root/.local/share/open-tv:/root/.local/share/open-tv"
      ];

      extraOptions = [
        "--net=host"
        "--gpus=all"
        "--device=/dev/nvidia0"
        "--device=/dev/nvidiactl"
        "--device=/dev/nvidia-uvm"
      ];
    };
  };

  flake.homeModules.kodi = {pkgs, ...}: {
    xdg.desktopEntries.kodi = {
      name = "Kodi";
      comment = "Media Center";
      exec = "kodi";
      icon = "kodi";
      terminal = false;
      categories = ["AudioVideo" "Video" "Player" "TV"];
    };

    programs.kodi = {
      enable = true;
      package = pkgs.kodi-wayland.withPackages (kodiPkgs:
        with kodiPkgs; [
          youtube
          pvr-iptvsimple
          inputstream-adaptive
          inputstreamhelper
        ]);

      settings = {
        videoplayer = {
          adjustrefreshrate = "2";
          useamcodec = "false";
          skiploopfilter = "16";
        };

        network = {
          bandwidth = "0";
          usehttpproxy = "false";
          curlclienttimeout = "30";
          curllowspeedtime = "20";
          cachemembuffersize = "104857600";
          readbufferfactor = "4";
        };

        cache = {
          buffermode = "1";
          memorysize = "104857600";
          readfactor = "8.0";
        };

        pvr = {
          timecorrection = "0";
          minvideocachelevel = "50";
          minaudiocachelevel = "50";
          cacheindvdplayer = "true";
        };

        locale = {
          language = "resource.language.fr_fr";
          timezone = "Europe/Paris";
          country = "France";
        };

        lookandfeel = {
          skin = "skin.estuary";
          startupwindow = "10025";
        };
      };
    };
  };
}
