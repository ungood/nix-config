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

  # SessionStart hook that prints the model in big colored letters, so a
  # session that came up on the wrong model (e.g. an org default) is obvious.
  # Also runs on PreModelSwitch, whose message is flattened to one line with
  # no ANSI colors, so that one gets a plain one-liner instead of the banner.
  claude-model-banner = pkgs.writeShellApplication {
    name = "claude-model-banner";
    runtimeInputs = [
      pkgs.jq
      pkgs.figlet
    ];
    text = ''
      input=$(cat)
      event=$(jq -r '.hook_event_name // empty' <<<"$input")
      model=$(jq -r '.model // .to_model // empty' <<<"$input")
      [ -n "$model" ] || exit 0

      # claude-opus-5-5[1m] -> OPUS 5.5
      label=$(sed -E 's/^claude-//; s/\[.*\]$//; s/-([0-9]+)-([0-9]+).*$/ \1.\2/' <<<"$model" | tr '[:lower:]' '[:upper:]')
      if [ "$event" != SessionStart ]; then
        jq -n --arg msg "⇢ Switching to $label" '{systemMessage: $msg}'
        exit 0
      fi

      case "$model" in
        *opus*) color=32 ;;   # green
        *sonnet*) color=31 ;; # red
        *haiku*) color=33 ;;  # yellow
        *) color=35 ;;        # magenta
      esac

      # The TUI resets the color at each line, so color every line.
      banner=$(figlet -w 120 "$label" | sed "s/^/"$'\e'"[1;''${color}m/; s/\$/"$'\e'"[0m/")

      jq -n --arg msg "Model: $model"$'\n\n'"$banner" '{systemMessage: $msg}'
    '';
  };
in
{
  home.packages = [
    cship
    claude-code
    claude-model-banner
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
