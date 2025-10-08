{
  pkgs,
  inputs,
  ...
}:
{
  # Import developer modules
  imports = [
    inputs.self.homeModules.developer
    ./claude
    ./fish
    ./git.nix
    ./obsidian.nix
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages = with pkgs; [
      gum
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

  programs.starship = {
    enable = true;
  };

  onetrue = {
    avatar.path = ./metroid.png;
  };
}
