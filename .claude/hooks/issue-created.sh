#!/usr/bin/env bash
# Hook triggered when a GitHub issue is created
# Automatically starts the research and design phase

set -euo pipefail

ISSUE_NUMBER="$1"
ISSUE_TITLE="$2"

echo "🔬 Starting research phase for issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}"

# Trigger research agent via Claude Code
claude research "${ISSUE_NUMBER}"

echo "✅ Research phase completed for issue #${ISSUE_NUMBER}"
