# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
   imports =
      [ # Include the results of the hardware scan.
         ./hardware-configuration.nix
         ./modules/shell.nix
         ./modules/graphics.nix
         ./modules/drives.nix
         ./modules/bootloader.nix
         ./modules/desktop-env/plasma.nix
         ./modules/desktop-env/xfce.nix
         ./modules/desktop-env/hyprland.nix
         ./modules/display-manager.nix
         ./modules/flatpak.nix
         ./modules/gayming.nix
         ./modules/fonts.nix
         ./modules/keyboarding-fcitx5.nix
         ./modules/python-packages.nix
         ./modules/locales.nix
         # ./modules/virtual-machines.nix
      ];

   security.sudo.enable = true;

   networking.hostName = "perikon"; # Define your hostname.
   # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

   # Configure network proxy if necessary
   # networking.proxy.default = "http://user:password@proxy:port/";
   # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

   # Enable networking
   networking.networkmanager.enable = true;

   nix.settings.experimental-features = ["nix-command" "flakes"];

   # Enable CUPS to print documents.
   services.printing.enable = true;

   # Enable sound with pipewire.
   services.pulseaudio.enable = false;
   security.rtkit.enable = true;
   services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      wireplumber.enable = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
   };

   # Enable touchpad support (enabled default in most desktopManager).
   # services.xserver.libinput.enable = true;

   # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.perihelie = {
      isNormalUser = true;
      description = "perihelie";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "gamemode" ];
   };

   nixpkgs.config.allowUnfree = true;
   # Install firefox.
   programs.firefox.enable = true;
   programs.ssh.askPassword = "";

   # List packages installed in system profile. To search, run:
   # $ nix search wget
   environment.systemPackages = with pkgs; [
      vim
      home-manager
      slop
      jan
      mecab
      mozcdic-ut-neologd
      polkit
      wl-clipboard
      uutils-coreutils-noprefix
      pciutils
      flac
      appimageupdate
      appimage-run
      gcc
      cmake
      pkg-config
      glib
      lm_sensors
   ];

   programs.nh = {
      enable = true;
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/perihelie/dotfiles";
   };

   environment.sessionVariables = {
      NH_FLAKE = lib.mkDefault "/home/perihelie/dotfiles";
   };

   services.dbus.enable = true;
   services.udisks2.enable = true;
   #   services.polkit.enable = true;
   services.gnome.glib-networking.enable = true;
   boot.kernelPackages = pkgs.linuxPackages_zen;

   #  system.autoUpgrade = {
   #    enable = true;
   #    flake = inputs.self.outPath;
   #    flags = [
   #       "--update-input"
   #       "nixpkgs"
   #       "--no-write-lock-file"
   #       "-L" # print build logs
   #    ];
   #    dates = "02:00";
   #    randomizedDelaySec = "45min";
   # };

   # Some programs need SUID wrappers, can be configured further or are
   # started in user sessions.
   # programs.mtr.enable = true;
   # programs.gnupg.agent = {
   #   enable = true;
   #   enableSSHSupport = true;
   # };

   # List services that you want to enable:

   # Enable the OpenSSH daemon.
   # services.openssh.enable = true;

   # Open ports in the firewall.
   # networking.firewall.allowedTCPPorts = [ ... ];
   # networking.firewall.allowedUDPPorts = [ ... ];
   # Or disable the firewall altogether.
   # networking.firewall.enable = false;

   # This value determines the NixOS release from which the default
   # settings for stateful data, like file locations and database versions
   # on your system were taken. It‘s perfectly fine and recommended to leave
   # this value at the release version of the first install of this system.
   # Before changing this value read the documentation for this option
   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
   system.stateVersion = "24.11"; # Did you read the comment?

}
