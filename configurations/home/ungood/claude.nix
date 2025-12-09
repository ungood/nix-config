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
        "claude@ungood" = true;
      };

      permissions = {
        allow = [
          "Bash(cat:*)"
          "Bash(echo:*)"
          "Bash(find:*)"
          "Bash(git:*)"
          "Bash(gh:*)"
          "Bash(head:*)"
          "Bash(just:*)"
          "Bash(jq:*)"
          "Bash(ls:*)"
          "Bash(mkdir:*)"
          "Bash(mv:*)"
          "Bash(rg:*)"
          "Bash(sort:*)"
          "Bash(tail:*)"
          "Bash(tree:*)"
          "Bash(wc:*)"
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
