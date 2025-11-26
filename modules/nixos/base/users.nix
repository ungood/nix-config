{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;

  # Define user configurations directly
  systemUsers = {
    ungood = {
      isNormalUser = true;
      description = "Jason";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYUd6/nysF5AN7Iv8+2iCd/wWH2F1oSGysDqLaAbQM8"
      ];
      shell = pkgs.fish;
      group = "ungood";
      hashedPassword = inputs.secrets.passwords.ungood;
    };

    trafficcone = {
      isNormalUser = true;
      description = "Brendan";
      extraGroups = [ ];
      shell = pkgs.fish;
      group = "trafficcone";
      hashedPassword = inputs.secrets.passwords.trafficcone;
    };

    abirdnamed = {
      isNormalUser = true;
      description = "Brianna";
      extraGroups = [ ];
      shell = pkgs.fish;
      group = "abirdnamed";
      hashedPassword = inputs.secrets.passwords.abirdnamed;
    };
  };

  # Generate user groups
  userGroups = lib.mapAttrs (_username: _: { }) systemUsers;
in
{
  users = {
    mutableUsers = false;
    groups = userGroups;
    users = systemUsers;
  };
}
