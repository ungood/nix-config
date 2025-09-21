{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    claude-code
  ];

  home.sessionVariables = {
    # Make Claude use XDG base directory!
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  };

  # Claude configuration management via symlinks
  xdg.configFile = {
    # Main Claude configuration
    "${config.xdg.configHome}/claude/settings.json" = {
      source = ./settings.json;
    };
  };
}
