{ config, pkgs, ... }:

let
    vimConfigDir = ./vim/.; # Points to the vim/ directory
in
    {
    environment.systemPackages = with pkgs; [
        vim-full
        fzf
        ripgrep
        rust-analyzer
    ];

    # Use environment.etc to link the config files from the Nix store
    environment.etc = {
        "xdg/vim/vimrc".source = "${vimConfigDir}/vimrc";
        "xdg/vim/options.vim".source = "${vimConfigDir}/options.vim";
        "xdg/vim/keybinds.vim".source = "${vimConfigDir}/keybinds.vim";
        "xdg/vim/plugins.vim".source = "${vimConfigDir}/plugins.vim";
        "xdg/vim/colors.vim".source = "${vimConfigDir}/colors.vim";
        "xdg/vim/fzf.vim".source = "${vimConfigDir}/fzf.vim";
        "xdg/vim/lsp.vim".source = "${vimConfigDir}/lsp.vim";
    };

    # Set vim as the default editor
    environment.variables = {
        EDITOR = "vim";
        VISUAL = "vim";
    };

    # Activation script to symlink config to user home directories
    system.userActivationScripts.vimConfig = ''
    if [ ! -d "$HOME/.vim" ]; then
      mkdir -p "$HOME/.vim"
    fi

    # Symlink all config files
    ln -sf /etc/xdg/vim/vimrc "$HOME/.vimrc"
    ln -sf /etc/xdg/vim/options.vim "$HOME/.vim/options.vim"
    ln -sf /etc/xdg/vim/keybinds.vim "$HOME/.vim/keybinds.vim"
    ln -sf /etc/xdg/vim/plugins.vim "$HOME/.vim/plugins.vim"
    ln -sf /etc/xdg/vim/colors.vim "$HOME/.vim/colors.vim"
    ln -sf /etc/xdg/vim/fzf.vim "$HOME/.vim/fzf.vim"
    ln -sf /etc/xdg/vim/lsp.vim "$HOME/.vim/lsp.vim"

    # Update vimrc to point to the correct locations
    mkdir -p "$HOME/.vim/plugged"
    '';
}
