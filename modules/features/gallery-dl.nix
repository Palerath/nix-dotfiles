{
  self,
  inputs,
  ...
}: {
  flake.homeModules.galleryDL = {
    pkgs,
    config,
    ...
  }: {
    imports = [self.homeModules.sops];
    sops = {
      secrets.gallery_dl = {
        path = "${config.home.homeDirectory}/.gallery-dl.conf";
      };
    };

    programs.gallery-dl = {
      enable = true;
      settings = {
        base-directory = "${config.home.homeDirectory}/shares/perihelie/Artists/!inbox";
        "include-file" = "${config.home.homeDirectory}/.config/gallery-dl/credentials.json";

        extractor = {
          pixiv = {
            directory = [''{category}'' ''{user[id]}_{user[account]}''];
            filename = "{id}_p{num}_{title}.{extension}";

            ugoira = true;
            metadata = true;

            "sanity-level" = 6;
            include = "artworks";
          };

          fanbox = {
            directory = [''{category}'' ''{user[id]}_{user[account]}''];
            filename = "{id}_p{num}_{title}.{extension}";

            ugoira = true;
            metadata = true;

            "sanity-level" = 6;
          };

          kemono = {
            # Directory structure
            directory = [''{category}'' ''{service}'' ''{user}''];
            filename = "{id}_{title[:100]}_{num:>02}.{extension}";

            # Download settings
            metadata = true;
            comments = false;
            dms = false;

            # Content filtering
            max-posts = 0; # 0 = unlimited
          };

          twitter = {
            # Directory structure
            directory = [''{category}'' ''{author[name]}''];
            filename = "{tweet_id}_{num}.{extension}";

            cookies = "${config.home.homeDirectory}/.config/gallery-dl/twitter-cookies.txt";
            "cookies-update" = true;

            # Download settings
            retweets = false; # Skip retweets
            replies = true; # Include replies
            quotes = true; # Include quote tweets
            videos = true; # Download videos

            # Content settings
            text-tweets = false; # Don't save text-only tweets
            twitpic = true; # Download twitpic images

            # Metadata
            metadata = true;
          };
        };

        output = {
          mode = "terminal";
          progress = true;
          shorten = true;
          log = {
            level = "info";
            format = "{name}: {message}";
          };
        };

        downloader = {
          retries = 3;
          timeout = 30.0;
          verify = true; # SSL certificate verification

          # Parallel downloads
          part = true;
          part-directory = "/tmp/.gallery-dl";
        };
      };
    };
  };
}
