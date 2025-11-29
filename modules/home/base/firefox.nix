let
  # Function to lock configuration values
  locked = value: {
    Value = value;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;

    # System-wide policies for privacy and security
    # Check about:policies#documentation for options
    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DontCheckDefaultBrowser = true;

      Preferences = {
        "extensions.pocket.enabled" = locked false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.showSponsored" = locked false;
        "browser.newtabpage.activity-stream.system.showSponsored" = locked false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = locked false;
      };

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed"
      ExtensionSettings = {
        "*".installation_mode = "allowed";
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # 1Password:
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # TODO: Name profile after username
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      search = {
        force = true;
        default = "kagi";
        privateDefault = "ddg";
        order = [
          "kagi"
          "ddg"
          "google"
        ];
        engines = {
          kagi = {
            name = "Kagi";
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/favicon.ico";
          };
          bing.metaData.hidden = true;
        };
      };

      # TODO: Figure out how to make this work
      #extensions.packages = with inputs.firefox-addons; [
      #  ublock-origin
      #  new-tab-override
      #];

      settings = {
        "browser.aboutConfig.showWarning" = false;

        # Set homepage and new tab page to Kagi
        "browser.startup.homepage" = "https://kagi.com";
        "browser.newtabpage.enabled" = false;

        # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
        # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
        # then have Firefox open on some other workspace.
        "widget.disable-workspace-management" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable "save password" prompt
        "signon.rememberSignons" = false;

        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
