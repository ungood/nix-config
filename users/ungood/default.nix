{pkgs, inputs,...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Install fish system-wide
  programs.fish.enable = true;

  # NixOS Configuration
  users.users.ungood = {
    isNormalUser = true;
    description = "Jason Walker";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.fish;

    packages = with pkgs; [
      kdePackages.kate
    ];
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

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;
    };

    imports = [
      ../../modules/home/fish.nix
      ../../modules/home/git.nix
      ../../modules/home/ssh.nix
    ];

  };

  # TODO: Import host-specific user config.
}
