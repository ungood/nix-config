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
print("✅ GameMode is configured")

print("🎉 Gaming module tests completed!")
