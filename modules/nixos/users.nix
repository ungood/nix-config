{ pkgs, ... }:
{
  # NixOS User Configuration
  users.users.ungood = {
    isNormalUser = true;
    description = "Jason Walker";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.fish;
  };
}
