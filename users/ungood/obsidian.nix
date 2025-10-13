let
  vaultDir = "notes";
in
{
  programs.obsidian = {
    enable = true;

    vaults = {
      memex = {
        enable = true;
        target = "${vaultDir}/memex";
      };

    };
  };
}
