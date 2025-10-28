#!/usr/bin/env bash
# whatdidido.sh
# Show today's commits from the current branch in a pretty way.

TODAY=$(date +%Y-%m-%d)

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Not a git repository."
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🌿 Branch: $BRANCH"
echo "📅 Commits made today ($TODAY):"
echo "----------------------------------"

COMMITS=$(git log --since="$TODAY 00:00" --until="now" \
  --pretty=format:"• %C(yellow)%h%Creset %Cgreen%an%Creset: %s" \
  --abbrev-commit)

if [ -z "$COMMITS" ]; then
  echo "No commits found for today."
else
  echo "$COMMITS"
fi

echo "----------------------------------"
echo "🕒 $(date)"
