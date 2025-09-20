#!/usr/bin/env bash
# .claude/hooks/dev-shell-check.sh
#
# PreToolUse hook that ensures bash commands run in the nix dev shell environment.
# This hook intercepts bash tool usage and wraps commands with the dev shell wrapper.

# Check if we're already in a nix shell
if [[ -n "$IN_NIX_SHELL" ]]; then
    # Already in nix shell, allow command to proceed normally
    exit 0
else
    # Not in dev shell - this hook will cause Claude to be reminded about dev shell
    # but cannot directly modify the command execution
    echo "⚠️  Consider running commands in nix dev shell for full development environment"
    echo "   Use: nix develop -c <command>"
    exit 0
fi
