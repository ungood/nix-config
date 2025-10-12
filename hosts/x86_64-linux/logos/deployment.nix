{
  onetrue.deployment = {
    enable = true;
    role = "node";
    managedBy = "sparrowhawk";
  };

  deployment = {
    targetHost = "logos.onetrue.name";
    tags = [
      "laptop"
      "mobile"
    ];
  };
}
