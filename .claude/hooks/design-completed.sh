#!/usr/bin/env bash
# Hook triggered when research/design phase is completed
# Automatically starts the implementation phase

set -euo pipefail

ISSUE_NUMBER="$1"
ISSUE_TITLE="$2"

echo "🚀 Starting implementation phase for issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}"

# Trigger implementation agent via Claude Code
claude implement "${ISSUE_NUMBER}"

echo "✅ Implementation phase completed for issue #${ISSUE_NUMBER}"
