#!/bin/bash

# Check worktrees status and report old/excessive worktrees

set -e

# Current branch
echo "$ git branch --show-current"
current_branch=$(git branch --show-current)
echo "$current_branch"
echo

# Fetch remote main
echo "$ git fetch origin main"
git fetch origin main 2>&1 | grep -v "^From" | grep -v "^remote:" || true
echo

# Check if remote is ahead
echo "$ git log HEAD..origin/main --oneline"
remote_commits=$(git log HEAD..origin/main --oneline 2>/dev/null || echo "")
if [ -n "$remote_commits" ]; then
    commit_count=$(echo "$remote_commits" | wc -l | tr -d ' ')
    echo "Remote is ahead by $commit_count commits"
else
    echo "Remote is up to date"
fi

echo

# Get list of worktrees (excluding main worktree)
echo "Worktrees:"
worktrees=$(git worktree list --porcelain | grep -E "^worktree " | awk '{print $2}' | tail -n +2)

if [ -z "$worktrees" ]; then
    echo "  none"
    exit 0
fi

# Count worktrees
count=$(echo "$worktrees" | wc -l | tr -d ' ')

# Check each worktree
current_date=$(date +%s)
thirty_days_ago=$((current_date - 30*24*60*60))

old_worktrees=()
merged_worktrees=()

while IFS= read -r worktree_path; do
    branch=$(cd "$worktree_path" && git branch --show-current)
    last_commit_date=$(cd "$worktree_path" && git log -1 --format=%ct 2>/dev/null || echo "0")
    is_merged=$(git branch --merged main | grep -w "$branch" || echo "")
    days_ago=$(( (current_date - last_commit_date) / 86400 ))

    status=""
    if [ "$last_commit_date" -lt "$thirty_days_ago" ]; then
        old_worktrees+=("$worktree_path")
        status="[inactive ${days_ago}d]"
    fi

    if [ -n "$is_merged" ]; then
        merged_worktrees+=("$worktree_path")
        status="$status [merged]"
    fi

    echo "$branch - $worktree_path $status"
done <<< "$worktrees"

# Summary
if [ "$count" -gt 5 ]; then
    echo
    echo "Warning: $count worktrees (consider cleanup)"
fi

if [ ${#old_worktrees[@]} -gt 0 ] || [ ${#merged_worktrees[@]} -gt 0 ]; then
    echo
    echo "Cleanup candidates:"
    for wt in "${old_worktrees[@]}" "${merged_worktrees[@]}"; do
        echo "  $wt"
    done
fi
