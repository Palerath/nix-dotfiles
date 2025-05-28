{pkgs, ...}:
let
   sharedAliases = import ./shared-aliases.nix { };
   # Function to generate Nushell alias lines
   nushellAliases = builtins.concatStringsSep "\n" (
      builtins.attrValues (
         builtins.mapAttrs (name: value: "alias ${name} = ${value}") sharedAliases.shellAliases
      )
   );
in
   {
   home.packages = with pkgs; [
      nushell
      carapace  # Enhanced completions for nushell
   ];

   programs.nushell = {
      enable = true;

      # Shell aliases
      shellAliases = sharedAliases.shellAliases;

      extraConfig = ''
      # Direct alias integration
         ${nushellAliases}

      # fastfetch
      fastfetch

      # Core environment settings
      $env.config = {
        show_banner: false
        completions: {
          algorithm: "fuzzy"
          case_sensitive: false
          quick: true
          partial: true
        }
      edit_mode: "vi"
      }
      '';

   };

   programs.eza.enableNushellIntegration = true;
   programs.carapace.enableNushellIntegration = true;

}
