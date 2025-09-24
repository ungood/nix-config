# === Development Module Tests ===
print("=== Running Development Module Tests ===")

# Test Git configuration
print("🔍 Testing Git configuration...")
machine.succeed("git --version")
machine.succeed("git lfs version")
print("✅ Git is properly configured")

# Test development tools
print("🔍 Testing development tools...")
tools = ["curl", "nvim", "wget", "vim"]
for tool in tools:
    machine.succeed(f"which {tool}")
    print(f"✅ {tool} is available")

# Test shell environment
print("🔍 Testing shell environment...")
machine.succeed("fish --version")
# TODO: Test that fish is the default shell for a user.
print("✅ Shell environment is configured for development")

print("🎉 Development module tests completed!")
