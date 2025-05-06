{config, pkgs}:
{
   home.packages = [pkgs.mpv];

   programs.mpv = {
      enable = true;

      package = with pkgs; (
         mpv-unwrapped.wrapper {
            scripts = with mpvScripts; [
               uosc
               sponsorblock
            ];

            mpv = mpv-unwrapped.override {
               waylandSupport = true;
            };

         };
      );

      config = {
         profile = "high-quality";
         ytdl-format = "bestvideo+bestaudio";
         cache-default = 4000000;
      };

   };
}
