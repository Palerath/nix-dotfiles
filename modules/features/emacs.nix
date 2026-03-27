{
  self,
  inputs,
  ...
}: {
  flake.homeModules.emacs = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      emacs-all-the-icons-fonts

      gnutls
      imagemagick
      zstd
    ];

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;

      extraPackages = epkgs:
        with epkgs; [
          vterm
          pdf-tools
          tree-sitter-langs
          treesit-grammars.with-all-grammars
        ];
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      package = config.programs.emacs.package;
      startWithUserSession = "graphical";
      extraOptions = ["--init-directory=${config.xdg.configHome}/emacs"];
    };

    home.activation.doom = lib.hm.dag.entryAfter ["writeBoundary"] ''
      DOOM_DIR="${config.xdg.configHome}/emacs"
      EMACS_BIN="${config.programs.emacs.package}/bin/emacs"

      if [ -d "$DOOM_DIR" ]; then
        if [ -x "$DOOM_DIR/bin/doom" ]; then
          echo "Running doom sync..."
          # Set PATH to include Emacs and run doom sync
          PATH="$PATH:${config.programs.emacs.package}/bin" \
          $DOOM_DIR/bin/doom sync || {
            echo "Warning: doom sync failed, but continuing..."
            echo "You may need to run 'doom sync' manually after login"
          }
        else
          echo "Warning: Doom executable not found at $DOOM_DIR/bin/doom"
          echo "You may need to install Doom Emacs first with:"
          echo "  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs"
          echo "  ~/.config/emacs/bin/doom install"
        fi
      else
        echo "Doom Emacs not installed at $DOOM_DIR"
        echo "Install with:"
        echo "  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs"
        echo "  ~/.config/emacs/bin/doom install"
      fi
    '';

    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
    };
  };
}
