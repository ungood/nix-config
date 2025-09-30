#!/usr/bin/env bash
# NixOS Installation Script with disko
# This script handles interactive installation of NixOS configurations

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Function to list available configurations
list_configurations() {
    print_color "$BLUE" "Available configurations:"
    echo "1) sparrowhawk - Gaming PC configuration"
    echo "2) logos - Framework 13 laptop configuration"
}

# Function to list available disks
list_disks() {
    print_color "$BLUE" "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^(sd|nvme|vd)'
}

# Main installation process
main() {
    print_color "$GREEN" "=========================================="
    print_color "$GREEN" "    NixOS Installation Script"
    print_color "$GREEN" "=========================================="
    echo

    # Select configuration
    list_configurations
    echo
    read -p "Select configuration (1-2): " config_choice

    case $config_choice in
        1)
            CONFIG_NAME="sparrowhawk"
            ;;
        2)
            CONFIG_NAME="logos"
            ;;
        *)
            print_color "$RED" "Invalid selection!"
            exit 1
            ;;
    esac

    print_color "$GREEN" "Selected configuration: $CONFIG_NAME"
    echo

    # Select disk
    list_disks
    echo
    print_color "$YELLOW" "WARNING: The selected disk will be completely ERASED!"
    read -p "Enter the disk to install to (e.g., sda, nvme0n1): " disk_name

    # Validate disk exists
    if [[ ! -b "/dev/$disk_name" ]]; then
        print_color "$RED" "Error: /dev/$disk_name does not exist!"
        exit 1
    fi

    DISK="/dev/$disk_name"
    print_color "$GREEN" "Selected disk: $DISK"
    echo

    # Get disk ID for disko configuration
    DISK_ID=$(ls -la /dev/disk/by-id/ | grep -E "${disk_name}$" | awk '{print $9}' | head -n1)
    if [[ -z "$DISK_ID" ]]; then
        print_color "$RED" "Error: Could not determine disk ID for $disk_name"
        exit 1
    fi

    # Final confirmation
    print_color "$RED" "╔══════════════════════════════════════════════╗"
    print_color "$RED" "║              FINAL WARNING                  ║"
    print_color "$RED" "╠══════════════════════════════════════════════╣"
    print_color "$RED" "║  ALL DATA ON $DISK WILL BE DESTROYED!       ║"
    print_color "$RED" "║  Configuration: $CONFIG_NAME                ║"
    print_color "$RED" "╚══════════════════════════════════════════════╝"
    echo
    read -p "Type 'DESTROY' to confirm and proceed with installation: " confirmation

    if [[ "$confirmation" != "DESTROY" ]]; then
        print_color "$YELLOW" "Installation cancelled."
        exit 0
    fi

    print_color "$GREEN" "Starting installation..."
    echo

    # Create temporary disko configuration with actual disk ID
    TEMP_DISKO="/tmp/disko-config.nix"
    cp "/etc/nixos-installer/hosts/$CONFIG_NAME/disko.nix" "$TEMP_DISKO"
    sed -i "s|/dev/disk/by-id/to-be-replaced|/dev/disk/by-id/$DISK_ID|g" "$TEMP_DISKO"

    # Format disk with disko
    print_color "$BLUE" "Formatting disk with disko..."
    nix run github:nix-community/disko -- --mode disko "$TEMP_DISKO"

    # Install NixOS
    print_color "$BLUE" "Installing NixOS configuration..."
    nixos-install --flake "/etc/nixos-installer#$CONFIG_NAME" --no-root-password

    print_color "$GREEN" "=========================================="
    print_color "$GREEN" "    Installation Complete!"
    print_color "$GREEN" "=========================================="
    print_color "$YELLOW" "Please remove the installation media and reboot."
    echo
    read -p "Press Enter to reboot or Ctrl+C to exit to shell..."
    reboot
}

# Run main function
main "$@"