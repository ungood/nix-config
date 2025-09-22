# === Agenix Module Tests ===
print("=== Running Agenix Module Tests ===")

# Test agenix service is enabled and running
print("🔍 Testing agenix service...")
machine.succeed("systemctl is-enabled agenix")
machine.succeed("systemctl is-active agenix")
print("✅ agenix service is enabled and running")

# Test agenix binary is available
print("🔍 Testing agenix binary...")
machine.succeed("which agenix")
machine.succeed("agenix --help")
print("✅ agenix binary is available")

# Test secrets directory exists with proper permissions
print("🔍 Testing secrets directory...")
machine.succeed("test -d /run/agenix")
machine.succeed("stat -c '%a' /run/agenix | grep -E '^7[05]0$'")  # 700 or 750 permissions
print("✅ secrets directory exists with proper permissions")

# Test user password secrets exist
print("🔍 Testing user password secrets...")
machine.succeed("test -f /run/agenix/ungood-password")
machine.succeed("test -f /run/agenix/trafficcone-password")
print("✅ user password secrets exist")

# Test secret files have correct permissions (600)
print("🔍 Testing secret file permissions...")
machine.succeed("stat -c '%a' /run/agenix/ungood-password | grep '^600$'")
machine.succeed("stat -c '%a' /run/agenix/trafficcone-password | grep '^600$'")
print("✅ secret files have correct permissions")

# Test secret files are owned by root
print("🔍 Testing secret file ownership...")
machine.succeed("stat -c '%U:%G' /run/agenix/ungood-password | grep '^root:root$'")
machine.succeed("stat -c '%U:%G' /run/agenix/trafficcone-password | grep '^root:root$'")
print("✅ secret files are owned by root")

# Test secrets contain valid password hashes
print("🔍 Testing secret content format...")
machine.succeed("grep -E '^\\$[0-9]+\\$' /run/agenix/ungood-password")
machine.succeed("grep -E '^\\$[0-9]+\\$' /run/agenix/trafficcone-password")
print("✅ secrets contain valid password hash format")

print("🎉 Agenix module tests completed!")
