{
   programs.waybar = {
      enable = false;
      style = ./style.css;

      settings = {
         mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            modules-left = ["hyprland/workspaces"];
            modules-center = ["hyprland/window"];
            modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "clock" "tray"];

            "hyprland/workspaces" = {
               disable-scroll = true;
               show-special = true;
               special-visible-only = true;
               all-outputs = false;
               format = "{icon}";
               format-icons = {
                  "1" = "󰎦";
                  "2" = "󰎩";
                  "3" = "󰎬";
                  "4" = "󰎮";
                  "5" = "󰎰";
                  "6" = "󰎵";
                  "7" = "󰎸";
                  "8" = "󰎻";
                  "9" = "󰎽";
                  "10" = "󰽾";
                  "magic" = "";
               };
               persistent-workspaces = {
                  "*" = 9;
               };

               "hyprland/language" = {
                  format-en = "EN";
                  format-fr = "FR";
                  format-ja = "JA";
                  min-length = 5;
                  tooltip = false;
               };

               "custom/weather" = {
                  format = " {} ";
                  exec = "curl -s 'wttr.in/Rouen?format=%c%t'";
                  interval = 300;
                  class = "weather";
               };

               "pulseaudio" = {
                  format = "{icon} {volume}%";
                  format-muted = "";
                  format-icons = {
                     "default" = ["" ""];
                  };
                  on-click = "pavucontrol";
               };

               "clock" = {
                  format = "{:%Y-%M-%D | %H:%M}";
                  format-alt = "{:%A, %B %d at %R}";
               };

               "tray" = {
                  icon-size = 14;
                  spacing = 1;
               };
            };
         };
      };
   };
}
