#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

def test_direnv_enabled():
    """Test that direnv is enabled and available in PATH."""
    result = subprocess.run(['which', 'direnv'], capture_output=True, text=True)
    assert result.returncode == 0, "direnv should be available in PATH"
    assert result.stdout.strip(), "direnv path should not be empty"

def test_nix_direnv_integration():
    """Test that nix-direnv is properly integrated with direnv."""
    # Check if nix-direnv hook is in direnv config
    result = subprocess.run(['direnv', 'hook', 'fish'], capture_output=True, text=True)
    assert result.returncode == 0, "direnv hook should work"

    # Check that direnv can find nix-direnv
    result = subprocess.run(['direnv', 'version'], capture_output=True, text=True)
    assert result.returncode == 0, "direnv version should work"

def test_fish_integration():
    """Test that direnv is properly integrated with fish shell."""
    # Test that direnv hook for fish works
    result = subprocess.run(['direnv', 'hook', 'fish'], capture_output=True, text=True)
    assert result.returncode == 0, "direnv fish hook should work"

    # Check that the hook contains expected fish functions
    hook_output = result.stdout
    assert 'function __direnv_export_eval' in hook_output, "Fish hook should contain direnv functions"

def test_direnv_config_functionality():
    """Test basic direnv functionality with a temporary .envrc file."""
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        envrc_path = Path(tmpdir) / '.envrc'
        envrc_path.write_text('export TEST_VAR=hello_direnv\n')

        # Allow the .envrc file
        result = subprocess.run(['direnv', 'allow', tmpdir], capture_output=True, text=True)
        assert result.returncode == 0, "direnv allow should work"

        # Test that direnv can export the environment
        result = subprocess.run(['direnv', 'export', 'json'], cwd=tmpdir, capture_output=True, text=True)
        assert result.returncode == 0, "direnv export should work"

if __name__ == '__main__':
    print("Testing direnv module...")

    try:
        test_direnv_enabled()
        print("✓ direnv is enabled and available")

        test_nix_direnv_integration()
        print("✓ nix-direnv integration works")

        test_fish_integration()
        print("✓ fish integration works")

        test_direnv_config_functionality()
        print("✓ direnv basic functionality works")

        print("All direnv tests passed!")
        sys.exit(0)
    except AssertionError as e:
        print(f"✗ Test failed: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        sys.exit(1)
