_: {
  programs.claude-code = {
    enable = true;

    settings = {
      theme = "dark";
      includeCoAuthoredBy = false;

      extraKnownMarketplaces = {
        ungood = {
          source = {
            source = "github";
            repo = "ungood/claude";
          };
        };
      };

      enabledPlugins = {
        "github@ungood" = true;
      };

      permissions = {
        allow = [
          "Bash(git:*)"
          "Bash(gh:*)"
          "Bash(just:*)"
          "Bash(mkdir:*)"
          "Bash(mv:*)"
          "Bash(ls:*)"
          "Bash(find:*)"
          "WebFetch"
          "WebSearch"
        ];
        ask = [
          "Bash(git push:*)"
        ];
        deny = [
          "Read(./.env)"
          "Read(./.env.*)"
          # TODO: Add other dangerous credential files.
        ];
      };
    };
  };

  programs.git.ignores = [
    "settings.local.json"
  ];
}
