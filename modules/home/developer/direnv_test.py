# === Home Developer Direnv Module Tests ===
print("=== Running Home Developer Direnv Module Tests ===")

# Test direnv is available in user PATH
print("🔍 Testing direnv availability...")
machine.succeed("sudo -u ungood -i which direnv")
print("✅ direnv is available in user PATH")

# Test basic direnv functionality with temporary .envrc
print("🔍 Testing direnv basic functionality...")
machine.succeed('sudo -u ungood -i fish -c "cd /tmp && echo \\"export TEST_VAR=hello_direnv\\" > .envrc && direnv allow . && direnv export json >/dev/null"')
print("✅ direnv can process .envrc files")

print("🎉 Home Developer Direnv module tests completed!")
