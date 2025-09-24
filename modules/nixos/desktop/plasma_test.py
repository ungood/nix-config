# === Desktop Plasma Module Tests ===
print("=== Running Desktop Plasma Module Tests ===")

# Test display manager
print("🔍 Testing display manager (SDDM)...")
machine.wait_for_unit("display-manager.service")
machine.succeed("systemctl is-active display-manager.service")
print("✅ Display manager is active")

# Test Plasma packages
print("🔍 Testing Plasma package installation...")
plasma_packages = ["plasmashell", "kwin_x11", "systemsettings", "dolphin"]
for package in plasma_packages:
    machine.succeed(f"which {package}")
    print(f"✅ {package} is installed")

# Test excluded packages are not installed
print("🔍 Testing excluded packages are not present...")
excluded_packages = ["konsole", "kate"]
for package in excluded_packages:
    machine.fail(f"which {package}")
    print(f"✅ {package} is correctly excluded")

# Test desktop services
print("🔍 Testing desktop services...")
machine.wait_for_unit("dbus.service")
machine.succeed("systemctl is-active dbus.service")
machine.wait_for_unit("NetworkManager.service")
machine.succeed("systemctl is-active NetworkManager.service")
print("✅ Desktop services are running")

# Test Wayland configuration (X server is disabled)
print("🔍 Testing Wayland configuration...")
machine.fail("which X || which Xorg")
print("✅ Wayland is configured (X server correctly disabled)")

# Test audio system
print("🔍 Testing audio system...")
machine.succeed("which pipewire")
machine.succeed("which wireplumber")
print("✅ Audio system is configured")

# Test theme support
print("🔍 Testing theme support...")
machine.succeed("ls /nix/store/*breeze* | head -1")
machine.succeed("ls /nix/store/*breeze-icons* | head -1")
print("✅ Theme support is available")

print("🎉 Desktop Plasma module tests completed!")
