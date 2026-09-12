# Manages Claude Code configuration profiles.
#
# Each profile gets its own directory under ~/.config/claude/<name>/ with
# shared files (settings.json, CLAUDE.md, etc.) symlinked in. A profile can
# override any of them with its own file via `profiles.<name>.files`. The
# active profile is selected via CLAUDE_CONFIG_DIR.
{ config, lib, ... }:
let
  cfg = config.onetrue.claude;
in
{
  options.onetrue.claude = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.files = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Files to symlink into this profile only, in the same shape as sharedFiles. An entry here replaces sharedFiles for the same relative path, which is how a profile gets its own settings.json (Claude Code reads exactly one user settings.json, so it cannot be layered).";
          };
        }
      );
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
      profileName: profileCfg:
      lib.mapAttrs' (
        relPath: absPath:
        lib.nameValuePair ".config/claude/${profileName}/${relPath}" {
          source = config.lib.file.mkOutOfStoreSymlink absPath;
        }
      ) (cfg.sharedFiles // profileCfg.files)
    ) cfg.profiles;
  };
}
