{
   home.file."fastfetch/logos/cirno.png" = {
      source = ./images/cirno.png;
   };

   programs.fastfetch = {
      enable = true;
      settings = {
         logo = {
            source = "cirno.png";
            type = "kitty-gfx";
            padding = { right = 2; };
         };
      };
   };
}
