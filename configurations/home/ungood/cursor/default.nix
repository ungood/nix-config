_:
{
  config,
  lib,
  ...
}:
let
  symlink = import ../../../../lib/symlink.nix { inherit lib; };
  dotfilesAbsPath = "${config.onetrue.dotfiles.repoPath}/configurations/home/ungood/cursor/dotfiles";
in
{
  # Symlink config files so Cursor can self-manage its settings.
  home.file = symlink.mkSymlinkDir config ./dotfiles dotfilesAbsPath;
}
