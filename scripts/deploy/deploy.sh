#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ ! -f .env ]]; then
  echo ".env not found. Copy .env.example to .env first."
  exit 1
fi

mkdir -p deploy-data/mysql backups userFile

if grep -q "change-me-root-password" .env || grep -q "change-me-app-password" .env; then
  echo "Please replace the default passwords in .env before deployment."
  exit 1
fi

docker compose build
if ! docker compose up -d; then
  echo
  echo "Deployment failed. Recent MySQL logs:"
  docker compose logs --tail=120 mysql || true
  echo
  echo "If this is a broken first-time init, try:"
  echo "  bash scripts/deploy/reset-demo-data.sh"
  exit 1
fi

echo
echo "Deployment started."
echo "Run: bash scripts/deploy/check-stack.sh"
