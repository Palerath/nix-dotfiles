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
                  markdown = "80";
                  yaml = "80";
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

         vim.telescope = {
            enable = true;
            setupOpts = {
               defaults = {
                  layout_strategy = "horizontal";
                  layout_config = {
                     horizontal = {
                        preview_width = 0.6;
                     };
                     vertical = {
                        mirror = false;
                     };
                     width = 0.87;
                     height = 0.80;
                     preview_cutoff = 120;
                  };
                  # file_previewer = "require('telescope.previewers').vim_buffer_cat.new";
                  # grep_previewer = "require('telescope.previewers').vim_buffer_vimgrep.new";
                  # qflist_previewer = "require('telescope.previewers').vim_buffer_qflist.new";
               };
               pickers = {
                  find_files = {
                     theme = "dropdown";
                     previewer = true;
                  };
                  live_grep = {
                     theme = "ivy";
                     previewer = true;
                  };
                  buffers = {
                     theme = "dropdown";
                     previewer = true;
                     sort_lastused = true;
                     sort_mru = true;
                  };
               };
            };
         };

         vim.autocomplete = {
            enableSharedCmpSources = true;
            nvim-cmp = {
               enable = true;
               setupOpts = {
                  sourcePlugins = [
                     "cmp-path"
                     "cmp-treesitter"
                     "cmp-buffer"
                     "cmp-nvim-lsp"
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
         vim.notify.nvim-notify.enable = true;

         vim.binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
            hardtime-nvim.enable = false;
         };

         vim.keymaps = [
            {
               key = "<leader>o";
               mode = "n";
               action = "<CMD>Oil %:p:h<CR>";
            }
            {
               key = "<leader>ff";
               mode = "n"; 
               action = "<CMD>Telescope find_files<CR>";
            }
            {
               key = "<leader>fg";
               mode = "n";
               action = "<CMD>Telescope live_grep<CR>";
            }
            {
               key = "<leader>fb";
               mode = "n";
               action = "<CMD>Telescope buffers<CR>";
            }
            {
               key = "<leader>fh";
               mode = "n";
               action = "<CMD>Telescope help_tags<CR>";
            }
            {
               key = "<leader>fn";
               mode = "n";
               action = ":e %:p:h/";
            }
            # Quick file navigation
            {
               key = "<C-p>";
               mode = "n";
               action = "<CMD>Telescope find_files<CR>";
            }
         ];

         vim.tabline.nvimBufferline.enable = true;
         vim.snippets.luasnip.enable = true;
         vim.autopairs.nvim-autopairs.enable = true;

         vim.lsp = {
            enable = true;
            inlayHints.enable = true;
            nvim-docs-view = {
               enable = true;
            };
         };

         vim.languages = {
            enableTreesitter = true;

            nix.enable = true;
            ts.enable = true;
            rust.enable = true;
            rust.lsp.opts = '' 
               ['rust-analyzer'] = {
                  cargo = {allFeatures = true},
                  checkOnSave = true,
                  procMacro = {
                     enable = true
                  },
                  inlayHints = {
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

            # Better search
            ignorecase = true;
            smartcase = true;
            hlsearch = true;
            incsearch = true;

            # Better editing experience
            number = true;
            relativenumber = true;
            signcolumn = "yes";
            wrap = false;
            scrolloff = 8;
            sidescrolloff = 8;

            # Better performance
            updatetime = 50;
            timeoutlen = 300;
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
                  columns = [ "icon" "size" "mtime" ];
               };
            };
            preview.glow.enable = true; 
         };

         vim.filetree.neo-tree = {

            enable = true;

            setupOpts = {
               close_if_last_window = false;
               enable_git_status = true;
               enable_diagnostic = true;
               sort_case_insensitive = false;
               default_component_configs = {
                  container = {
                     enable_character_fade = true;
                  };
                  window = {
                     position = "right";
                     width = 50;
                  };
                  filesystem = {
                     filtered_items = {
                        visible = false;
                        hide_dotfiles = false;
                        hide_gitignored = false;
                        hide_hidden = false;
                     };
                     follow_current_file = true;
                     group_empty_dirs = true;
                     hijack_netrw_behavior = "open_default";
                     use_libuv_file_watcher = false;
                  };
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
               enable = false; 
               setupOpts = {
                  completion.nvim_cmp = false;

                  workspaces = [
                     {
                        name = "Cocoon";
                        path = "/home/perihelie/drives/hdd/Documents/Cocoon";
                     }
                  ];

                  daily_notes = {
                     date_format = "%Y-%M-%D";
                     folder = "500 - Journal/501 - Dailies";
                     template = "Daily template";
                  };

                  templates = {
                     folder = "Templates";
                  };
               };

            };

            mind-nvim.enable = true;
            todo-comments.enable = true;

         };
      };
   };

   home.packages = with pkgs; [ vimPlugins.plenary-nvim ];

}
