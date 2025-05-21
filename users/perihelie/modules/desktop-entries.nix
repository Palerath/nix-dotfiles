{
   xdg.desktopEntries = {
      gamemode-status = {
         name = "GameMode Status";
         exec = "gamemoded -s";
         terminal = true;
         categories = [ "Game" "Utility" ];
         comment = "Check if GameMode is active";
      };

      nvidia-settings = {
         name = "NVIDIA X Server Settings";
         exec = "nvidia-settings";
         icon = "nvidia-settings";
         categories = [ "Settings" "HardwareSettings" ];
         comment = "Configure NVIDIA GPU settings";
      };
   };
}
