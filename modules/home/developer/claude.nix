# Manages Claude Code configuration profiles.
#
# Each profile gets its own directory under ~/.config/claude/<name>/ with
# shared files (settings.json, CLAUDE.md, etc.) symlinked in. The active
# profile is selected via CLAUDE_CONFIG_DIR.
{ config, lib, ... }:
let
  cfg = config.onetrue.claude;
in
{
  options.onetrue.claude = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule { });
      default = { };
      description = "Claude Code configuration profiles. Each profile gets its own config directory under ~/.config/claude/.";
    };

    defaultProfile = lib.mkOption {
      type = lib.types.str;
      description = "Default Claude Code profile name. Sets CLAUDE_CONFIG_DIR.";

    };

    sharedFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Files to symlink into each profile directory. Keys are relative paths within the profile, values are absolute filesystem paths (used with mkOutOfStoreSymlink).";
    };
  };

  config = lib.mkIf (cfg.profiles != { }) {
    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.home.homeDirectory}/.config/claude/${cfg.defaultProfile}";
    };

    home.file = lib.concatMapAttrs (
      profileName: _:
      lib.mapAttrs' (
        relPath: absPath:
        lib.nameValuePair ".config/claude/${profileName}/${relPath}" {
          source = config.lib.file.mkOutOfStoreSymlink absPath;
        }
      ) cfg.sharedFiles
    ) cfg.profiles;
  };
}
