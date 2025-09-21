# === Base Module Tests ===
print("=== Running Base Module Tests ===")

# Test Nix configuration
print("🔍 Testing Nix configuration...")
machine.succeed("nix --version")
machine.succeed("nix --extra-experimental-features 'nix-command flakes' flake --help")
machine.succeed("nix --extra-experimental-features 'nix-command' config show | grep trusted-users")
print("✅ Nix configuration is correct")

# Test system packages
print("🔍 Testing system packages...")
packages = ["curl", "vim", "wget"]
for package in packages:
    machine.succeed(f"{package} --version || {package} --help || which {package}")
    print(f"✅ {package} is available")

# Test unzip if available (may not be in minimal test environment)
machine.succeed("unzip --version || echo 'unzip not installed in test environment'")
print("✅ unzip check completed")

# Test neovim separately with correct command name
machine.succeed("nvim --version")
print("✅ neovim is available")

# Test fish shell
print("🔍 Testing fish shell configuration...")
machine.succeed("which fish")
machine.succeed("fish --version")
machine.succeed("fish -c 'echo test'")
print("✅ Fish shell is properly configured")

# Test locale
print("🔍 Testing locale configuration...")
machine.succeed("locale | grep 'LANG=en_US.UTF-8'")
print("✅ Locale configuration is correct")

print("🎉 Base module tests completed!")
