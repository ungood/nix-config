# === Development Module Tests ===
print("=== Running Development Module Tests ===")

# Test Git configuration
print("🔍 Testing Git configuration...")
machine.succeed("git --version")
machine.succeed("git lfs version")

# Test basic Git functionality
machine.succeed("git config --global user.name 'Test User'")
machine.succeed("git config --global user.email 'test@example.com'")
machine.succeed("git init /tmp/test-repo")
machine.succeed("cd /tmp/test-repo && echo 'test' > README.md")
machine.succeed("cd /tmp/test-repo && git add README.md")
machine.succeed("cd /tmp/test-repo && git commit -m 'Initial commit'")
print("✅ Git is properly configured")

# Test development tools
print("🔍 Testing development tools...")
tools = ["curl", "wget", "vim"]
for tool in tools:
    machine.succeed(f"which {tool}")
    print(f"✅ {tool} is available")

# Test neovim separately with correct command name
machine.succeed("which nvim")
print("✅ neovim is available")

# Test Nix development environment
print("🔍 Testing Nix development environment...")
machine.succeed("nix --extra-experimental-features 'nix-command flakes' flake --help")
print("✅ Nix development tools are working")

# Test shell environment
print("🔍 Testing shell environment...")
machine.succeed("fish --version")
machine.succeed("echo $PATH | grep -q /nix/store")
print("✅ Shell environment is configured for development")

# Test file operations
print("🔍 Testing file operations...")
machine.succeed("echo 'Hello World' > /tmp/test.txt")
machine.succeed("cat /tmp/test.txt | grep 'Hello World'")
machine.succeed("chmod +x /tmp/test.txt")
machine.succeed("ls -la /tmp/test.txt | grep -q 'x'")
print("✅ File operations work correctly")

print("🎉 Development module tests completed!")
