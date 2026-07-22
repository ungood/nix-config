_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfilesAbsPath = "${config.onetrue.dotfiles.repoPath}/configurations/home/ungood/claude/dotfiles";

  claude-code = pkgs.llm-agents.claude-code.overrideAttrs (old: {
    postFixup =
      builtins.replaceStrings [ "--argv0 claude" ] [ "--argv0 claude --set FORCE_AUTOUPDATE_PLUGINS 1" ]
        old.postFixup;
  });

  # Built from source at an unreleased main commit because the `cship.account`
  # module (stephenleo/cship#153) is not yet in any tagged release.
  cship = pkgs.rustPlatform.buildRustPackage {
    pname = "cship";
    version = "1.7.1-unstable-2026-06-10";

    src = pkgs.fetchFromGitHub {
      owner = "stephenleo";
      repo = "cship";
      rev = "44093b1f1aa99fd0ecb8fd65ec5f576ddb8ca4f5";
      hash = "sha256-WYO9KlrRnOYtZ94V4uQ6/IVSEWlZUEHTCrmQp+PAKZk=";
    };

    cargoHash = "sha256-ESOW4kF2ExN+QpQtV49dQFOqhwy7kyM6HFw2IhIGDuc=";
  };
in
{
  home.packages = [
    cship
    claude-code
  ];

  # Symlink cship config (not profile-specific)
  home.file.".config/cship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesAbsPath}/.config/cship.toml";

  # Symlink global CLAUDE.md (lives at ~/.claude/, outside the profile system)
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesAbsPath}/.claude/CLAUDE.md";

  # Define personal profile with shared config files
  onetrue.claude = {
    profiles.personal = { };
    defaultProfile = lib.mkDefault "personal";
    sharedFiles = {
      "settings.json" = "${dotfilesAbsPath}/.claude/settings.json";
    };
  };

  programs.git.ignores = [
    "settings.local.json"
  ];
}
