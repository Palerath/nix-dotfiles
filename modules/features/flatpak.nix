{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.flatpak = {
    pkgs,
    config,
    ...
  }: {
    services.flatpak.enable = true;

    systemd.services = {
      flatpak-repo = {
        wantedBy = ["multi-user.target"];
        path = [pkgs.flatpak];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

          flatpak override --system --reset

          flatpak override --system --env=XKB_CONFIG_ROOT=${pkgs.xkeyboard-config}/share/X11/xkb
          flatpak override --system --filesystem=${pkgs.xkeyboard-config}/share/X11/xkb:ro
          flatpak override --system --nofilesystem=/home/perihelie/drives/shares
          flatpak override --system --nofilesystem=/home/perihelie/shares
        '';
      };

      # Install NVIDIA runtime for Flatpak applications
      flatpak-nvidia-driver = {
        wantedBy = ["multi-user.target"];
        after = ["flatpak-repo.service"];
        path = [pkgs.flatpak];
        script = let
          nvidiaVersion = config.boot.kernelPackages.nvidiaPackages.stable.version;
          flatpakVersion = builtins.replaceStrings ["."] ["-"] nvidiaVersion;
        in ''
          flatpak install -y --noninteractive flathub org.freedesktop.Platform.GL.nvidia-${flatpakVersion} 2>/dev/null || true
          flatpak install -y --noninteractive flathub org.freedesktop.Platform.GL.default 2>/dev/null || true
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      # Configure Anki for both X11 and Wayland
      flatpak-anki-overrides = {
        wantedBy = ["multi-user.target"];
        after = ["flatpak-repo.service"];
        path = [pkgs.flatpak pkgs.xkeyboard-config pkgs.coreutils pkgs.gnugrep pkgs.findutils];
        script = ''
          flatpak override --system net.ankiweb.Anki \
            --socket=wayland \
            --socket=fallback-x11 \
            --device=dri \
            --unset-env=ANKI_WAYLAND
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };

    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';

    environment.systemPackages = with pkgs; [
      flatpak
    ];
  };
}
