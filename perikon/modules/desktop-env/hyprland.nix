{pkgs, inputs, ...}: 
{
   programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
      withUWSM = true; 
   };

   environment.systemPackages = with pkgs; [
      (waybar.overrideAttrs (oldAttrs: {
         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
      )
      eww
      dunst
      libnotify
      rofi-wayland
   ];  

   environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
   }; 

   xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
   };
}
