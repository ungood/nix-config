# === User Dotfiles Module Tests ===
print("=== Running User Dotfiles Module Tests ===")

# Test that users with dotfilesRepo get standalone home-manager setup
print("🔍 Testing standalone home-manager setup for dotfiles users...")
# Check that standalone home-manager is installed for users with dotfilesRepo
machine.succeed("which home-manager")
print("✅ Standalone home-manager is available")

print("🎉 User dotfiles module tests completed!")
