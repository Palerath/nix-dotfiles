{
   home.file."fastfetch/logos/custom.png" = {
      source = "./images/73712874.png";
   };

   programs.fastfetch = {
      enable = true;
      settings = {
         logo = {
            source = "custom.png";
            type = "file";
            padding = { right = 2; };
         };
      };
   };
}
