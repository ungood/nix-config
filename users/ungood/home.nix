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
    ./claude
    ./git.nix
    ./obsidian.nix
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages = with pkgs; [
      gum
      neovim
      todoist
      wezterm
    ];

    # Session environment variables
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

    starship = {
      enable = true;
    };

    spotify-player = {
      enable = true;
    };
  };

  onetrue = {
    avatar.path = ./metroid.png;
  };
}
