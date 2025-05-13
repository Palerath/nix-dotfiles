{pkgs, ...}:
{
   programs.nvf = {

      enable = true;

      settings = {
         vim.viAlias = false;
         vim.vimAlias = true;

         vim.theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
            transparent = true;
         };

         vim.ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = true;
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

         vim.statusline.lualine = {
            enable = true;
            theme = "gruvbox";
         };

         vim.telescope.enable = true;

         vim.autocomplete = {
            enableSharedCmpSources = true;
            nvim-cmp = {
               enable = true;
               setupOpts = {
                  sourcePlugins = [
                     "cmp-path"
                     "cmp-treesitter"
                  ];
               };
            };
         };

         vim.treesitter = {
            enable = true;
            context.enable = true;
            highlight.enable = true;
            indent.enable = true;
            fold = true;
         };

         vim.git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = true;
            vim-fugitive.enable = true;
         };

         vim.projects.project-nvim.enable = true;
         vim.notify.nvim-notify.enable = false;

         vim.binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
         };

         vim.tabline.nvimBufferline.enable = true;
         vim.filetree.neo-tree.enable = true;
         vim.snippets.luasnip.enable = true;
         vim.autopairs.nvim-autopairs.enable = true;

         vim.lsp = {
            enable = true;
            inlayHints.enable = true;
            nvim-docs-view = {
               enable = true;
               # setupOpts = {};
            };
         };

         vim.languages = {
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
            css.enable = true;
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

            conceallevel = 2;
            concealcursor = "niv";
         };

         vim.utility = {
            diffview-nvim.enable = true;
            images.image-nvim.enable = true;
            icon-picker.enable = true;
            surround.enable = true;
            leetcode-nvim.enable = true;
            multicursors.enable = true;
            oil-nvim = {
               enable = true;
               setupOpts = {
                  default_file_explorer = true;
                  show_hidden = true;
               };
            };
         };

         vim.terminal = {
            toggleterm = {
               enable = true;
               lazygit.enable = true;
            };
         };

         vim.comments.comment-nvim.enable = true;

         vim.notes = {
            obsidian = {
               enable = true;
               setupOpts = {
                  completion.nvim_cmp = true;

                  workspaces = [
                     {
                        name = "Cocoon";
                        path = "/home/perihelie/drives/hdd/Documents/Cocoon";
                     }
                  ];
               };
            };
            mind-nvim.enable = true;
            todo-comments.enable = true;
         };

      };

   };

   home.packages = with pkgs; [ vimPlugins.plenary-nvim ];

}
