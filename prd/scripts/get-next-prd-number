#!/bin/bash

# Get the next PRD number by scanning existing files in spec/ directory
# Outputs the next number formatted as 4-digit with leading zeros (e.g., 0008)

SPEC_DIR="${1:-.}/spec"

if [ ! -d "$SPEC_DIR" ]; then
    echo "0001"
    exit 0
fi

# Find the highest existing PRD number
highest=$(ls "$SPEC_DIR" 2>/dev/null | grep -oE '^[0-9]{4}' | sort -n | tail -1)

if [ -z "$highest" ]; then
    echo "0001"
else
    # Remove leading zeros, increment, and reformat
    next=$((10#$highest + 1))
    printf "%04d\n" "$next"
fi
