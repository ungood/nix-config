# System-wide 1Password configuration
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "ungood" "trafficcone" ];
  };

  # TODO: Shell Plugins https://developer.1password.com/docs/cli/shell-plugins/nix/
}
