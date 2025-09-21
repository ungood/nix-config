#!/usr/bin/env bash
# .claude/scripts/check-nix-shell.sh
#
# Script to check if Claude Code is running within a nix shell.
# Returns 0 if in nix shell, 1 otherwise.

if [[ -n "$IN_NIX_SHELL" ]]; then
    echo "✓ Claude session is running in nix shell (IN_NIX_SHELL=$IN_NIX_SHELL)"
    exit 0
else
    echo "✗ Claude session is NOT in a nix shell!" >&2
    echo "Did you forget to 'just dev'?" >&2
    exit 1
fi
