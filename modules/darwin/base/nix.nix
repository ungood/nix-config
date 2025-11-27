{ lib, ... }:
{
  nixpkgs.config = lib.mkDefault {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Darwin uses @admin instead of @wheel
      trusted-users = [ "@admin" ];
    };

    # Garbage collection using launchd format for Darwin
    gc = {
      automatic = true;
      interval = {
        Weekday = 0; # Sunday
      };
      options = "--delete-older-than 7d";
    };
  };
}
