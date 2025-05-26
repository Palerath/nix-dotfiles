# shared-aliases.nix
{ ... }:
let
   flakePath = "/home/perihelie/dotfiles";
   aliases = {
      rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
      hms = "home-manager switch --flake ${flakePath}";

      # Git aliases
      g = "git";
      ga = "git add *";
      gc = "git commit -am";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gb = "git branch";

      # Common system aliases
      ls = "eza";
      ll = "eza -la";
      la = "eza -la";
      l = "eza -l";
      ".." = "z ..";
      "..." = "z ../..";

      # virt-manager
      android-vm = "virt-manager";
      adb-connect = "adb connect localhost:5555";
   };

   # Convert aliases to Nushell format
   toNushellAlias = name: value: 
      if builtins.hasInfix flakePath value then
         # Handle string interpolation for paths - use proper Nushell syntax
         let
            interpolated = builtins.replaceStrings [flakePath] ["\" + $flakePath + \""] value;
         in
            "alias ${name} = \"${interpolated}\""
      else
         # Simple alias - no quotes needed for simple commands
         "alias ${name} = ${value}";

   nushellAliases = builtins.concatStringsSep "\n" 
      (builtins.attrValues (builtins.mapAttrs toNushellAlias aliases));

in
   {

   # For traditional shells (zsh, fish, bash)
   shellAliases = aliases;

   # For Nushell
   nushellConfig = ''
   # Shared aliases
   let flakePath = "${flakePath}"

      ${nushellAliases}
   '';
}
