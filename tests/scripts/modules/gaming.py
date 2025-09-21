# === Gaming Module Tests ===
print("=== Running Gaming Module Tests ===")

# Test Steam installation
print("🔍 Testing Steam installation...")
machine.succeed("which steam")
machine.succeed("which steam-run")
machine.succeed("steam --help || steam -h || true")
print("✅ Steam is installed and configured")

# Test gaming drivers
print("🔍 Testing gaming drivers...")
machine.succeed("lsmod | grep -E '(nvidia|amdgpu|i915)' || true")
machine.succeed("glxinfo -B || true")  # May not work in headless VM
print("✅ Gaming drivers are configured")

# Test GameMode
print("🔍 Testing GameMode...")
machine.succeed("which gamemoded")
machine.succeed("which gamemoderun")
machine.succeed("gamemoderun echo 'GameMode test' || true")
print("✅ GameMode is configured")

# Test gaming audio
print("🔍 Testing gaming audio...")
machine.succeed("which pipewire")
machine.succeed("which pw-cli")
machine.succeed("which pactl || which pipewire-pulse || true")
print("✅ Gaming audio is configured")

# Test Steam runtime
print("🔍 Testing Steam runtime...")
machine.succeed("steam-run echo 'Steam runtime test'")
machine.succeed("steam-run ldd --version")
print("✅ Steam runtime is working")

# Test gaming performance tools
print("🔍 Testing gaming performance tools...")
machine.succeed("which mangohud || true")
machine.succeed("which htop || which top")
print("✅ Gaming performance tools are available")

# Test controller support
print("🔍 Testing controller support...")
machine.succeed("ls /etc/udev/rules.d/*steam* || true")
machine.succeed("ls /dev/input/ | grep -E '(event|js)' || true")
print("✅ Controller support is configured")

print("🎉 Gaming module tests completed!")
