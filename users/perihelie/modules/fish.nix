{pkgs, ...}:

let
   sharedAliases = import ./shared-aliases.nix { };
in
   {
   home.packages = with pkgs; [
      fish
      fishPlugins.tide          # Modern Fish prompt (similar to agnoster)
      fishPlugins.fzf-fish      # Enhanced completions
      fishPlugins.autopair      # Auto-close brackets/quotes
   ];

   programs.fish = {
      enable = true;
      shellInit = ''
         fastfetch
      '';

      # Import shared aliases
      shellAliases = sharedAliases.shellAliases;

      plugins = [
         # Sudo functionality (press ESC twice to add sudo)
         {
            name = "bang-bang";
            src = pkgs.fishPlugins.bang-bang.src;
         }
      ];
   };

   programs.fish.interactiveShellInit = ''
      # Disable command-not-found to avoid database errors
      set -e fish_command_not_found_handler

      tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=No
   '';
}
