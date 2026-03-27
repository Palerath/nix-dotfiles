{
  inputs,
  self,
  ...
}: {
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
}
