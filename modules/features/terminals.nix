{
  self,
  inputs,
  ...
}: {
  flake.homeModules.alacritty = {pkgs, ...}: {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          startup_mode = "Windowed";
          opacity = 0.9;
          dynamic_padding = true;
        };

        font = {
          size = 14;
          normal = {
            family = "Iosevka Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "Iosevka Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "Iosevka Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "Iosevka Nerd Font";
            style = "Bold Italic";
          };
        };
      };
    };
  };

  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka Nerd Font Mono";
        size = 14;
      };
      settings = {
        enable_audio_bell = false;
        scrollback_lines = 10000;
        update_check_interval = 0;

        # Window
        background_opacity = 0.9;
      };

      enableGitIntegration = true;

      shellIntegration = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };

      extraConfig = ''term xterm-kitty'';
    };
  };
}
