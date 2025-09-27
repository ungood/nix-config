{ pkgs, ... }:
{
  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";
  };

  # Optional dotfiles repository for standalone home-manager
  dotfilesRepo = "https://github.com/ungood/dotfiles.git";

  # NixOS system user configuration
  nixos = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    # Password will be set from secrets flake if available, otherwise use fallback
    hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYUd6/nysF5AN7Iv8+2iCd/wWH2F1oSGysDqLaAbQM8"
    ];
  };
}
