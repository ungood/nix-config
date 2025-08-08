{ pkgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # NixOS Configuration
  users.users.ungood = {
    isNormalUser = true;
    description = "Jason Walker";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.fish;
  };

  home-manager.users.ungood = {
    home = {
      username = "ungood";
      homeDirectory = "/home/ungood";

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "25.05";
    };

    home.packages = with pkgs; [
      claude-code
      jq
      just
    ];

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;
    };

    imports = [
      ../../modules/home/firefox.nix
      ../../modules/home/fish.nix
      ../../modules/home/ghostty.nix
      ../../modules/home/git.nix
      ../../modules/home/gnome.nix
      ../../modules/home/plasma/example.nix
      ../../modules/home/ssh.nix
      ../../modules/home/stylix.nix
      ../../modules/home/vs-code
    ];

  };

  # TODO: Import host-specific user config.
}
