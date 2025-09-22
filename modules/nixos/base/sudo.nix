{ pkgs, ... }:
{
  # Install required packages for SSH agent authentication
  environment.systemPackages = with pkgs; [
    pam_ssh_agent_auth
  ];

  # Configure authentication and sudo together
  security = {
    # Configure sudo to require SSH key authentication
    sudo = {
      enable = true;
      # Disable password-based sudo authentication
      wheelNeedsPassword = false;
      # Ensure SSH agent socket is preserved in sudo environment
      extraConfig = ''
        # Preserve SSH agent authentication socket
        Defaults env_keep += "SSH_AUTH_SOCK"
      '';
    };

    # Configure PAM for sudo to use SSH agent authentication
    pam.services.sudo = {
      text = ''
        # Account management
        account required pam_unix.so

        # Session management
        session required pam_unix.so

        # Authentication - SSH agent authentication ONLY
        # This requires SSH_AUTH_SOCK to be set and a valid SSH key loaded
        auth sufficient pam_ssh_agent_auth.so file=/etc/ssh/authorized_keys/%u
        auth required pam_deny.so
      '';
    };
  };

  # Create authorized keys directory structure
  system.activationScripts.sudo-ssh-keys = ''
    mkdir -p /etc/ssh/authorized_keys
    chmod 755 /etc/ssh/authorized_keys

    # Create authorized keys files for users (placeholder content)
    # In production, these should contain the actual SSH public keys from 1Password
    if [ ! -f /etc/ssh/authorized_keys/ungood ]; then
      echo "# SSH public key for ungood sudo access" > /etc/ssh/authorized_keys/ungood
      echo "# This should be replaced with the actual SSH public key from 1Password" >> /etc/ssh/authorized_keys/ungood
      chmod 644 /etc/ssh/authorized_keys/ungood
    fi

    if [ ! -f /etc/ssh/authorized_keys/trafficcone ]; then
      echo "# SSH public key for trafficcone sudo access" > /etc/ssh/authorized_keys/trafficcone
      echo "# This should be replaced with the actual SSH public key from 1Password" >> /etc/ssh/authorized_keys/trafficcone
      chmod 644 /etc/ssh/authorized_keys/trafficcone
    fi
  '';

  # Enable SSH agent forwarding
  programs.ssh = {
    startAgent = true;
    agentTimeout = "4h";
  };
}
