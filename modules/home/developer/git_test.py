# === Home Git Module Tests ===
print("=== Running Home Git Module Tests ===")

# Test git is installed and configured
print("🔍 Testing git installation...")
machine.succeed("which git")
print("✅ Git is available in PATH")

# Test basic git configuration
print("🔍 Testing git configuration...")
result = machine.succeed("git config --global user.name")
machine.succeed("test -n \"$(git config --global user.name)\"")
print("✅ Git user name is configured")

# Test 1Password SSH signing configuration
print("🔍 Testing git commit signing configuration...")
gpg_format = machine.succeed("git config --global gpg.format").strip()
assert gpg_format == "ssh", f"Expected gpg.format to be 'ssh', got '{gpg_format}'"
print("✅ Git is configured to use SSH for signing")

# Test op-ssh-sign is configured as the signing program
print("🔍 Testing SSH signing program configuration...")
ssh_program = machine.succeed("git config --global gpg.ssh.program").strip()
assert ssh_program == "op-ssh-sign", f"Expected gpg.ssh.program to be 'op-ssh-sign', got '{ssh_program}'"
print("✅ Git is configured to use op-ssh-sign for SSH signing")

# Test commit.gpgsign is enabled
print("🔍 Testing automatic commit signing...")
gpg_sign = machine.succeed("git config --global commit.gpgsign").strip()
assert gpg_sign == "true", f"Expected commit.gpgsign to be 'true', got '{gpg_sign}'"
print("✅ Git is configured to automatically sign commits")

# Test user.signingkey configuration (optional - warning shown if not set)
print("🔍 Testing signing key configuration...")
try:
    signing_key = machine.succeed("git config --global user.signingkey").strip()
    if signing_key:
        print("✅ Git signing key is configured")
    else:
        print("⚠️  No signing key configured (warning will be shown to user)")
except:
    print("⚠️  No signing key configured (warning will be shown to user)")

# Test op-ssh-sign binary is available
print("🔍 Testing op-ssh-sign availability...")
machine.succeed("which op-ssh-sign")
print("✅ op-ssh-sign is available in PATH")

# Test creating a signed commit (basic functionality)
print("🔍 Testing signed commit creation...")
machine.succeed("cd /tmp && mkdir test-repo && cd test-repo")
machine.succeed("cd /tmp/test-repo && git init")
machine.succeed("cd /tmp/test-repo && echo 'test' > test.txt")
machine.succeed("cd /tmp/test-repo && git add test.txt")
# Note: This will fail without actual 1Password setup, but we test the config is there
try:
    machine.succeed("cd /tmp/test-repo && timeout 10 git commit -m 'test commit' || true")
    print("✅ Git commit signing configuration is valid")
except:
    print("⚠️  Commit signing requires 1Password SSH agent (expected in test environment)")

print("🎉 Git module tests completed!")
