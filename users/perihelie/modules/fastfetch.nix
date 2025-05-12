{
   home.file."fastfetch/logos/cirno.png" = {
      source = ./images/cirno.png;
   };

   programs.fastfetch = {
      enable = true;
      imageSupport = true;

      settings = {
         logo = {
            source = "cirno_diffusion.txt";
            type = "data-raw";
            width = 80;
            height = 40;
         };
         
      };
   };
}
