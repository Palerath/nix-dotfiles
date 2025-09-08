{config, pkgs, ...}:
{
   programs.mpv = {
      enable = true;

      package = (
         pkgs.mpv-unwrapped.wrapper {
            scripts = with pkgs.mpvScripts; [
               uosc
               sponsorblock
               mpvacious
            ];

            mpv = pkgs.mpv-unwrapped.override {
               waylandSupport = true;
            };
         }
      );

      config = {
         # source: https://kokomins.wordpress.com/2019/10/14/mpv-config-guide/

         profile="gpu-hq";
         gpu-api="vulkan";
         vo="gpu-next";

         # video
         deband="yes";
         #Default values are 1:64:16:48, for anime: 2:35:20:5, for DVD: 3:45:25:15, web: 4:60:30:30
         deband-iterations=6; # Range 1-16. Higher = better quality but more GPU usage. >5 is redundant.
         deband-threshold=35; # Range 0-4096. Deband strength.
         deband-range=20; # Range 1-64. Range of deband. Too high may destroy details.
         deband-grain=5; # Range 0-4096. Inject grain to cover up bad banding, higher value needed for poor sources.

         dither-depth="auto";

         scale="ewa_lanczossharp";
         dscale="mitchell";
         cscale="spline36"; # alternatively ewa_lanczossoft depending on preference

         # audio
         volume=100;
         volume-max=100;

         # subtitles
         alang = "jpn,jp,fra,fr,eng,en";
         slang = "eng,en,enUS,fra,fr,frFR";
         sub-auto="fuzzy";

         # UI
         keep-open="always"; # Prevents autoplay playlists. Set to 'yes' to autoload. Both "always" and "yes" prevents player from auto closing upon playback complete.
         reset-on-next-file="pause"; # Resumes playback when skip to next file

         window-scale=1; # Set video zoom factor. (High DPI screens want 1.5 or even 2)
         # autofit-larger=1920x1080 # Set max window size. Can also set something like "75%" to mean max window size is 75% of screen height/width
         # autofit-smaller=858x480 # Set min window size.

         # no-osd-bar; # Hide OSD bar when seeking.
         osd-duration=500; # Hide OSD text after x ms.
         osd-font="Yu Gothic Regular";
         #osd-font-size=24

         # Screenshots
         screenshot-template="%F %P";
         screenshot-format="png";
         screenshot-high-bit-depth="yes";
         # screenshot-png-compression=7 # Setting too high may lag the PC on weaker systems. Recommend 3 (weak systems) or 7.
         screenshot-directory="/home/perihelie/drives/hdd/Pictures/mpv/";

         # ytdlp
         # Default demuxer is 150/75 MB, note that this uses RAM so set a reasonable amount.
         demuxer-max-bytes=150000000; # 150MB, Max pre-load for network streams (1 MiB = 1048576 Bytes).
         demuxer-max-back-bytes=75000000; # 75MB, Max loaded video kept after playback.
         force-seekable="yes"; # Force stream to be seekable even if disabled.
         ytdl-format = "bestvideo+bestaudio";
         cache-default = 4000000;
      };

      scriptOpts = {
         mpvacious = {
            deck_name="MASTER::JP::SentenceMining::Imports";
            model_name="Japanese sentences+";
            sentence_field="SentKanji";
            secondary_field="SentEng";
            audio_field="SentAudio";
            image_field="Image";

            vocab_field="VocabKanji";
            vocab_audio_field="VocabAudio";

            use_ffmpeg="yes";
            autoclip_method="clipboard";
            snapshot_format="webp";
            snapshot_quality=65;

            audio_format="opus";
            opus_container="ogg";

         };
      };

   };

}
