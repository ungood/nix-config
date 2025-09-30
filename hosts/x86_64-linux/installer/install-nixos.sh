#!/usr/bin/env bash
set -euo pipefail

# NixOS Installation Script with disko-install
# Usage: install-nixos.sh [CONFIG] [DISK]
#   CONFIG: Configuration name (optional, will prompt if not provided)
#   DISK: Target disk device name (optional, will prompt if not provided)

echo "🚀 NixOS Installation with disko-install"
echo

# Available configurations
CONFIGS=(sparrowhawk logos)

# Get configuration from argument or prompt
if [[ ${1:-} ]]; then
    CONFIG="$1"
    echo "Using provided configuration: $CONFIG"

    # Validate the provided configuration
    if [[ ! " ${CONFIGS[*]} " =~ " ${CONFIG} " ]]; then
        echo "Error: Invalid configuration '$CONFIG'"
        echo "Available configurations: ${CONFIGS[*]}"
        exit 1
    fi
else
    # Interactive selection
    CONFIG=$(gum filter --header "Select configuration to install:" "${CONFIGS[@]}")

    if [[ -z "$CONFIG" ]]; then
        echo "No configuration selected. Exiting."
        exit 1
    fi
fi

echo "Selected configuration: $CONFIG"
echo

# Get disk from argument or prompt
if [[ ${2:-} ]]; then
    DISK="$2"
    echo "Using provided disk: $DISK"

    # Validate the provided disk exists
    if [[ ! -b "/dev/$DISK" ]]; then
        echo "Error: /dev/$DISK does not exist!"
        exit 1
    fi
else
    # Interactive selection
    echo "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^(sd|nvme|vd)' || true
    echo

    # Get list of available disks
    AVAILABLE_DISKS=($(lsblk -d -n -o NAME | grep -E '^(sd|nvme|vd)' || true))

    if [[ ${#AVAILABLE_DISKS[@]} -eq 0 ]]; then
        gum style --foreground 196 "Error: No suitable disks found!"
        exit 1
    fi

    # Select disk from list
    DISK=$(gum filter --header "Select disk to install to:" "${AVAILABLE_DISKS[@]}")

    if [[ -z "$DISK" ]]; then
        echo "No disk selected. Exiting."
        exit 1
    fi

    if [[ ! -b "/dev/$DISK" ]]; then
        gum style --foreground 196 "Error: /dev/$DISK does not exist!"
        exit 1
    fi
fi

# Get disk ID
DISK_ID=$(ls -la /dev/disk/by-id/ | grep -E "${DISK}$" | awk '{print $9}' | head -n1 || true)
if [[ -z "$DISK_ID" ]]; then
    gum style --foreground 196 "Error: Could not determine disk ID for $DISK"
    exit 1
fi

# Final confirmation (skip if both arguments were provided)
if [[ ! ${1:-} || ! ${2:-} ]]; then
    gum style --border double --align center --width 50 --margin "1 2" --padding "2 4" \
        "$(gum style --foreground 196 'WARNING')

All data on /dev/$DISK will be DESTROYED!
Configuration: $CONFIG
Disk ID: $DISK_ID"

    if ! gum confirm "Proceed with installation?"; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# Run disko-install
gum style --foreground 82 "Starting installation..."
exec disko-install \
    --flake "/etc/nixos-config#$CONFIG" \
    --disk main "/dev/disk/by-id/$DISK_ID"
