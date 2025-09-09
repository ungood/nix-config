---
description: "Format Nix files using nixfmt"
argument-hint: "[file-pattern]"
allowed-tools: "Bash(nixfmt:*), Bash(find:*), Glob"
---
Format Nix files consistently using nixfmt. If no files are specified, formats all .nix files in the repository.

Format files: $ARGUMENTS

!find . -name "*.nix" -not -path "./.git/*" -exec nixfmt {} \;