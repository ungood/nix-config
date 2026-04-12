_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  symlink = import ../../../../lib/symlink.nix { inherit lib; };
  dotfilesAbsPath = "${config.onetrue.dotfiles.repoPath}/configurations/home/ungood/claude/dotfiles";

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
  # Use llm-agents overlay for newer claude-code than nixpkgs
  home.packages = [
    cship
  ]
  ++ (with pkgs.llm-agents; [
    claude-code
  ]);

  # Symlink config files so Claude Code can self-manage its settings.
  home.file = symlink.mkSymlinkDir config ./dotfiles dotfilesAbsPath;

  programs.git.ignores = [
    "settings.local.json"
  ];
}
