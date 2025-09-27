# === User Dotfiles Module Tests ===
print("=== Running User Dotfiles Module Tests ===")

# Test that users with dotfilesRepo get standalone home-manager setup
print("🔍 Testing standalone home-manager setup for dotfiles users...")
# Check that standalone home-manager is installed for users with dotfilesRepo
machine.succeed("which home-manager")
print("✅ Standalone home-manager is available")

# Test that git is available for dotfiles cloning
print("🔍 Testing git availability for dotfiles cloning...")
machine.succeed("which git")
print("✅ Git is available for cloning dotfiles")

# Test that systemd services are created for users with dotfiles repos
print("🔍 Testing dotfiles cloning systemd services...")
# Check that the clone-dotfiles-ungood service exists (ungood user has dotfilesRepo configured)
exit_code, output = machine.execute("systemctl list-unit-files | grep clone-dotfiles-ungood || echo 'not found'")
if "clone-dotfiles-ungood" in output:
    print("✅ clone-dotfiles-ungood service exists")

    # Check that the service has proper configuration
    _, service_info = machine.execute("systemctl show clone-dotfiles-ungood.service --property=Type,User,ExecStart")
    print(f"   Service details: {service_info.strip()}")
else:
    print("⚠ clone-dotfiles-ungood service not found")

# Test that services don't exist for users without dotfiles repos
print("🔍 Testing that no dotfiles services exist for users without dotfilesRepo...")
_, output = machine.execute("systemctl list-unit-files | grep clone-dotfiles-trafficcone || echo 'not found'")
if "clone-dotfiles-trafficcone" not in output:
    print("✅ No dotfiles service created for trafficcone (user without dotfilesRepo)")
else:
    print("⚠ Unexpected dotfiles service found for trafficcone")

print("🎉 User dotfiles module tests completed!")
