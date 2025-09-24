{ pkgs, ... }:
{
  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";
  };

  # NixOS system user configuration
  nixos = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    # Temporary hard coded password until I find a better solution
    hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
  };
}
