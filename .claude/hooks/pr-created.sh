#!/usr/bin/env bash
# Hook triggered when a pull request is created
# Automatically starts the review and testing phase

set -euo pipefail

PR_NUMBER="$1"
PR_TITLE="$2"

echo "🔍 Starting review phase for PR #${PR_NUMBER}: ${PR_TITLE}"

# Trigger review agent via Claude Code
claude review-pr "${PR_NUMBER}"

echo "✅ Review phase completed for PR #${PR_NUMBER}"
