{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.audio = {pkgs, ...}: {
    users.users.perihelie.extraGroups = ["audio"];

    environment.systemPackages = with pkgs; [
      alsa-utils
      alsa-tools
      pipecontrol
      pavucontrol
      flac
      # ocenaudio
      crosspipe
      feishin
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;

      # Audio input loopback
      extraConfig.pipewire."99-loopback" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Mac Audio Loopback";
              "capture.props"."node.name" = "mac_loopback_input";
              "playback.props" = {
                "node.name" = "mac_loopback_output";
                "node.passive" = true;
                "volume" = 0.1;
              };
            };
          }
        ];
      };
    };
  };
}
