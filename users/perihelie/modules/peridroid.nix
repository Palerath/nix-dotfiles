{pkgs, ...}:
{
   home.packages = with pkgs; [
      scrcpy
   ];

   systemd.user.services.waydroid-session = {
      Unit = {
         Description = "Waydroid Session";
         After = [ "graphical-session-pre.target" ];
         PartOf = [ "graphical-session.target" ];
      };

      Service = {
         Type = "simple";
         ExecStartPre = "${pkgs.systemd}/bin/systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
         ExecStart = "${pkgs.waydroid}/bin/waydroid session start";
         ExecStop = "${pkgs.waydroid}/bin/waydroid session stop";
         Restart = "on-failure";
      };

      Install = {
         WantedBy = [ "graphical-session.target" ];
      };
   };
}
