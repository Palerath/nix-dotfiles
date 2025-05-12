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
      swww
   ];  

   environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
   }; 

   xdg.portal.config.hyprland.default = [ "hyprland" "gtk" ];
   systemd.user.services.xdg-desktop-portal-hyprland.enable = true;
}
