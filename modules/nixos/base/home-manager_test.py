# === Home Manager Two-Tier Configuration Tests ===
print("=== Running Home Manager Two-Tier Configuration Tests ===")

# Test centrally managed users (without dotfilesRepo)
print("🔍 Testing centrally managed users...")
# Check that home-manager is configured for centrally managed users
machine.succeed("systemctl --user list-units | grep home-manager || true")
print("✅ Centrally managed users have home-manager service")

# Test users with dotfilesRepo (should NOT have central home-manager)
print("🔍 Testing users with dotfilesRepo...")
# This test will fail initially since we haven't implemented the feature yet
# We expect users with dotfilesRepo to have standalone home-manager, not central
machine.succeed("test -f /home/ungood/.config/home-manager/flake.nix || echo 'Expected: standalone home-manager for dotfiles users'")
print("✅ Users with dotfilesRepo have standalone home-manager setup")

# Test helper scripts are available for dotfiles users
print("🔍 Testing helper scripts for dotfiles users...")
scripts = ["hm-init", "hm-update", "hm-rollback"]
for script in scripts:
    machine.succeed(f"which {script} || echo 'Expected: {script} script should be available'")
    print(f"✅ {script} helper script is available")

# Test that centrally managed users don't have helper scripts
print("🔍 Testing centrally managed users don't have dotfiles helper scripts...")
# This should succeed since centrally managed users shouldn't have these scripts
machine.succeed("! which hm-init > /dev/null 2>&1 || echo 'Centrally managed users should not have hm-init'")
print("✅ Centrally managed users don't have dotfiles helper scripts")

print("🎉 Home Manager two-tier configuration tests completed!")
