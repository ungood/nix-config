#!/usr/bin/env bash
set -euo pipefail

# NixOS Installation Script with disko-install
# Usage: install-nixos.sh [CONFIG] [DISK]
#   CONFIG: Configuration name (optional, will prompt if not provided)
#   DISK: Target disk device path (optional, will prompt if not provided)

echo "🚀 NixOS Installation"

# Available configurations
CONFIGS=(sparrowhawk logos)

# Get configuration from argument or prompt
if [[ ${1:-} ]]; then
    CONFIG="$1"

    # Validate the provided configuration
    if [[ ! " ${CONFIGS[*]} " =~ " ${CONFIG} " ]]; then
        gum log -l error "Invalid configuration '$CONFIG'"
        echo "Available configurations: ${CONFIGS[*]}"
        exit 1
    fi
else
    # Interactive selection
    CONFIG=$(gum choose --header "Select configuration to install:" "${CONFIGS[@]}")

    if [[ -z "$CONFIG" ]]; then
        echo "No configuration selected. Exiting."
        exit 1
    fi
fi

echo "Selected configuration: $CONFIG"

# Get disk from argument or prompt
if [[ ${2:-} ]]; then
    DISK="$2"
    echo "Using provided disk: $DISK"

    # Validate the provided disk exists
    if [[ ! -b "$DISK" ]]; then
        echo "Error: $DISK does not exist!"
        exit 1
    fi
else
    # Interactive selection
    echo "Available disks:"
    lsblk -d -o PATH,SIZE,MODEL
    echo

    # Get list of available disks with full paths
    AVAILABLE_DISKS=$(lsblk -dno PATH)

    # Select disk from list
    DISK=$(gum choose --header "Select disk to install to:" ${AVAILABLE_DISKS})

    if [[ ! -b "$DISK" ]]; then
        gum log -l error "$DISK does not exist!"
        exit 1
    fi
fi


# Final confirmation (skip if both arguments were provided)
if [[ ! ${1:-} || ! ${2:-} ]]; then
    gum log -l info "Installing $CONFIG on $DISK"
    gum log -l warn "All data on $DISK will be DESTROYED!"

    if ! gum confirm "Proceed with installation?"; then
        echo "Installation cancelled."
        exit 0
    fi
fi

gum log -l info "Starting disko-install..."

# Use disko-install with the flake (all dependencies are pre-loaded in the store)
# Force offline mode by setting NIX options
disko-install \
    --flake "/etc/nixos-configs#$CONFIG" \
    --disk main "$DISK"
