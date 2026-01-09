#!/bin/bash
# Gather context for GitHub PR decisions

echo '$ pwd'
pwd

echo ''
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo '$ git rev-parse --abbrev-ref HEAD'
echo "$BRANCH"

echo ''
echo '$ git log --oneline --decorate -n 20'
git log --oneline --decorate -n 20

echo ''
echo '$ git status -sb'
git status -sb

echo ''
echo '$ gh pr list --head '"$BRANCH"' --state open --json number,url,title,body'
gh pr list --head "$BRANCH" --state open --json number,url,title,body 2>/dev/null || echo "(gh cli not available)"

echo ''
echo '$ git log origin/'"$BRANCH"'..HEAD --oneline'
git log origin/"$BRANCH"..HEAD --oneline 2>/dev/null || echo "(remote branch does not exist)"

echo ''
echo '$ cat .github/pull_request_template.md'
cat .github/pull_request_template.md 2>/dev/null || cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || echo "(no template)"

echo ''
echo '$ git diff origin/main...HEAD --stat | tail -10'
git diff origin/main...HEAD --stat 2>/dev/null | tail -10 || echo "(could not diff against main)"
