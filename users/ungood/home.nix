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
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages = with pkgs; [
      cowsay
      gum
      lolcat
      neofetch
      neovim
      wezterm
      zed-editor
    ];

    # Session environment variables
    sessionVariables = {
      GREP_OPTIONS = "--color=auto";
      LESS = "-iMFXR";
      EDITOR = "nvim";
    };
  };

  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "${config.home.username}";
        src = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/${config.home.username}/fish";
      }
      {
        name = "z";
        inherit (z) src;
      }
    ];
  };

  programs.starship = {
    enable = true;
  };
}
