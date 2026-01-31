#!/usr/bin/env bash
set -euo pipefail

start_dir=$(pwd)
home_dir=$(cd ~ && pwd)

declare -a search_roots=()
current="$start_dir"

while true; do
  search_roots+=("$current")
  if [[ "$current" == "$home_dir" ]]; then
    break
  fi
  parent=$(dirname "$current")
  if [[ "$parent" == "$current" ]]; then
    break
  fi
  current="$parent"
done

known_rel=(
  ".claude/skills"
  ".config/opencode/skills"
  ".codex/skills"
  ".config/codex/skills"
  ".gemini/skills"
  ".config/gemini/skills"
  ".cursor/skills"
  ".config/cursor/skills"
  "skills"
)

declare -A found_paths=()
for root in "${search_roots[@]}"; do
  scope="project"
  if [[ "$root" == "$home_dir" ]]; then
    scope="user"
  fi
  for rel in "${known_rel[@]}"; do
    candidate="$root/$rel"
    if [[ -d "$candidate" ]]; then
      found_paths["$candidate"]="$scope"
    fi
  done
done

if [[ ${#found_paths[@]} -eq 0 ]]; then
  echo "No well-known Agent Skill directories detected between $start_dir and $home_dir."
  exit 1
fi

echo "Detected Agent Skill directories:"
for path in $(printf '%s
  echo "- scope=${found_paths[$path]} path=$path"
done
