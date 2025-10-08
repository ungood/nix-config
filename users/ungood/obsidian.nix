let
  vaultDir = "notes";
in
{
  programs.obsidian = {
    enable = true;

    vaults = {
      memory = {
        enable = true;
        target = "${vaultDir}/memory";
      };

    };
  };
}
