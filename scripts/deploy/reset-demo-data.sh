#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

docker compose down
rm -rf deploy-data/mysql
mkdir -p deploy-data/mysql
docker compose up -d

echo "Demo database volume reset. MySQL will re-import second_hand_trading.sql on first startup."
