{
  self,
  pkgs,
  lib,
  ...
}:
let
  # Try to import passwords, fall back to locked accounts if secrets are encrypted (CI)
  passwordsFile = "${self}/secrets/passwords.nix";
  passwords =
    let
      # Try to read the file to check if it's encrypted
      # git-crypt encrypted files cannot be read as a Nix string
      readResult = builtins.tryEval (builtins.readFile passwordsFile);
      # If readFile fails, the file is likely encrypted
      # If we can read it, check if it starts with valid Nix syntax
      isEncrypted =
        if readResult.success then
          let
            content = readResult.value;
          in
          !(lib.hasPrefix "#" content || lib.hasPrefix "{" content)
        else
          true;
    in
    if isEncrypted then
      # Return locked account markers when secrets are encrypted
      {
        ungood = "!";
        trafficcone = "!";
        abirdnamed = "!";
      }
    else
      import passwordsFile;

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
      hashedPassword = passwords.ungood;
    };

    trafficcone = {
      isNormalUser = true;
      description = "Brendan";
      extraGroups = [ ];
      shell = pkgs.fish;
      group = "trafficcone";
      hashedPassword = passwords.trafficcone;
    };

    abirdnamed = {
      isNormalUser = true;
      description = "Brianna";
      extraGroups = [ ];
      shell = pkgs.fish;
      group = "abirdnamed";
      hashedPassword = passwords.abirdnamed;
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
