{pkgs, ...}: {
      programs.nvf = {
         enable = true;
         settings.vim = {
            theme = { enable = true; name = "gruvbox"; };
            options.termguicolors = true;
         };
      };
   }
