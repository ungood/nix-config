{ pkgs, config, ... }:
let
  userCommon = import ./user-common.nix { inherit pkgs; lib = pkgs.lib; };
in
{
  # Enable immutable user management
  users.mutableUsers = false;

  # User configurations
  users.users = {
    ungood = userCommon.mkUser {
      username = "ungood";
      description = "Jason Walker";
    } // {
      # 1Password-managed password hash
      hashedPasswordFile = config.opnix.secrets."ungood-password".path;
    };

    trafficcone = userCommon.mkUser {
      username = "trafficcone";
      description = "Traffic Cone User";
    } // {
      # 1Password-managed password hash
      hashedPasswordFile = config.opnix.secrets."trafficcone-password".path;
    };
  };
}
