{ pkgs, ... }:

{
    programs.vim = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
            tokyonight-nvim
            fzf-vim
            lightline-vim
            vim-lsp
        ];

        extraConfig = ''
      " Options
      set number
      set relativenumber

      filetype plugin indent on
      set expandtab
      set shiftwidth=4
      set softtabstop=4
      set tabstop=4
      set smartindent

      set backspace=indent,eol,start

      syntax on

      " Keybinds
      let mapleader = " "

      nnoremap <leader>cd :Ex<CR>

      " Colors
      set termguicolors
      let g:tokyonight_enable_italic = 1
      colorscheme tokyonight

      set laststatus=2
      let g:lightline = {'colorscheme' : 'tokyonight'}

      " FZF
      nnoremap <leader>ff :Files<CR>
      nnoremap <leader>fo :History<CR>
      nnoremap <leader>fb :Buffers<CR>

      nnoremap <leader>fg :Rg<Space>

      " LSP Configuration
      " Enable diagnostics highlighting
      let lspOpts = #{autoHighlightDiags: v:true}
      autocmd User LspSetup call LspOptionsSet(lspOpts)
      let lspServers = [
            \ #{
            \   name: 'rust-analyzer',
            \   filetype: ['rust'],
            \   path: 'rust-analyzer',
            \   args: []
            \ }
            \ ]

      autocmd User LspSetup call LspAddServer(lspServers)

      " LSP Key mappings
      nnoremap gd :LspGotoDefinition<CR>
      nnoremap gr :LspShowReferences<CR>
      nnoremap K  :LspHover<CR>
      nnoremap gl :LspDiag current<CR>
      nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
      nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
      inoremap <silent> <C-Space> <C-x><C-o>

      " Set omnifunc for completion
      autocmd FileType rust setlocal omnifunc=lsp#complete

      " Custom diagnostic sign characters
      autocmd User LspSetup call LspOptionsSet(#{
          \   diagSignErrorText: '✘',
          \   diagSignWarningText: '▲',
          \   diagSignInfoText: '»',
          \   diagSignHintText: '⚑',
          \ })
        '';
    };

    # Install additional tools needed for the setup
    home.packages = with pkgs; [
        fzf
        ripgrep  
        rust-analyzer
    ];
}
