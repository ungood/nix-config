# === Users Module Tests ===
print("=== Running Users Module Tests ===")

# Test basic user configuration
print("🔍 Testing basic user configuration...")
machine.succeed("id ungood")
machine.succeed("id abirdnamed")
print("✅ Users are configured correctly")

# Wait for network to be ready
print("🔍 Waiting for network connectivity...")
machine.wait_for_unit("network-online.target")
print("✅ Network is ready")

# Wait for the dotfiles service to complete
print("🔍 Waiting for dotfiles service to complete...")
machine.wait_for_unit("dotfiles-ungood.service")
print("✅ Dotfiles service has completed")

# Test dotfiles repository for ungood (should exist after service runs)
print("🔍 Testing dotfiles repository for ungood...")
ungood_dotfiles = machine.succeed("su - ungood -c 'test -d ~/.dotfiles && echo exists || echo missing'").strip()
assert ungood_dotfiles == "exists", f"Expected ungood's dotfiles to exist, but got: {ungood_dotfiles}"

# Verify it's a git repository
machine.succeed("su - ungood -c 'test -d ~/.dotfiles/.git'")

# Verify the remote URL is correct
remote_url = machine.succeed("su - ungood -c 'cd ~/.dotfiles && git config --get remote.origin.url'").strip()
assert "github.com/ungood/dotfiles" in remote_url, f"Expected ungood's dotfiles remote to be github.com/ungood/dotfiles, got: {remote_url}"

# Verify ownership is correct
owner = machine.succeed("stat -c '%U:%G' /home/ungood/.dotfiles").strip()
assert owner == "ungood:ungood", f"Expected ungood:ungood ownership, got: {owner}"

# Verify actual files were cloned (check for README or other expected file)
machine.succeed("su - ungood -c 'test -f ~/.dotfiles/README.md || test -f ~/.dotfiles/.gitignore || ls ~/.dotfiles/'")

print("✅ ungood's dotfiles are properly configured and cloned")

# Test that abirdnamed does NOT have dotfiles (not configured)
print("🔍 Testing that abirdnamed has no dotfiles...")
abirdnamed_dotfiles = machine.succeed("su - abirdnamed -c 'test -d ~/.dotfiles && echo exists || echo missing'").strip()
assert abirdnamed_dotfiles == "missing", f"Expected abirdnamed's dotfiles to be missing, but got: {abirdnamed_dotfiles}"
print("✅ abirdnamed correctly has no dotfiles")

print("🎉 Users module tests completed!")
