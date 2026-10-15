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
  claude-model-banner = pkgs.writeShellApplication {
    name = "claude-model-banner";
    runtimeInputs = [
      pkgs.jq
      pkgs.figlet
    ];
    text = ''
      model=$(jq -r '.model // empty')
      [ -n "$model" ] || exit 0

      # claude-opus-5-5[1m] -> OPUS 5.5
      label=$(sed -E 's/^claude-//; s/\[.*\]$//; s/-([0-9]+)-([0-9]+).*$/ \1.\2/' <<<"$model" | tr '[:lower:]' '[:upper:]')

      # Hash the family (opus, sonnet, ...) onto a 30-step hue wheel in the
      # 256-color cube, so each family keeps one saturated color across versions.
      family=$(sed -E 's/^claude-//; s/-.*//' <<<"$model")
      hash=$(cksum <<<"$family" | cut -d' ' -f1)
      hue=$((hash % 30))
      step=$((hue % 5))
      case $((hue / 5)) in
        0) r=5 g=$step b=0 ;;
        1) r=$((5 - step)) g=5 b=0 ;;
        2) r=0 g=5 b=$step ;;
        3) r=0 g=$((5 - step)) b=5 ;;
        4) r=$step g=0 b=5 ;;
        *) r=5 g=0 b=$((5 - step)) ;;
      esac
      color=$((16 + 36 * r + 6 * g + b))

      # The TUI resets the color at each line, so color every line.
      banner=$(figlet -w 120 "$label" | sed "s/^/"$'\e'"[1;38;5;''${color}m/; s/\$/"$'\e'"[0m/")

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
