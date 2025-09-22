---
name: sync
description: Sync changes to the current branch by pulling, rebasing, and pushing
---

Sync the current branch with the remote repository by pulling latest changes, rebasing local commits, and pushing.

## Workflow
1. Fetch latest changes from remote
2. Show current branch status
3. Pull with rebase to maintain clean history
4. Push local commits to remote if needed
5. Show final status

## Safety Checks
- Ensures working tree is clean before syncing
- Shows divergence from remote before actions
- Handles both ahead and behind scenarios
- Preserves local work while integrating remote changes

## Usage
Run without arguments to sync current branch with its remote tracking branch.

$ARGUMENTS
