{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Find users with dotfilesRepo
  dotfilesUsers = lib.filter (
    username:
    let
      userConfig = import (usersDir + "/${username}.nix") { inherit pkgs lib; };
    in
    userConfig ? dotfilesRepo && userConfig.dotfilesRepo != null
  ) (lib.mapAttrsToList (filename: _: lib.removeSuffix ".nix" filename) nixFiles);

  # Helper scripts for dotfiles users
  helperScripts = pkgs.writeScriptBin "dotfiles-helpers" ''
    #!/usr/bin/env bash

    # Create helper scripts for home-manager dotfiles management

    cat > /usr/local/bin/hm-init << 'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    # Initialize home-manager standalone configuration
    if [ ! -d "$HOME/.config/home-manager" ]; then
      echo "Setting up home-manager configuration directory..."
      mkdir -p "$HOME/.config/home-manager"

      # If user has a dotfiles repo, clone it
      if [ -n "''${DOTFILES_REPO:-}" ]; then
        echo "Cloning dotfiles repository: $DOTFILES_REPO"
        git clone "$DOTFILES_REPO" "$HOME/.config/home-manager"
      else
        echo "Creating basic home-manager configuration..."
        cat > "$HOME/.config/home-manager/home.nix" << 'HOMEEOF'
    { config, pkgs, ... }:

    {
      home.username = "$(whoami)";
      home.homeDirectory = "/home/$(whoami)";
      home.stateVersion = "25.05";

      programs.home-manager.enable = true;
    }
    HOMEEOF
        cat > "$HOME/.config/home-manager/flake.nix" << 'FLAKEEOF'
    {
      description = "Home Manager configuration";

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };
      };

      outputs = { nixpkgs, home-manager, ... }:
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.''${system};
        in {
          homeConfigurations."$(whoami)" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
          };
        };
    }
    FLAKEEOF
      fi
    else
      echo "Home-manager configuration already exists at ~/.config/home-manager"
    fi

    echo "To activate your configuration, run: hm-update"
    EOF

    cat > /usr/local/bin/hm-update << 'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Updating home-manager configuration..."
    cd "$HOME/.config/home-manager"

    # Update flake inputs if it's a flake
    if [ -f "flake.nix" ]; then
      nix flake update
      home-manager switch --flake .
    else
      home-manager switch
    fi

    echo "Home-manager configuration updated successfully!"
    EOF

    cat > /usr/local/bin/hm-rollback << 'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Rolling back home-manager configuration..."
    home-manager generations
    echo
    echo "To rollback to a specific generation, run:"
    echo "  /nix/store/PATH_TO_GENERATION/activate"
    echo
    read -p "Enter generation path to rollback to (or press Enter to cancel): " gen_path

    if [ -n "$gen_path" ] && [ -x "$gen_path/activate" ]; then
      echo "Rolling back to $gen_path..."
      "$gen_path/activate"
      echo "Rollback completed!"
    else
      echo "Rollback cancelled or invalid path."
    fi
    EOF

    # Make scripts executable
    chmod +x /usr/local/bin/hm-init /usr/local/bin/hm-update /usr/local/bin/hm-rollback

    echo "Helper scripts installed: hm-init, hm-update, hm-rollback"
  '';

  # Service to install helper scripts for dotfiles users
  installHelperScripts = pkgs.writeShellScript "install-dotfiles-helpers" ''
    # Create /usr/local/bin if it doesn't exist
    mkdir -p /usr/local/bin

    # Install helper scripts
    ${helperScripts}/bin/dotfiles-helpers

    # Set environment variables for users with dotfiles repos
    ${lib.concatMapStringsSep "\n" (
      username:
      let
        userConfig = import (usersDir + "/${username}.nix") { inherit pkgs lib; };
      in
      "echo 'export DOTFILES_REPO=\"${userConfig.dotfilesRepo}\"' >> /home/${username}/.bashrc || true"
    ) dotfilesUsers}
  '';
in
{
  config = lib.mkIf (dotfilesUsers != [ ]) {
    # Install standalone home-manager for dotfiles users
    environment.systemPackages = [
      pkgs.home-manager
    ];

    # Install helper scripts via systemd service
    systemd.services.install-dotfiles-helpers = {
      description = "Install helper scripts for dotfiles users";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${installHelperScripts}";
        RemainAfterExit = true;
      };
    };

    # Create user accounts for dotfiles users (they still need system accounts)
    users.users = lib.listToAttrs (
      map (
        username:
        let
          userConfig = import (usersDir + "/${username}.nix") { inherit pkgs lib; };
          baseConfig = userConfig.nixos // {
            group = username; # Set group to username automatically
          };
          # Use password from secrets flake (required for all users)
          finalConfig = baseConfig // {
            hashedPassword = inputs.secrets.passwords.${username};
          };
        in
        {
          name = username;
          value = finalConfig;
        }
      ) dotfilesUsers
    );

    # Generate user groups for dotfiles users
    users.groups = lib.listToAttrs (
      map (username: {
        name = username;
        value = { };
      }) dotfilesUsers
    );
  };
}
