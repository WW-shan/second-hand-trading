#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ ! -f .env ]]; then
  echo ".env not found. Copy .env.example to .env first."
  exit 1
fi

mkdir -p deploy/certs deploy/certbot/www deploy-data/mysql backups userFile

if [[ ! -f deploy/certs/fullchain.pem || ! -f deploy/certs/privkey.pem ]]; then
  echo "Missing TLS certificate files."
  echo "Expected:"
  echo "  deploy/certs/fullchain.pem"
  echo "  deploy/certs/privkey.pem"
  exit 1
fi

if ! grep -q '^PUBLIC_BASE_URL=https://' .env; then
  echo "Warning: PUBLIC_BASE_URL in .env does not start with https://"
  echo "It should normally be something like:"
  echo "  PUBLIC_BASE_URL=https://your-domain"
fi

docker compose -f docker-compose.yml -f docker-compose.https.yml build
docker compose -f docker-compose.yml -f docker-compose.https.yml up -d

echo
echo "HTTPS deployment started."
echo "Run: bash scripts/deploy/check-https.sh"
