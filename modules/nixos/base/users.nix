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
          # 1Password-managed password hash
          # hashedPasswordFile = config.opnix.secrets."ungood-password".path;
          # Temporary hard coded password until I find a better solution
          hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
        };

      trafficcone =
        userCommon.mkUser {
          username = "trafficcone";
          description = "Traffic Cone User";
        }
        // {
          # 1Password-managed password hash
          hashedPasswordFile = config.opnix.secrets."trafficcone-password".path;
        };
    };
  };
}
