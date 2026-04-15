#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ ! -f .env ]]; then
  echo ".env not found."
  exit 1
fi

set -a
source .env
set +a

mkdir -p backups
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_FILE="backups/second_hand_trading-${STAMP}.sql"

docker compose exec -T mysql mysqldump \
  -uroot \
  -p"${MYSQL_ROOT_PASSWORD}" \
  "${MYSQL_DATABASE:-second_hand_trading}" > "${OUT_FILE}"

echo "Database backup created: ${OUT_FILE}"
