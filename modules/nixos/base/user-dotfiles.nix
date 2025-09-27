{
  lib,
  pkgs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Get user configs with dotfiles repositories
  dotfilesUserConfigs =
    lib.filter (userConfig: userConfig ? dotfilesRepo && userConfig.dotfilesRepo != null)
      (
        lib.map (
          filename:
          let
            username = lib.removeSuffix ".nix" filename;
            userConfig = import (usersDir + "/${filename}") { inherit pkgs lib; };
          in
          userConfig // { inherit username; }
        ) (lib.attrNames nixFiles)
      );

  # Create systemd services for cloning dotfiles
  dotfilesServices = lib.listToAttrs (
    lib.map (userConfig: {
      name = "clone-dotfiles-${userConfig.username}";
      value = {
        description = "Clone dotfiles repository for ${userConfig.username}";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = userConfig.username;
          Group = "users";
          RemainAfterExit = true;
          ExecStart =
            let
              cloneScript = pkgs.writeShellScript "clone-dotfiles-${userConfig.username}" ''
                set -euo pipefail

                DOTFILES_DIR="$HOME/.dotfiles"
                REPO_URL="${userConfig.dotfilesRepo}"

                # Only clone if directory doesn't exist or is empty
                if [[ ! -d "$DOTFILES_DIR" ]] || [[ -z "$(ls -A "$DOTFILES_DIR" 2>/dev/null)" ]]; then
                  echo "Cloning dotfiles repository to $DOTFILES_DIR"
                  ${pkgs.git}/bin/git clone "$REPO_URL" "$DOTFILES_DIR"
                else
                  echo "Dotfiles directory already exists and is not empty, skipping clone"
                fi
              '';
            in
            "${cloneScript}";
        };
        # Only run if the user exists on the system
        unitConfig.ConditionUser = userConfig.username;
      };
    }) dotfilesUserConfigs
  );
in
{
  config = lib.mkIf (dotfilesUserConfigs != [ ]) {
    # Install git and home-manager for dotfiles users
    environment.systemPackages = [
      pkgs.git
      pkgs.home-manager
    ];

    # Create systemd services to clone dotfiles repositories
    systemd.services = dotfilesServices;
  };
}
