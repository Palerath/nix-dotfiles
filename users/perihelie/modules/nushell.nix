{pkgs, ...}:
{
   home.packages = with pkgs; [
      nushell
      carapace  # Enhanced completions for nushell
   ];

   # Set Nushell as the default shell
   users.users.perihelie.shell = pkgs.nushell;

   programs.nushell = {
      enable = true;

      # Shell aliases
      shellAliases =
         let
            flakePath = "/home/perihelie/dotfiles";
         in{
            rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
            hms = "home-manager switch --flake ${flakePath}";
         };

      # Nushell configuration
      configFile.text = ''
         # Nushell config
         $env.config = {
            show_banner: false
            completions: {
               case_sensitive: false
               quick: true
               partial: true
               algorithm: "fuzzy"
               external: {
                  enable: true
                  max_results: 100
                  completer: $carapace_completer
               }
            }
            history: {
               max_size: 100_000
               sync_on_enter: true
               file_format: "sqlite"
            }
            filesize: {
               metric: false
               format: "auto"
            }
            cursor_shape: {
               vi_insert: line
               vi_normal: block
            }
            color_config: $dark_theme
            use_grid_icons: true
            footer_mode: 25
            float_precision: 2
            buffer_editor: ""
            use_ansi_coloring: true
            bracketed_paste: true
            edit_mode: emacs
            shell_integration: true
            render_right_prompt_on_last_line: false
         }

         # Carapace completions
         $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
         let carapace_completer = {|spans|
            carapace $spans.0 nushell $spans | from json
         }

         # Git-related aliases and functions
         alias g = git
         alias ga = git add
         alias gc = git commit
         alias gco = git checkout
         alias gd = git diff
         alias gl = git log
         alias gp = git push
         alias gpl = git pull
         alias gs = git status
         alias gb = git branch

         # Sudo functionality
         def sudo-last [] {
            let last_cmd = (history | last | get command)
            sudo nu -c $last_cmd
         }
         alias !! = sudo-last
      '';

      # Environment file
      envFile.text = ''
         # Nushell environment config

         # Starship prompt
         $env.STARSHIP_SHELL = "nu"

         def create_left_prompt [] {
            starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
         }

         def create_right_prompt [] {
            starship prompt --right --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
         }

         $env.PROMPT_COMMAND = { || create_left_prompt }
         $env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }
         $env.PROMPT_INDICATOR = ""
         $env.PROMPT_INDICATOR_VI_INSERT = ": "
         $env.PROMPT_INDICATOR_VI_NORMAL = "〉"
         $env.PROMPT_MULTILINE_INDICATOR = "::: "

         # Run fastfetch on startup
         fastfetch
      '';
   };

   # Starship prompt (similar to agnoster theme)
   programs.starship = {
      enable = true;
      settings = {
         format = "$all$character";
         add_newline = false;

         character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
         };

         git_branch = {
            symbol = "⎇ ";
            format = "[$symbol$branch]($style) ";
         };

         git_status = {
            conflicted = "⚡";
            ahead = "⇡";
            behind = "⇣";
            diverged = "⇕";
            untracked = "?";
            stashed = "$";
            modified = "!";
            staged = "+";
            renamed = "»";
            deleted = "✘";
         };

         directory = {
            truncation_length = 3;
            truncate_to_repo = true;
         };
      };
   };
}
