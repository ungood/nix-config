# Multi-User Setup with 1Password Integration

This guide explains how to set up and use the multi-user configuration with 1Password password management.

## Prerequisites

1. **1Password Account** with vault access
2. **1Password Service Account** with read permissions to your vault
3. **Pre-hashed passwords** stored in 1Password

## Setup Instructions

### 1. Create 1Password Service Account

1. Go to your 1Password account settings
2. Create a new Service Account with read permissions to the vault containing user passwords
3. Save the service account token securely

### 2. Prepare User Passwords

Generate hashed passwords for each user:

```bash
# For ungood user
mkpasswd -m sha-512
# Enter the desired password when prompted
# Copy the resulting hash

# For trafficcone user
mkpasswd -m sha-512
# Enter the desired password when prompted
# Copy the resulting hash
```

### 3. Store Passwords in 1Password

Create secure notes in your 1Password vault:

- **Item 1**: `ungood-nixos-password`
  - Add field: `hashed_password` = (the hash from mkpasswd)

- **Item 2**: `trafficcone-nixos-password`
  - Add field: `hashed_password` = (the hash from mkpasswd)

### 4. Configure Service Account Token

Create the environment file for opnix:

```bash
sudo nano /etc/opnix.env
```

Add your service account token:
```
OP_SERVICE_ACCOUNT_TOKEN=your_service_account_token_here
```

Set appropriate permissions:
```bash
sudo chmod 600 /etc/opnix.env
sudo chown root:root /etc/opnix.env
```

### 5. Update 1Password References (if needed)

If your vault name or item names differ from the defaults, update `modules/nixos/opnix.nix`:

```nix
secrets = {
  "ungood-password" = {
    source = ''{{ op://YourVault/your-ungood-item/hashed_password }}'';
    user = "root";
    mode = "0600";
  };

  "trafficcone-password" = {
    source = ''{{ op://YourVault/your-trafficcone-item/hashed_password }}'';
    user = "root";
    mode = "0600";
  };
};
```

## Building and Switching

Build and apply the configuration:

```bash
# Test the configuration
just check

# Build without applying
just build

# Apply the configuration
just switch
```

## Current Users

The configuration currently supports:

- **ungood**: Primary user (Jason Walker)
- **trafficcone**: Secondary user

Both users have:
- Fish shell as default
- Access to 1Password GUI and CLI
- Same application set via shared home-manager configuration
- Immutable passwords managed via 1Password

## Adding New Users

To add a new user:

1. **Update user configuration** in `modules/nixos/users.nix`
2. **Create user directories** in `users/newuser/`
3. **Add 1Password secret** to `modules/nixos/opnix.nix`
4. **Update polkit owners** in `modules/nixos/1password.nix`
5. **Store hashed password** in 1Password vault

## Security Features

- **Immutable users**: `users.mutableUsers = false` prevents runtime user modifications
- **1Password integration**: Passwords stored securely in 1Password
- **Shared configuration**: Reduces duplication while maintaining per-user flexibility
- **Polkit integration**: Both users can access 1Password system features

## Troubleshooting

### Build Issues
- Verify all 1Password items exist and are accessible
- Check service account token permissions
- Ensure `/etc/opnix.env` has correct permissions

### Login Issues
- Verify password hashes are correctly generated with `mkpasswd -m sha-512`
- Check that 1Password items contain the `hashed_password` field
- Confirm vault references in opnix configuration match your 1Password setup

### Home Manager
- System-level home-manager works correctly
- Standalone home configurations may have compatibility issues with current home-manager version
- Use `just switch` to apply both system and home-manager configurations together
