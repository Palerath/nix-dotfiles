{
   home.file."fastfetch/logos/cirno.png" = {
      source = /."" + toString ./images/cirno.png;
   };

   programs.fastfetch = {
      enable = true;
      settings = {
         logo = {
            source = "cirno.png";
            type = "file";
            padding = { right = 2; };
         };
      };
   };
}
