# NixOS Testing Infrastructure

This directory contains the automated testing infrastructure for NixOS configurations using the `runNixOSTest` framework.

## Directory Structure

```
tests/
├── README.md            # This documentation
├── default.nix         # Main test entry point
├── lib/                 # Test helper functions
│   └── default.nix      # Core testing utilities
├── hosts/               # Host-specific tests
├── modules/             # Module-specific tests
└── common/              # Shared test utilities
    └── basic-smoke-test.nix  # Basic infrastructure validation
```

## Usage

### Running All Tests

```bash
# Run all tests
just test

# Or directly with nix
nix build .#checks.x86_64-linux -L
```

### Running Specific Tests

```bash
# Run a specific test by name
just test-name basic-smoke-test

# Or directly with nix
nix build .#checks.x86_64-linux.basic-smoke-test -L
```

### Interactive Testing

For debugging and development, you can run tests in interactive mode:

```bash
# Start interactive test environment
just test-interactive

# Or manually
nix build .#checks.x86_64-linux.basic-smoke-test.driverInteractive
./result/bin/nixos-test-driver
```

In the interactive Python console, you can:
- `start_all()` - Start all VMs
- `machine.succeed("command")` - Run commands
- `machine.screenshot("filename")` - Take screenshots
- `machine.shell_interact()` - Get an interactive shell

## Creating New Tests

### Host-Specific Tests

Create test files in `tests/hosts/` directory:

```nix
# tests/hosts/sparrowhawk.nix
{ lib, pkgs, inputs, mkNixOSTest, mkHostTest, mkModuleTest }:

mkHostTest "sparrowhawk" {
  imports = [
    ../../hosts/x86_64-linux/sparrowhawk
  ];
}
```

### Module-Specific Tests

Create test files in `tests/modules/` directory:

```nix
# tests/modules/plasma.nix
{ lib, pkgs, inputs, mkNixOSTest, mkHostTest, mkModuleTest }:

mkModuleTest "plasma" ../../modules/nixos/desktop/plasma.nix
```

### Custom Tests

Create test files in `tests/common/` directory:

```nix
# tests/common/my-test.nix
{ lib, pkgs, inputs, mkNixOSTest, mkHostTest, mkModuleTest }:

mkNixOSTest {
  name = "my-test";

  nodes.machine = {
    # Your configuration here
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")

    # Your test commands here
    machine.succeed("echo 'Test passed'")
  '';
}
```

## Helper Functions

The testing infrastructure provides several helper functions:

### `mkNixOSTest`

Creates a basic NixOS test with sensible defaults:
- 2GB RAM minimum
- 8GB disk space
- 2 CPU cores
- Headless mode (no graphics)

### `mkHostTest`

Creates a test for a specific host configuration.

### `mkModuleTest`

Creates a test for a specific NixOS module.

### `mkSmokeTest`

Creates a basic smoke test that verifies the system boots and basic functionality works.

## VM Configuration

Tests run in QEMU virtual machines with the following default configuration:

- **Memory**: 2GB (configurable)
- **Disk**: 8GB ephemeral storage
- **CPU**: 2 cores
- **Graphics**: Headless (can be enabled for desktop testing)
- **Network**: Isolated test network

## Best Practices

1. **Start Simple**: Begin with basic smoke tests before adding complex functionality tests
2. **Use Timeouts**: Always use appropriate `wait_for_*` functions for service startup
3. **Test Incrementally**: Break complex tests into smaller, focused test cases
4. **Clean Up**: Tests use ephemeral VMs, so no manual cleanup is needed
5. **Documentation**: Document complex test scenarios and expected behavior

## Troubleshooting

### Test Failures

- Check VM logs: Tests run with `-L` flag to show build logs
- Use interactive mode for debugging: `just test-interactive`
- Verify VM resources are sufficient for the test

### Performance Issues

- Increase VM memory if tests are slow or fail due to resource constraints
- Consider running tests in parallel with `nix build -j<N>`
- Use `nix-collect-garbage` to free up disk space

### Common Issues

- **Service startup timeouts**: Increase timeout values or check service dependencies
- **Missing packages**: Ensure required packages are included in test configuration
- **Graphics issues**: Use headless mode unless specifically testing desktop functionality

## Integration with Development Workflow

The testing infrastructure integrates with the existing development workflow:

- Tests are automatically discovered and included in flake outputs
- `just test` command runs all tests
- Tests can be run individually for faster feedback
- Interactive mode available for debugging

This testing infrastructure provides a solid foundation for validating NixOS configurations and catching issues before deployment.
