# Create home.file entries that symlink a directory tree using mkOutOfStoreSymlink.
# This enables tools that self-manage their configs to write to the actual files
# while still keeping them version-controlled in the repo.
#
# Usage:
#   home.file = mkSymlinkDir config ./dotfiles "/absolute/path/to/dotfiles";
#
# A file at ./dotfiles/.claude/settings.json becomes a symlink at
# ~/.claude/settings.json -> /absolute/path/to/dotfiles/.claude/settings.json
{ lib }:
{
  mkSymlinkDir =
    hmConfig: nixPath: absPath:
    let
      readDirRec =
        nixP: absP: prefix:
        lib.concatMapAttrs (
          name: type:
          let
            nixChild = nixP + "/${name}";
            absChild = "${absP}/${name}";
            relPath = if prefix == "" then name else "${prefix}/${name}";
          in
          if type == "directory" then
            readDirRec nixChild absChild relPath
          else
            {
              ${relPath}.source = hmConfig.lib.file.mkOutOfStoreSymlink absChild;
            }
        ) (builtins.readDir nixP);
    in
    readDirRec nixPath absPath "";
}
