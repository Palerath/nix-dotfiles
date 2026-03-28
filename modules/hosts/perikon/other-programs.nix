{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.otherPrograms = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Tablet support
      libwacom
      kdePackages.wacomtablet

      # File explorer
      kdePackages.dolphin
      kdePackages.filelight
      xnviewmp

      # video encoding support
      x265
      rav1e
    ];

    home.sharedModules = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-vkcapture
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
