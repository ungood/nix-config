# === Desktop Flatpak Module Tests ===
print("=== Running Desktop Flatpak Module Tests ===")

# Test Flatpak service configuration
print("🔍 Testing Flatpak service...")
machine.succeed("which flatpak")
print("✅ Flatpak binary is available")

# Test Flatpak installation
print("🔍 Testing Flatpak installation...")
machine.succeed("flatpak --version")
print("✅ Flatpak is installed and functional")

# Test Flathub repository systemd service exists
print("🔍 Testing Flathub repository systemd service...")
machine.succeed("systemctl list-unit-files | grep flatpak-repo-setup")
print("✅ Flathub repository systemd service is configured")

# Test KDE Discover installation
print("🔍 Testing KDE Discover installation...")
machine.succeed("which plasma-discover")
print("✅ KDE Discover is installed")

# Test XDG Desktop Portal is enabled
print("🔍 Testing XDG Desktop Portal configuration...")
# Check that xdg.portal is configured (it starts on-demand, not at boot)
machine.succeed("test -d /run/current-system/sw/share/xdg-desktop-portal/portals || test -d /usr/share/xdg-desktop-portal/portals || systemctl --user list-unit-files | grep xdg-desktop-portal")
print("✅ XDG Desktop Portal is configured for Flatpak integration")

print("🎉 Desktop Flatpak module tests completed!")
