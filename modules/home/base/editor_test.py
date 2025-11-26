# === Home Editor Module Tests ===
print("=== Running Home Editor Module Tests ===")

# Test that edit command is available (run as ungood user, not root)
print("🔍 Testing edit command availability...")
machine.succeed("su - ungood -c 'which edit'")
print("✅ edit command is available in PATH")

# Test edit command with VISUAL environment variable
print("🔍 Testing edit command with VISUAL variable...")
# Create a simple test script that just exits successfully
machine.succeed("echo '#!/bin/sh' > /tmp/test_editor")
machine.succeed("echo 'echo test_visual_editor' >> /tmp/test_editor")
machine.succeed("chmod +x /tmp/test_editor")

# Test that VISUAL takes precedence (run as ungood user)
result = machine.succeed("su - ungood -c 'VISUAL=/tmp/test_editor edit /dev/null 2>&1' || true")
assert "test_visual_editor" in result, f"Expected test_visual_editor in output, got: {result}"
print("✅ edit command uses VISUAL when set")

# Test edit command with EDITOR environment variable (when VISUAL is not set)
print("🔍 Testing edit command with EDITOR variable...")
machine.succeed("echo '#!/bin/sh' > /tmp/test_editor2")
machine.succeed("echo 'echo test_editor_variable' >> /tmp/test_editor2")
machine.succeed("chmod +x /tmp/test_editor2")

result = machine.succeed("su - ungood -c 'unset VISUAL; EDITOR=/tmp/test_editor2 edit /dev/null 2>&1' || true")
assert "test_editor_variable" in result, f"Expected test_editor_variable in output, got: {result}"
print("✅ edit command uses EDITOR when VISUAL is not set")

# Test fallback to nano when neither VISUAL nor EDITOR is set
print("🔍 Testing edit command fallback to nano...")
# Test that nano is available as fallback (run as ungood user)
machine.succeed("su - ungood -c 'which nano'")
print("✅ nano is available as fallback editor")

print("🎉 Home editor module tests completed!")
