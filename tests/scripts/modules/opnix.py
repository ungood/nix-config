# === OpNix Module Tests ===
print("=== Running OpNix Module Tests ===")

# Test onepassword-secrets service is enabled and running
print("🔍 Testing onepassword-secrets service...")
machine.succeed("systemctl is-enabled onepassword-secrets")
machine.succeed("systemctl is-active onepassword-secrets")
print("✅ onepassword-secrets service is enabled and running")

# Test opnix binary is available
print("🔍 Testing opnix binary...")
machine.succeed("which opnix")
machine.succeed("opnix --help")
print("✅ opnix binary is available")

# Test secrets directory exists with proper permissions
print("🔍 Testing secrets directory...")
machine.succeed("test -d /run/secrets")
machine.succeed("stat -c '%a' /run/secrets | grep -E '^7[05]0$'")  # 700 or 750 permissions
print("✅ secrets directory exists with proper permissions")

# Test user password secrets exist
print("🔍 Testing user password secrets...")
machine.succeed("test -f /run/secrets/ungood-password")
machine.succeed("test -f /run/secrets/trafficcone-password")
print("✅ user password secrets exist")

# Test secret files have correct permissions (600)
print("🔍 Testing secret file permissions...")
machine.succeed("stat -c '%a' /run/secrets/ungood-password | grep '^600$'")
machine.succeed("stat -c '%a' /run/secrets/trafficcone-password | grep '^600$'")
print("✅ secret files have correct permissions")

# Test secret files are owned by root
print("🔍 Testing secret file ownership...")
machine.succeed("stat -c '%U:%G' /run/secrets/ungood-password | grep '^root:root$'")
machine.succeed("stat -c '%U:%G' /run/secrets/trafficcone-password | grep '^root:root$'")
print("✅ secret files are owned by root")

# Test secrets contain valid password hashes
print("🔍 Testing secret content format...")
machine.succeed("grep -E '^\\$[0-9]+\\$' /run/secrets/ungood-password")
machine.succeed("grep -E '^\\$[0-9]+\\$' /run/secrets/trafficcone-password")
print("✅ secrets contain valid password hash format")

print("🎉 OpNix module tests completed!")
