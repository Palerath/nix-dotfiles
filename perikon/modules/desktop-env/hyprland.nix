{pkgs, ...}: {
   programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true; # recommended for most users
      #  environment.systemPackages = with pkgs; [];  
   };

   xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
   };
}
