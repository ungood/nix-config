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

  cship = pkgs.stdenv.mkDerivation rec {
    pname = "cship";
    version = "1.4.1";

    src = pkgs.fetchurl {
      url = "https://github.com/stephenleo/cship/releases/download/v${version}/cship-${
        if pkgs.stdenv.hostPlatform.isDarwin then
          "${pkgs.stdenv.hostPlatform.parsed.cpu.name}-apple-darwin"
        else
          "${pkgs.stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-musl"
      }";
      hash =
        if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then
          "sha256-sPeIHyPOQRXR+BoONrkaSTwIGZ43IsatYjhEhhXg+Mo="
        else
          "sha256-s2CE6c62S7Y8bsIh3Y7jXKP0WZJsYUcSTrXaL05icmE=";
    };

    dontUnpack = true;

    installPhase = ''
      install -Dm755 $src $out/bin/cship
    '';
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
