{
  config,
  pkgs,
  ...
}:
let
  claudeConfigDir = "${config.xdg.configHome}/claude";
in
{
  home.packages = with pkgs; [
    claude-code
  ];

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = claudeConfigDir;
  };

  # Claude configuration management via symlinks

  xdg.configFile = {
    # Main Claude configuration
    # TODO: extraKnownMarketplaces only works in project settings
    # May need to configure marketplaces and plugins with activation script
    "${claudeConfigDir}/settings.json" = {
      source = ./settings.json;
    };
  };

  programs.git.ignores = [
    "settings.local.json"
  ];
}
