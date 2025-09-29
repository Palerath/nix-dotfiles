{
   programs.gallery-dl = {
      enable = true;
      settings = {
         base-directory = "/home/perihelie/Documents/gallery-dl";

         pixiv = {
            refresh-token = "...";

            directory = ["{category}" "{user[id]} {user[account]}}"];
            filename = "{id}_p{num}.{extension}";

            ugoira = true;
            metadata = true;
            avatar = false;

            include = "all";
         };

         kemono = {
            # Directory structure
            directory = ["{category}" "{service}" "{user}"];
            filename = "{id}_{title[:100]}_{num:>02}.{extension}";

            # Download settings
            metadata = true;
            comments = false;
            dms = false;

            # Content filtering
            max-posts = 0;  # 0 = unlimited
         };
         twitter = {
            # Authentication - use cookies file or add credentials
            # cookies = "~/.config/gallery-dl/twitter-cookies.txt";

            # Directory structure
            directory = ["{category}" "{author[name]}"];
            filename = "{tweet_id}_{num}.{extension}";

            # Download settings
            retweets = false;  # Skip retweets
            replies = true;    # Include replies
            quotes = true;     # Include quote tweets
            videos = true;     # Download videos

            # Content settings
            text-tweets = false;  # Don't save text-only tweets
            twitpic = true;      # Download twitpic images

            # Metadata
            metadata = true;
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
            rate = "null";  # Rate limit (1MB/s), remove or set to null for unlimited
            retries = 3;
            timeout = 30.0;
            verify = true;  # SSL certificate verification

            # Parallel downloads
            part = true;
            part-directory = "/tmp/.gallery-dl";
         };
      };
   };
}
