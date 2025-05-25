{pkgs, ...}:
{
   home.packages = with pkgs; [
      fish
      fishPlugins.tide          # Modern Fish prompt (similar to agnoster)
      fishPlugins.fzf-fish      # Enhanced completions
      fishPlugins.autopair      # Auto-close brackets/quotes
   ];

   programs.fish = {
      enable = true;

      shellAliases =
         let
            flakePath = "/home/perihelie/dotfiles";
         in{
            rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
            hms = "home-manager switch --flake ${flakePath}";
         };

      shellInit = ''
         fastfetch
      '';

      plugins = [
         # Git-related functionality (equivalent to oh-my-zsh git plugin)
         {
            name = "git";
            src = pkgs.fishPlugins.git.src;
         }
         # Sudo functionality (press ESC twice to add sudo)
         {
            name = "bang-bang";
            src = pkgs.fishPlugins.bang-bang.src;
         }
      ];
   };

   # Configure Tide prompt (modern alternative to agnoster)
   programs.fish.interactiveShellInit = ''
      # Tide prompt configuration
      tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=No
   '';
}