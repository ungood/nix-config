{ self, ... }:
{
  config,
  lib,
  ...
}:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
  ];

  #Git
  programs.git = {
    enable = true;

    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeaSNolAQzMs4wVu3f17hfQz4mYWNl9DS/SMWHpa7cc";
    signing.format = "ssh";
  };

  # Home-manager configuration
  home = {
    username = "trafficcone";
    stateVersion = "25.05";
  };

  onetrue = {
    avatar.path = ./traffic-cone.png;
  };

  # This account opens its own profile, with SearXNG search, instead of the
  # base module's default profile.
  programs.firefox.profiles = {
    default.isDefault = lib.mkForce false;

    trafficcone = {
      id = 1;
      name = "trafficcone";
      isDefault = true;

      search = {
        force = true;
        default = "xng";
        privateDefault = "xng";
        order = [
          "xng"
          "kagi"
          "ddg"
          "google"
        ];
        engines = {
          xng = {
            name = "PlainskilL SearXNG";
            urls = [ { template = "https://search.plainskill.net/search?q={searchTerms}"; } ];
            icon = "https://search.plainskill.net/static/themes/simple/img/favicon.png";
          };
          kagi = {
            name = "Kagi";
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/favicon.ico";
          };
          bing.metaData.hidden = true;
        };
      };

      settings = config.onetrue.firefox.profileSettings // {
        "browser.startup.homepage" = "https://search.plainskill.net";
      };
    };
  };
}
