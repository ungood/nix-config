# Install language servers common to extensions for various editors,
# including the Claude Code LSP plugins enabled in settings.json.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools # clangd
    csharp-ls
    gopls
    nil
    nixd
    pyright
    rust-analyzer
    typescript-language-server
  ];
}
