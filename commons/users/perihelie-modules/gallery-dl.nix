{
   programs.gallery-dl = {
      enable = true;
      settings = {
         base-directory = "/home/perihelie/Documents/gallery-dl";

         extractor = {
            pixiv = {
               cookies = {
                  PHPSESSID = "d_4zIEpAMQs0tNcUgS00YRCdqZuTOLpbbuh9D6FexwU";
               };
               "refresh-token" = "BHvddl-fwZRvV4t-xMTAxLGdpxf4Zvu7zCpJaO4mX74";

               directory = [''{category}'' ''{user[id]}_{user[account]}''];
               filename = "{id}_p{num}.{extension}";

               ugoira = true;
               metadata = true;

               "sanity-level" = 6;
               include = "all";
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
               max-posts = 0;  # 0 = unlimited
            };

            twitter = {
               # Authentication - use cookies file or add credentials
               # cookies = "~/.config/gallery-dl/twitter-cookies.txt";

               # Directory structure
               directory = [''{category}'' ''{author[name]}''];
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
            verify = true;  # SSL certificate verification

            # Parallel downloads
            part = true;
            part-directory = "/tmp/.gallery-dl";
         };
      };
   };
}
