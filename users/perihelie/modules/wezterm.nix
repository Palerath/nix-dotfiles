{
   programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      extraConfig = ''
         local wezterm = require 'wezterm'
         local config = wezterm.config_builder()
         
         config.initial_cols = 120
         config.initial_rows = 28

         -- or, changing the font size and color scheme.
         config.font = wezterm.font("iosevka")
         config.font_size = 14
         config.color_scheme = 'Afterglow'

         return config
      '';
   };
}
