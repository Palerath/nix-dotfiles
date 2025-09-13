{pkgs, ...}:
{
   home.packages = with pkgs; [ 
      kitty-themes
      kitty-img
   ];
   programs.kitty = {
      enable = true;
      package = pkgs.kitty;            
      themeFile = "bright lights";           

      font = { name = "JetBrains Mono"; size = 14; };

      settings = { 
         confirm_os_window_close = 0;
         enable_audio_bell = false;
         shell_integration = "enabled";
         allow_remote_control = "yes";
         repaint_delay = 10;
         input_delay = 3;
         scrollback_lines = 10000;
         sync_to_monitor = true;


         bold_font = "auto";
         italic_font = "auto";
         bold_italic_font = "auto";
         disable_ligatures = "never";

         tab_bar_edge = "top";
         tab_bar_style = "powerline";
         enabled_layouts = "tall,stack";
         background_opacity = "0.9";
         dynamic_background_opacity = true;
         background_blur = 0.5;

         copy_on_select = "clipboard";
         window_padding_width = 8;
         mouse_hide_wait = "3.0";
         wheel_scroll_multiplier = "5.0";
         scrollback_pager_history_size = 32;
         text_composition_strategy = "platform";
      };

      keybindings = {
         "cmd+t" = "new_tab";
         "cmd+w" = "close_tab";
         "cmd+shift+]" = "next_tab";
         "cmd+shift+[" = "previous_tab";

         "ctrl+shift+equal" = "change_font_size all +1.0";
         "ctrl+shift+minus" = "change_font_size all -1.0";
         "ctrl+shift+backspace" = "change_font_size all 0";

         "f1" = "new_window_with_cwd";
         "f2" = "launch --cwd=current $EDITOR .";
         "super+f" = "toggle_fullscreen";
      };    

      shellIntegration = {
         enableBashIntegration = true;
         enableFishIntegration = true;
         enableZshIntegration = true;
      }; 
      extraConfig =''
      # Nerd Font symbol mapping for icons and powerline
      symbol_map U+23FB-U+23FE,U+2B58,U+E200-U+E2A9,U+E0A0-U+E0A3,U+E0B0-U+E0BF,U+E0C0-U+E0C8,U+E0CC-U+E0CF,U+E0D0-U+E0D2,U+E0D4,U+E700-U+E7C5,U+F000-U+F2E0,U+2665,U+26A1,U+F400-U+F4A8,U+F67C,U+E000-U+E00A,U+F300-U+F313,U+E5FA-U+E62B Symbols Nerd Font

      # URL detection and styling
      detect_urls yes
      url_style curly

      # Advanced mouse settings
      strip_trailing_spaces smart
      '';
   }; 
}
