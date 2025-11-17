{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Import developer modules
  imports = [
    inputs.self.homeModules.developer
    ./bat.nix
    ./claude.nix
    ./git.nix
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages = with pkgs; [
      ghostty
      gum
      # Obsidian with HM is a PITA to use with community packages right now so I currently just install the package
      # See: https://github.com/nix-community/home-manager/pull/6487#issuecomment-2667166722
      obsidian
      opencode
      todoist
      wezterm
    ];

    sessionVariables = {
      GREP_OPTIONS = "--color=auto";
      LESS = "-iMFXR";
    };
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

    spotify-player.enable = true;
    starship.enable = true;
  };

  onetrue = {
    avatar.path = ./metroid.png;
  };
}
