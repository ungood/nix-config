{ pkgs, inputs, ... }:
let
  userCommon = import ../../../lib/users.nix { inherit pkgs; };
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
          # Use password hash from secrets flake
          hashedPassword = inputs.secrets.passwords.ungood;
        };

      trafficcone =
        userCommon.mkUser {
          username = "trafficcone";
          description = "Traffic Cone User";
        }
        // {
          # Use password hash from secrets flake
          hashedPassword = inputs.secrets.passwords.trafficcone;
        };
    };
  };
}
