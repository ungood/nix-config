# Custom NixOS installer ISO using disko-install
{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Available host configurations (update when adding new hosts)
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "install-nixos" ''
      set -euo pipefail

      echo "🚀 NixOS Installation with disko-install"
      echo

      # Select configuration
      CONFIGS=(sparrowhawk logos)
      CONFIG=$(gum choose --header "Select configuration to install:" "''${CONFIGS[@]}")

      if [[ -z "$CONFIG" ]]; then
          echo "No configuration selected. Exiting."
          exit 1
      fi

      echo "Selected configuration: $CONFIG"
      echo

      # List available disks
      echo "Available disks:"
      lsblk -d -o NAME,SIZE,MODEL | grep -E '^(sd|nvme|vd)' || true
      echo

      # Select disk
      DISK=$(gum input --placeholder "Enter disk name (e.g., sda, nvme0n1)")

      if [[ ! -b "/dev/$DISK" ]]; then
          gum style --foreground 196 "Error: /dev/$DISK does not exist!"
          exit 1
      fi

      # Get disk ID
      DISK_ID=$(ls -la /dev/disk/by-id/ | grep -E "''${DISK}$" | awk '{print $9}' | head -n1 || true)
      if [[ -z "$DISK_ID" ]]; then
          gum style --foreground 196 "Error: Could not determine disk ID for $DISK"
          exit 1
      fi

      # Final confirmation
      gum style --border double --align center --width 50 --margin "1 2" --padding "2 4" \
          "$(gum style --foreground 196 'WARNING')

      All data on /dev/$DISK will be DESTROYED!
      Configuration: $CONFIG
      Disk ID: $DISK_ID"

      if ! gum confirm "Proceed with installation?"; then
          echo "Installation cancelled."
          exit 0
      fi

      # Run disko-install
      gum style --foreground 82 "Starting installation..."
      exec ${disko}/bin/disko-install \
          --flake "/etc/nixos-config#$CONFIG" \
          --disk main "/dev/disk/by-id/$DISK_ID"
    '')
    gum
    disko
  ];

  # Copy the flake source to the ISO for offline installation
  environment.etc."nixos-config".source = lib.cleanSource ../.;

  services.getty.helpLine = "Run 'install-nixos' to install NixOS!";

  # Enable SSH for remote installation if needed
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  networking.networkmanager.enable = true;

  image.fileName = "nixos-custom-installer.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
