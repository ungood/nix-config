# === Desktop Printing Module Tests ===
print("=== Running Desktop Printing Module Tests ===")

# Test CUPS printing service configuration
print("🔍 Testing CUPS printing service...")
# Check if CUPS binaries are available
machine.succeed("which cupsd")
machine.succeed("which lpadmin")
print("✅ CUPS binaries are available")

# Test Avahi mDNS service for printer discovery
print("🔍 Testing Avahi mDNS service...")
machine.wait_for_unit("avahi-daemon.service")
machine.succeed("systemctl is-active avahi-daemon.service")
print("✅ Avahi daemon is active for printer discovery")

print("🎉 Desktop Printing module tests completed!")
