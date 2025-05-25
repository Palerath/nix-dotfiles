{pkgs, ...}:
let
   sharedAliases = import ./shared-aliases.nix { };
in
   {
   home.packages = with pkgs; [
      nushell
      carapace  # Enhanced completions for nushell
      oh-my-posh  # Cross-shell prompt engine with agnoster theme
   ];

   programs.nushell = {
      enable = true;

      # Shell aliases
      shellAliases = sharedAliases.shellAliases;

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
            edit_mode: vim
            shell_integration: true
            render_right_prompt_on_last_line: false
         }

         # Carapace completions
         $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
         let carapace_completer = {|spans|
            carapace $spans.0 nushell $spans | from json
         }

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

         # Oh My Posh with agnoster theme
         $env.PROMPT_COMMAND = { || oh-my-posh print primary --shell=nu }
         $env.PROMPT_COMMAND_RIGHT = { || oh-my-posh print right --shell=nu }
         $env.PROMPT_INDICATOR = ""
         $env.PROMPT_INDICATOR_VI_INSERT = ": "
         $env.PROMPT_INDICATOR_VI_NORMAL = "〉"
         $env.PROMPT_MULTILINE_INDICATOR = "::: "

         # Run fastfetch on startup
         fastfetch
      '';
   };

   # Oh My Posh with agnoster theme
   programs.oh-my-posh = {
      enable = true;
      useTheme = "agnoster";
   };
}
