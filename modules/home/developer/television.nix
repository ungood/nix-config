{ lib, pkgs, ... }:
let
  cableDir = "${pkgs.television.src}/cable/unix";

  fromUpstream = name: builtins.fromTOML (builtins.readFile "${cableDir}/${name}.toml");

  # Only include channels whose TOML files exist in the current television version.
  mkChannels =
    names:
    lib.genAttrs (builtins.filter (
      name: builtins.pathExists "${cableDir}/${name}.toml"
    ) names) fromUpstream;

  commonChannels = [
    "alias"
    "aws-profiles"
    "dirs"
    "docker-compose"
    "docker-containers"
    "docker-images"
    "docker-networks"
    "docker-volumes"
    "dotfiles"
    "env"
    "files"
    "fish-history"
    "gh-issues"
    "gh-prs"
    "git-branch"
    "git-diff"
    "git-log"
    "git-reflog"
    "git-remotes"
    "git-repos"
    "git-stash"
    "git-submodules"
    "git-tags"
    "just-recipes"
    "man-pages"
    "procs"
    "ssh-hosts"
    "text"
  ];

  linuxChannels = [
    "flatpak"
    "journal"
    "systemd-units"
  ];

  darwinChannels = [
    "brew-packages"
  ];

  platformChannels =
    lib.optionalAttrs pkgs.stdenv.isLinux (mkChannels linuxChannels)
    // lib.optionalAttrs pkgs.stdenv.isDarwin (mkChannels darwinChannels);
in
{
  # Channel dependencies not provided by other modules.
  home.packages = with pkgs; [
    fd
  ];

  programs.television = {
    enable = true;
    enableFishIntegration = true;
    settings.default_channel = "fish-history";
    channels = mkChannels commonChannels // platformChannels;
  };

  # TODO: This would be interesting to replace/extend delta as a pager for git diffs
}
