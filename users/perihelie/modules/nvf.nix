{ pkgs, lib, ... }: {

   programs.nvf = {
      enable = true;
      setting = {
         vim = {
            theme = {
               enable = true;
               name = "tokyonight";
               style = "night";
            };
            statusline.lualine.enable = true;
            telescope.enable = true;
            autocomplete.nvim-cmp.enable = true;
            languages = {
               enableLSP = true;
               enableTreesitter = true;
               nix.enable = true;
               python.enable = true;
               rust.enable = true;
               c.enable = true;
            };
            startPlugins = [
               pkgs.vimPlugins.nvim-tree-lua
               pkgs.vimPlugins.oil-nvim
            ];
         };
      };
   };
}
