{pkgs, ...}: {
      programs.nvf = {
         enable = true;
         settings.vim = {
            theme = { enable = true; name = "gruvbox"; style="dark"; };
            options.termguicolors = true;
     # Visual highlight fix
            luaConfigRC.force-visual = ''
               vim.defer_fn(function()
                  vim.api.nvim_set_hl(0, 'Visual', { 
                     bg = '#fe8019',
                     fg = '#282828',
                     bold = true 
                  })
               end, 100)
            '';
         };
      };
   }
