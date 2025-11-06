# Sets up a simple python dev environment using uv for simple scripts.
# More complicated python projects should use their own dev shell.
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    python3
  ];

  programs.uv = {
    enable = true;

    settings = {
      python-downloads = "never";
    };
  };
}
