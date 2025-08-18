{
   home.file."fastfetch/logos/cirno.png" = {
      source = ./images/cirno.png;
   };

   programs.fastfetch = {
      enable = true;
      settings = {
         logo = {
            #  source = "cirno.png";
            source = "/home/perihelie/.config/fastfetch/logos/cirno.png";
            type = "kitty-direct";
            height = 20;
            width = 40;

            padding=  { right = 2; };
         };

         modules = [ 
            "title"
            "separator"
            "shell"
            "uptime"
            "packages"
            "kernel"
            "os"
            "cpu"
            "gpu"
            "display"
            "memory"
            "swap"
            "disk"
         ];

      };
   };
}
