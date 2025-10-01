_: {
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      MaxAuthTries = 3;
    };

    openFirewall = true;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    jails.sshd.settings = {
      enabled = true;
      filter = "sshd";
    };
  };
}
