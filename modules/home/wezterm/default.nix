{
  programs.wezterm = {
    enable = true;

    # Use extraConfig instead of home.file to avoid conflicts
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  # Enable fish integration manually since wezterm doesn't have built-in support
  programs.fish.shellInit = ''
    # WezTerm shell integration
    if test "$TERM_PROGRAM" = "WezTerm"
      printf "\033]1337;ShellIntegrationVersion=1\007"
    end
  '';
}
