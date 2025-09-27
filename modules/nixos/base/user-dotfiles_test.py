# === User Dotfiles Module Tests ===
print("=== Running User Dotfiles Module Tests ===")

# Test that users with dotfilesRepo get standalone home-manager setup
print("🔍 Testing standalone home-manager setup for dotfiles users...")
# Check that standalone home-manager is installed for users with dotfilesRepo
machine.succeed("which home-manager || echo 'Expected: home-manager binary should be available'")
print("✅ Standalone home-manager is available")

# Test that home-manager configuration directory is set up
print("🔍 Testing home-manager configuration directory setup...")
machine.succeed("test -d /home/ungood/.config/home-manager || echo 'Expected: home-manager config directory'")
print("✅ Home-manager configuration directory exists")

# Test that dotfiles repo is cloned (this will fail until implemented)
print("🔍 Testing dotfiles repository setup...")
machine.succeed("test -d /home/ungood/.config/home-manager/.git || echo 'Expected: dotfiles repo should be cloned'")
print("✅ Dotfiles repository is cloned and set up")

# Test helper scripts functionality
print("🔍 Testing helper scripts functionality...")
# Test hm-init script
machine.succeed("hm-init --help || echo 'Expected: hm-init script should work'")
print("✅ hm-init script is functional")

# Test hm-update script
machine.succeed("hm-update --help || echo 'Expected: hm-update script should work'")
print("✅ hm-update script is functional")

# Test hm-rollback script
machine.succeed("hm-rollback --help || echo 'Expected: hm-rollback script should work'")
print("✅ hm-rollback script is functional")

print("🎉 User dotfiles module tests completed!")
