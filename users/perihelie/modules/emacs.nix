{config, pkgs, lib, ...}:
{
   home.packages = with pkgs; [
      emacs-all-the-icons-fonts

      #LSPs
      nil
      rust-analyzer
      python3Packages.python-lsp-server
      nodePackages.typescript-language-server
   ];

   home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
   };

   programs.emacs = {
      enable = false;
   };

   home.activation.doom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${config.xdg.configHome}/emacs/bin/doom" ]; then
         echo "Running doom sync..."
         ${config.xdg.configHome}/emacs/bin/doom sync
      fi
   '';

   fonts.fontconfig.enable = true;
}
