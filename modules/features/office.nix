{
  self,
  inputs,
  ...
}: {
  flake.homeModules.office = {
    hostName,
    lib,
    ...
  }: {
    imports = lib.optionals (hostName != "periserver") [
      self.homeModules.mails
      self.homeModules.wordProcess
    ];
  };
  flake.homeModules.wordProcess = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
      libreoffice-qt-fresh
      onlyoffice-documentserver
      texstudio
      texlab
    ];
  };
  flake.homeModules.mails = {
    pkgs,
    config,
    ...
  }: let
    username = config.home.username;
  in {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;

      # Global settings applied to all profiles
      settings = {
        # UI language
        "intl.locale.requested" = "fr";
        "intl.accept_languages" = "fr-FR, fr, en-US, en";

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # Security/privacy
        "mail.phishing.detection.enabled" = true;
        "mailnews.message_display.disable_remote_image" = true; # block remote images by default
        "privacy.donottrackheader.enabled" = true;

        # Composition
        "mail.SpellCheckBeforeSend" = true;
        "mail.compose.autosaveinterval" = 2; # autosave draft every 2 minutes
      };

      profiles."${username}" = {
        isDefault = true;

        settings = {
          # Threading
          "mailnews.default_sort_type" = 18; # sort by date
          "mailnews.default_sort_order" = 2; # descending
          "mailnews.default_view_flags" = 1; # threaded view

          # Reduce animation/startup noise
          "mail.startup.enabledMailCheckOnce" = true;
          "mailnews.start_page.enabled" = false;

          # Plain text by default for composition
          "mail.html_compose" = false;
          "mail.identity.default.compose_html" = false;

          # Date format (ISO)
          "mail.ui.display.dateformat" = 1;
        };

        extensions = with pkgs; [
          birdtray
        ];
      };
    };
  };
}
