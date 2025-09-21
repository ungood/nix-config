{ pkgs, ... }:
let
  # Common user configuration options
  mkUser =
    {
      username,
      description,
      extraGroups ? [
        "networkmanager"
        "wheel"
      ],
    }:
    {
      isNormalUser = true;
      group = username;
      inherit description extraGroups;
      shell = pkgs.fish;
    };
in
{
  # Function to create user with common settings
  inherit mkUser;
}
