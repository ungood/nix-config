# OpenCode configuration and plugins
_: {
  programs = {
    opencode = {
      enable = true;
    };

    fish.shellAbbrs = {
      oc = "opencode";
    };
  };

  xdg.configFile = {
    # Desktop notification plugin (session complete, errors, permission requests)
    "opencode/plugins/notifier.ts".source = ./notifier.ts;

    # node-notifier dependency for the notifier plugin
    "opencode/package.json".source = ./package.json;
  };
}
