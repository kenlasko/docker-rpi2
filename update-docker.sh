_#!/bin/bash
set -e
cd /docker

# Fetch remote changes
git fetch origin

# Check if anything actually changed
if ! git diff --quiet HEAD origin/main; then
  echo "$(date): Changes detected, pulling and redeploying..."
  git pull origin main
  docker compose pull
  docker compose up -d
else
  echo "$(date): No changes, skipping update."
fi
