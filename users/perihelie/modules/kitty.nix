{
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
         # background_blur = 1;
      };

      enableGitIntegration = true;

      shellIntegration = {
         enableBashIntegration  = true;
         enableFishIntegration = true;
         enableZshIntegration = true;
      };
   };
}
