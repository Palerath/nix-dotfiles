{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      vlc
   ];

   programs.nh = {
      enable = true;
   };
}
