{
  self,
  inputs,
  ...
}: {
  flake.homeModules.wallpapers = {
    pkgs,
    config,
    ...
  }: let
    wallpaperDir = "${config.home.homeDirectory}/drives/data/Pictures/Wallpapers";
    screensaverDir = "${config.home.homeDirectory}/drives/data/Pictures/Screensavers";

    setWallpaper = pkgs.writeShellScriptBin "set-wallpaper" ''
      FILE="$1"
      AUDIO_FLAG="$2"

      if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        echo "set-wallpaper: file not found or empty: $FILE"
        exit 1
      fi

      ext="''${FILE##*.}"
      ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

      case "$ext" in
        mp4|webm|mkv|gif)
          pkill swaybg || true
          pkill mpvpaper || true
          sleep 0.1

          MPV_OPTS="loop panscan=1.0 background=0/0/0 input-ipc-server=/tmp/mpv-wallpaper.sock"

          if [ "$AUDIO_FLAG" = "--audio" ]; then
            MPV_OPTS="mute=no $MPV_OPTS"
          else
            MPV_OPTS="mute=yes $MPV_OPTS"
          fi

          ${pkgs.mpvpaper}/bin/mpvpaper -o "$MPV_OPTS" '*' "$FILE" &
          ;;
        *)
          pkill mpvpaper || true
          pkill swaybg || true
          ${pkgs.swaybg}/bin/swaybg -i "$FILE" -m fill &
          ;;
      esac
    '';

    randomWallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
      TYPE="$1"

      if [ ! -d "${wallpaperDir}" ]; then
        echo "random-wallpaper: wallpaper directory not available"
        exit 1
      fi

      if [ "$TYPE" = "--image" ]; then
      # Images only
        RANDOM_WALLPAPER=$(find "${wallpaperDir}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | shuf -n 1)
      elif [ "$TYPE" = "--gif" ]; then
      # Gifs only
        RANDOM_WALLPAPER=$(find "${wallpaperDir}" -type f -iname "*.gif" 2>/dev/null | shuf -n 1)
      elif [ "$TYPE" = "--video" ] || [ "$TYPE" = "--video-audio" ]; then
      # Videos only
        RANDOM_WALLPAPER=$(find "${wallpaperDir}" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) 2>/dev/null | shuf -n 1)
      else
      # ALL only
        RANDOM_WALLPAPER=$(find "${wallpaperDir}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) 2>/dev/null | shuf -n 1)
      fi

      if [ -z "$RANDOM_WALLPAPER" ]; then
        echo "random-wallpaper: no files found in ${wallpaperDir} for type $TYPE"
        exit 1
      fi

      if [ "$TYPE" = "--video-audio" ]; then
        ${setWallpaper}/bin/set-wallpaper "$RANDOM_WALLPAPER" --audio
      else
        ${setWallpaper}/bin/set-wallpaper "$RANDOM_WALLPAPER"
      fi
    '';

    toggleWallpaperAudio = pkgs.writeShellScriptBin "toggle-wallpaper-audio" ''
      if [ -S /tmp/mpv-wallpaper.sock ]; then
        echo '{ "command": ["cycle", "mute"] }' | ${pkgs.socat}/bin/socat - /tmp/mpv-wallpaper.sock
      else
        echo "No mpv IPC socket found. Is a video wallpaper playing?"
      fi
    '';

    hyprlock-img = pkgs.writeShellScript "hyprlock-img" ''
      IMG=$(find -L "${screensaverDir}" \
        -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
        2>/dev/null | shuf -n 1)

      OUT="/tmp/hyprlock-wallpaper.png"

      ${pkgs.imagemagick}/bin/convert "$IMG" \
        -background black \
        -gravity center \
        -resize 2560x1440 \
        -extent 2560x1440 \
        "$OUT"

      echo "$OUT"
    '';
  in {
    home.packages = [
      pkgs.mpvpaper
      pkgs.swaybg
      pkgs.waypaper
      pkgs.imagemagick
      pkgs.socat
      setWallpaper
      randomWallpaper
      toggleWallpaperAudio
    ];

    # Waypaper configuration
    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      folder = ${wallpaperDir}
      monitors = All
      backend = mpvpaper
      # Updated mpvpaper options to integrate with the toggle script
      mpvpaper_options = mute=yes loop panscan=1.0 background=0/0/0 input-ipc-server=/tmp/mpv-wallpaper.sock
      fill = fill
      sort = name
      subfolders = True
      all_subfolders = True
      show_hidden = True
      number_of_columns = 3
      post_command = ${setWallpaper}/bin/set-wallpaper $WAYPAPER_WALLPAPER
    '';

    # Daily wallpaper rotation service
    systemd.user.services.wallpaper-rotation = {
      Unit = {
        Description = "Rotate wallpapers automatically";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = "${randomWallpaper}/bin/random-wallpaper";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };
        background = [
          {
            color = "rgba(202020ff)";
            path = "cmd[${hyprlock-img}]";
            reload_time = 10;
            reload_cmd = "${hyprlock-img}";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            outline_thickness = 2;
            outer_color = "rgba(9b8d7fff)";
            inner_color = "rgba(202020ff)";
            font_color = "rgba(9b8d7fff)";
            check_color = "rgba(9b8d7fff)";
            fail_color = "rgba(ff5555ff)";
            placeholder_text = "";
          }
        ];
      };
    };
  };
}
