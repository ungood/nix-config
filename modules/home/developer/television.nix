{ lib, pkgs, ... }:
let
  # List of TOML files to include from community channels
  # https://github.com/alexpasmantier/television/tree/main/cable/unix
  communityChannels = [
    "channels"
    "env"
    "files" # Requires fd and bat
    "fish-history"
    "dirs" # Requires fd

    "gh-issues"
    "gh-prs"

    "git-branch"
    "git-diff"
    "git-log"
    "git-reflog"

    "procs"
    "tldr" # requires tldr
  ];
in
{
  # Copy specified cable files into $XDG_CONFIG_HOME/television/cable
  xdg.configFile = lib.listToAttrs (
    lib.map (filename: {
      name = "television/cable/${filename}.toml";
      value = {
        source = "${pkgs.television.src}/cable/unix/${filename}.toml";
      };
    }) communityChannels
  );

  programs = {
    television = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        default_channel = "channels";
      };
    };

    # TODO: channels for
    # - docker/podman images/containers/etc...
    # - aws resources
    # - mise tasks

    # TODO: This would be interesting to replace/extend delta as a pager for git diffs
  };
}
