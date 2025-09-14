{ pkgs, ... }:
{
  # GitHub CLI configuration
  programs.gh = {
    enable = true;

    settings = {
      # Prefer SSH for git operations
      git_protocol = "ssh";
    };
  };
}
