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
      abirdnamed = { };
    };

    # User configurations
    users = {
      ungood =
        userCommon.mkUser {
          username = "ungood";
          description = "Jason Walker";
        }
        // {
          # Temporary hard coded password until I find a better solution
          hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
        };

      trafficcone =
        userCommon.mkUser {
          username = "trafficcone";
          description = "Traffic Cone User";
        }
        // {
          # Temporary hard coded password until I find a better solution
          hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
        };

      abirdnamed =
        userCommon.mkUser {
          username = "abirdnamed";
          description = "A Bird Named User";
        }
        // {
          # Temporary hard coded password until I find a better solution
          hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
        };
    };
  };
}
