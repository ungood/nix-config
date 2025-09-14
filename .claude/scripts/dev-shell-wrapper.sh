#!/usr/bin/env bash
# .claude/scripts/dev-shell-wrapper.sh
#
# Shell wrapper that ensures commands run in the nix dev shell environment.
# This provides Claude Code with access to all development tools and ensures
# consistency between human and AI development workflows.

# Check if we're already in a nix shell
if [[ -n "$IN_NIX_SHELL" ]]; then
    # Already in nix shell, execute command directly
    exec "$@"
else
    # Enter dev shell and execute command
    cd "$(dirname "$0")/../.." # Navigate to repo root
    exec nix develop -c "$@"
fi
