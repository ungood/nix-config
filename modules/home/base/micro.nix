_: {
  # micro is the default terminal editor. It is intentionally the target of
  # EDITOR/VISUAL rather than helix, which stays installed for heavier editing.
  programs.micro = {
    enable = true;

    settings = {
      # Soft-wrap long lines instead of scrolling horizontally.
      softwrap = true;
      # Keep tabs consistent with the rest of the config.
      tabsize = 2;
      tabstospaces = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  programs.git.settings.core.editor = "micro";

  stylix.targets.micro.enable = true;
}
