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
                };

                # Options
                options = {
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
