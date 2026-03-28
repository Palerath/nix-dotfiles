{
  inputs,
  self,
  ...
}: {
  flake.homeModules.cliTextEditors = {pkgs, ...}: {
    home.packages = with pkgs; [
      # LSPs
      lua-language-server
      pyright
      rust-analyzer
      clang-tools
      alejandra
      nil
      marksman
      python3Packages.python-lsp-server
      yamlfmt
    ];

    imports = [
      self.homeModules.helix
      self.homeModules.nvim
      # self.homeModules.emacs
    ];
  };
  flake.homeModules.helix = {pkgs, ...}: {
    home.sessionVariables.EDITOR = "hx";

    programs.helix = {
      enable = true;
      package = pkgs.evil-helix;
      settings = {
        theme = "autumn_night_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages = {
        language-server = {
          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
          };
          ruff = {
            command = "${pkgs.ruff}/bin/ruff";
            args = ["server"];
          };
          bash-language-server = {
            command = "${pkgs.bash-language-server}/bin/bash-language-server";
            args = ["start"];
          };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
          vscode-html-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
            args = ["--stdio"];
          };
          vscode-css-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            args = ["--stdio"];
          };
          vscode-json-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
            args = ["--stdio"];
          };
          typescript-language-server = {
            command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          };
          yaml-language-server = {
            command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            args = ["--stdio"];
          };
          taplo = {
            command = "${pkgs.taplo}/bin/taplo";
            args = ["lsp" "stdio"];
          };
          marksman = {
            command = "${pkgs.marksman}/bin/marksman";
            args = ["server"];
          };
          clangd = {
            command = "${pkgs.clang-tools}/bin/clangd";
          };
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            language-servers = ["nil"];
          }
          {
            name = "python";
            auto-format = true;
            language-servers = ["pyright" "ruff"];
          }
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
              args = ["-"];
            };
            language-servers = ["bash-language-server"];
          }
          {
            name = "rust";
            auto-format = true;
            language-servers = ["rust-analyzer"];
          }
          {
            name = "html";
            auto-format = true;
            language-servers = ["vscode-html-language-server"];
          }
          {
            name = "css";
            auto-format = true;
            language-servers = ["vscode-css-language-server"];
          }
          {
            name = "json";
            auto-format = true;
            language-servers = ["vscode-json-language-server"];
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = ["typescript-language-server"];
          }
          {
            name = "javascript";
            auto-format = true;
            language-servers = ["typescript-language-server"];
          }
          {
            name = "yaml";
            auto-format = true;
            language-servers = ["yaml-language-server"];
          }
          {
            name = "toml";
            auto-format = true;
            language-servers = ["taplo"];
          }
          {
            name = "markdown";
            language-servers = ["marksman"];
          }
          {
            name = "c";
            auto-format = true;
            language-servers = ["clangd"];
          }
          {
            name = "cpp";
            auto-format = true;
            language-servers = ["clangd"];
          }
        ];
      };

      themes = {
        autumn_night_transparent = {
          "inherits" = "kanagawa";
          "ui.background" = {};
        };
      };
    };
  };
  flake.homeModules.nvim = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      tree-sitter
      vimPlugins.nvim-treesitter-parsers.xml
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = false;
      viAlias = true;
      vimAlias = false;
    };

    home.activation.nvimConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
      rm -rf ${config.home.homeDirectory}/.config/nvim
      ln -sf ${self.outPath}/users/perihelie/perihelie-modules/nvim ${config.home.homeDirectory}/.config/nvim
    '';
  };
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
