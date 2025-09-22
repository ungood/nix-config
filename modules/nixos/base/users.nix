{ pkgs, config, ... }:
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
          # Agenix-managed password hash from 1Password
          hashedPasswordFile = config.age.secrets."ungood-password".path;
        };

      trafficcone =
        userCommon.mkUser {
          username = "trafficcone";
          description = "Traffic Cone User";
        }
        // {
          # Agenix-managed password hash from 1Password
          hashedPasswordFile = config.age.secrets."trafficcone-password".path;
        };
    };
  };
}
