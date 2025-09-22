{ pkgs, ... }:
let
  userCommon = import ./user-common.nix { inherit pkgs; };
in
{
  # User configuration
  users = {
    # Enable immutable user management
    mutableUsers = false;

    # User groups
    groups = {
      ungood = { };
      trafficcone = { };
    };

    # User configurations
    users = {
      ungood =
        userCommon.mkUser {
          username = "ungood";
          description = "Jason Walker";
        }
        // {
          # OpNix-managed password hash from 1Password
          hashedPasswordFile = "/run/secrets/ungood-password";
        };

      trafficcone =
        userCommon.mkUser {
          username = "trafficcone";
          description = "Traffic Cone User";
        }
        // {
          # OpNix-managed password hash from 1Password
          hashedPasswordFile = "/run/secrets/trafficcone-password";
        };
    };
  };
}
