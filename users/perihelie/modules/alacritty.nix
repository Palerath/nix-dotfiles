{pkgs,...}:
{
   home.packages = with pkgs; [
      alacritty
      nerd-fonts.iosevka
   ];

   programs.alacritty = {
      enable = true;
      settings = {
         font = {
            size = 14;
            normal = {
               family = "Iosevka Nerd Font";
               style = "Regular";
            };
            bold = {
               family = "Iosevka Nerd Font";
               style = "Bold";
            };
            italic = {
               family = "Iosevka Nerd Font";
               style = "Italic";
            };
            bold_italic = {
               family = "Iosevka Nerd Font";
               style = "Bold Italic";
            };
         };


      };

   };
}
