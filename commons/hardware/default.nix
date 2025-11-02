{ config, pkgs, lib, ... }:

{
    # Common hardware configuration

    # Enable firmware updates
    hardware.enableRedistributableFirmware = true;

    # Audio
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Bluetooth
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };

    # Graphics
    hardware.graphics = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    # USB automounting
    services.udisks2.enable = true;

    # Printing
    services.printing.enable = true;
}
