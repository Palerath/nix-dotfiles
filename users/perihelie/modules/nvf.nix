{
   programs.nvf = {
      enable = true;
      settings = {
         vim.viAlias = false;
         vim.vimAlias = true;
         vim.lsp = {
            enable = true;
         };

         vim.theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
         };

         vim.statusline.lualine.enable = true;
         vim.telescope.enable = true;
         vim.autocomplete.nvim-cmp.enable = true;

         vim.git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false;
         };

         vim.projects.project-nvim.enable = true;
         vim.notify.nvim-notify.enable = true;

         vim.binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
         };

         vim.tabline.nvimBufferline.enable = true;
         vim.filetree.neo-tree.enable = true;
         vim.snippets.luasnip.enable = true;
         vim.autopairs.nvim-autopairs.enable = true;

         vim.treesitter.indent.enable = true;
         vim.treesitter.context.enable = true;
         vim.treesitter.highlight.enable = true;

         vim.languages = {
            enableLSP = true;
            enableTreesitter = true;

            nix.enable = true;
            ts.enable = true;
            rust.enable = true;
            rust.lsp.opts = '' 
               ['rust-analyzer'] = {
                  cargo = {allFeature = true},
                  checkOnSave = true,
                  procMacro = {
                     enable = true
                  },
               },
               '';

            python.enable = true;
            lua.enable = true;
            markdown.enable = true;
            html.enable = true;
            java.enable = true;
            sql.enable = true;
            yaml.enable = true;
         };

         vim.options = {
            clipboard = "unnamedplus";

            autoindent = true;
            smartindent = true;
            cindent = true;

            tabstop = 3;
            shiftwidth = 3;
            softtabstop = 3;
            expandtab = true;
         };

         vim.utility = {
            diffview-nvim.enable = true;
            images.image-nvim.enable = true;
            icon-picker.enable = true;
            surround.enable = true;
            leetcode-nvim.enable = true;
            multicursors.enable = true;
         };

         vim.terminal = {
            toggleterm = {
               enable = true;
               lazygit.enable = true;
            };
         };

         vim.notes = {
            obsidian = {
               enable = false;
               setupOpts = {
                  completion.nvim_cmp = true;
               };
            };
            mind-nvim.enable = true;
            todo-comments.enable = true;
         };

         vim.ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = false;
            illuminate.enable = true;
            breadcrumbs = {
               enable = true;
               navbuddy.enable = true;
            };
            smartcolumn = {
               enable = true;
               setupOpts.custom_colorcolumn = {
                  nix = "110";
               };
            };
            fastaction.enable = true;
         };
         vim.visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            nvim-cursorline.enable = true;
            cinnamon-nvim.enable = true;
            fidget-nvim.enable = true;

            highlight-undo.enable = true;
            indent-blankline.enable = true;

            cellular-automaton.enable = true;
         };

         vim.comments.comment-nvim.enable = true;
      };

   };

}
