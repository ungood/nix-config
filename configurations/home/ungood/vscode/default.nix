_:
{
  config,
  lib,
  ...
}:
let
  symlink = import ../../../../lib/symlink.nix { inherit lib; };
  dotfilesAbsPath = "${config.onetrue.dotfiles.repoPath}/configurations/home/ungood/vscode/dotfiles";
in
{
  # Symlink config files so VS Code (and Settings Sync) can self-manage its
  # settings while they stay version-controlled in this repo.
  home.file = symlink.mkSymlinkDir config ./dotfiles dotfilesAbsPath;
}
