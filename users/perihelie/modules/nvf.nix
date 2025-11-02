{ pkgs, ... }: {

    programs.nvf = {
        enable = true;
        settings = {
            vim = {
                viAlias = false;
                vimAlias = true;

                theme = {
                    enable = true;
                    name = "everforest";
                    style = "hard";
                    transparent = true;
                };

                statusline.lualine.enable = true;
                telescope.enable = true;
                autocomplete.nvim-cmp.enable = true;

                enableLuaLoader = true;

                # Keybinding hints
                binds.whichKey.enable = true;

                # Toggle comment
                comments.comment-nvim.enable = true;

                # Git gutter
                git.gitsigns.enable = true;

                # Diagnostic list UI
                diagnostics.enable = true;

                # Auto-pairs and surround
                autopairs.nvim-autopairs.enable = true;
                utility.surround.enable = true;
                formatter.conform-nvim.enable = true;

                # Indent guides
                visuals.indent-blankline.enable = true;                                

                # Languages
                lsp.enable = true;
                lsp.trouble.enable = true;
                languages = {
                    enableTreesitter = true;
                    nix = {
                        enable = true;
                        extraDiagnostics.enable = true;
                    };
                    python.enable = true;
                    rust.enable = true;
                    clang.enable = true;
                    bash.enable = true;
                    css.enable = true;
                    html.enable = true;
                    java.enable = true;
                    lua.enable = true;
                    markdown.enable = true;
                    sql.enable = true;
                    ts.enable = true;
                    yaml.enable = true;
                };

                keymaps = [
                    { key = "<leader>fn"; mode = "n"; action = ":e %:p:h/"; }
                    { key = "<leader>o"; mode = "n"; action = "<CMD>Oil %:p:h<CR>"; }
                    # Telescope
                    { key = "<leader>ff"; mode = "n"; action = "<CMD>Telescope find_files<CR>"; }
                    { key = "<leader>fg"; mode = "n"; action = "<CMD>Telescope live_grep<CR>"; }
                    { key = "<leader>fb"; mode = "n"; action = "<CMD>Telescope buffers<CR>"; }
                    { key = "<leader>fh"; mode = "n"; action = "<CMD>Telescope help_tags<CR>"; }
                    {key = "<C-p>"; mode = "n"; action = "<CMD>Telescope find_files<CR>"; }
                    # Conform 
                    { key = "<leader>mp"; mode = "n"; action = "<CMD>lua require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 500 })<CR>"; }
                    { key = "<leader>mp"; mode = "v"; action = "<CMD>lua require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 500 })<CR>"; }
                    { key = "<leader>ci"; mode = "n"; action = "<CMD>ConformInfo<CR>"; }
                ];

                # Options
                options = {
                    clipboard = "unnamedplus";

                    tabstop = 4;
                    shiftwidth = 4;
                    expandtab= true;

                    number = true;
                    relativenumber = true;
                };

                # Startup
                startPlugins = [
                    pkgs.vimPlugins.nvim-tree-lua
                    pkgs.vimPlugins.oil-nvim
                ];
            };
        };
    };
}
