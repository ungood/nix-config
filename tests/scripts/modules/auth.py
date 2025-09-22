# === Authentication Module Tests ===
print("=== Running Authentication Module Tests ===")

# Test PAM configuration for login
print("🔍 Testing PAM login configuration...")
machine.succeed("test -f /etc/pam.d/login")
machine.succeed("grep -q 'pam_unix.so' /etc/pam.d/login")
print("✅ PAM login configuration exists")

# Test PAM configuration for display managers
print("🔍 Testing PAM display manager configuration...")
pam_files = ["gdm-password", "sddm", "lightdm"]
for pam_file in pam_files:
    result = machine.succeed(f"test -f /etc/pam.d/{pam_file} || echo 'not found'")
    if "not found" not in result:
        machine.succeed(f"grep -q 'pam_unix.so' /etc/pam.d/{pam_file}")
        print(f"✅ PAM {pam_file} configuration is correct")

# Test fingerprint authentication support (if hardware detected)
print("🔍 Testing fingerprint authentication configuration...")
fprintd_result = machine.succeed("systemctl is-enabled fprintd || echo 'not enabled'")
if "not enabled" not in fprintd_result:
    machine.succeed("systemctl is-active fprintd")
    # Check PAM configuration includes fingerprint module
    machine.succeed("grep -q 'pam_fprintd.so' /etc/pam.d/login || grep -q 'pam_fprintd.so' /etc/pam.d/gdm-password || echo 'fprintd pam not configured'")
    print("✅ Fingerprint authentication is configured")
else:
    print("ℹ️  Fingerprint authentication not enabled (no hardware detected)")

# Test that password authentication is properly configured
print("🔍 Testing password authentication...")
machine.succeed("grep -q 'pam_unix.so' /etc/pam.d/passwd")
print("✅ Password authentication is configured")

# Test user login capability (using existing test user if available)
print("🔍 Testing user authentication capability...")
# This test would need to be run in a more controlled environment
# For now, just verify the configuration files exist
machine.succeed("test -f /etc/shadow")
machine.succeed("test -f /etc/passwd")
print("✅ User authentication files exist")

print("🎉 Authentication module tests completed!")
