{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
    ./bat.nix
    ./claude.nix
    ./ghostty.nix
    ./git.nix
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages =
      with pkgs;
      [
        gum
        # Obsidian with HM is a PITA to use with community packages right now so I currently just install the package
        # See: https://github.com/nix-community/home-manager/pull/6487#issuecomment-2667166722
        obsidian
        todoist
      ]
      ++ lib.optionals stdenv.isDarwin [
        rectangle
      ]
      ++ lib.optionals stdenv.isLinux [
        beeper
      ];

    sessionVariables = {
      GREP_OPTIONS = "--color=auto";
      LESS = "-iMFXR";
    };
  };

  # TODO: Move this somewhere more appropriate.
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = pkgs.stdenv.isDarwin;
  };

  programs = {
    fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "${config.home.username}";
          # TODO, it would be nice if this was somehow a symlink so changes could be realized without switching
          # However, I triked mkOutOfLinkSymlink and the way the plugin gets generated doesn't quite work.
          src = ./fish;
        }
        {
          name = "z";
          inherit (z) src;
        }
      ];
    };

    starship.enable = true;
  };

  onetrue = {
    avatar.path = ./metroid.png;
  };
}
