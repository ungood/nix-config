# === Home Manager Two-Tier Configuration Tests ===
print("=== Running Home Manager Two-Tier Configuration Tests ===")

# Test that home-manager package is available for users with dotfilesRepo
print("🔍 Testing home-manager availability for dotfiles users...")
machine.succeed("which home-manager")
print("✅ home-manager command is available for standalone configuration")

print("🎉 Home Manager two-tier configuration tests completed!")
