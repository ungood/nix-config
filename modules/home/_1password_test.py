# === Home 1Password Module Tests ===
print("=== Running Home 1Password Module Tests ===")

# Test 1Password autostart desktop entry creation (for centrally managed users)
print("🔍 Testing 1Password autostart desktop entry for centrally managed users...")
# Since ungood has dotfilesRepo, test with trafficcone who doesn't
machine.succeed("test -f /home/trafficcone/.config/autostart/1password-autostart.desktop")
print("✅ 1Password autostart desktop entry exists for centrally managed users")

# Test desktop entry content
print("🔍 Testing autostart desktop entry content...")
desktop_content = machine.succeed("cat /home/trafficcone/.config/autostart/1password-autostart.desktop")
machine.succeed("grep -q 'Exec=1password --silent' /home/trafficcone/.config/autostart/1password-autostart.desktop")
machine.succeed("grep -q 'Name=1Password' /home/trafficcone/.config/autostart/1password-autostart.desktop")
print("✅ Desktop entry has correct autostart configuration")

# Test that 1Password GUI package is available
print("🔍 Testing 1Password GUI availability...")
machine.succeed("which 1password")
print("✅ 1Password GUI is available in PATH")

print("🎉 Home 1Password module tests completed!")
