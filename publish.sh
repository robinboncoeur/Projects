#!/bin/bash

# Stop immediately if something fails
set -e

# Make sure we're in the repository containing this script
cd "$(dirname "$0")"

# Require a commit message
if [ "$#" -eq 0 ]; then
    echo "Usage: ./publish What I changed"
    exit 1
fi

MESSAGE="$*"

echo
echo "Changes:"
git status --short
echo

# Stage everything
git add -A

# Don't make an empty commit
if git diff --cached --quiet; then
    echo "Nothing to publish."
    exit 0
fi

# Commit
git commit -m "$MESSAGE"

# Push to GitHub
git push

echo
echo "✓ Published successfully."
