---
description: "Clean up old Nix generations and store paths"
allowed-tools: "Bash(just:*), Bash(nix-collect-garbage:*)"
---
Run garbage collection to free up disk space by removing old generations and unused store paths.

!just gc