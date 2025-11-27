# === Development Module Tests ===
print("=== Running Development Module Tests ===")

# The development module now only provides system-level requirements for development.
# Git and other development tools have been moved to Home Manager.
# This test just verifies that the module loads without errors.

print("✅ Development module loaded successfully (provides Docker support)")

# Test development tools that are still at system level
print("🔍 Testing system-level development tools...")
tools = ["curl", "nvim", "wget", "vim"]
for tool in tools:
    machine.succeed(f"which {tool}")
    print(f"✅ {tool} is available")

# Test shell environment
print("🔍 Testing shell environment...")
machine.succeed("fish --version")
print("✅ Shell environment is configured")

print("🎉 Development module tests completed!")
