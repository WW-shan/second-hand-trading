#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

mkdir -p deploy/certbot/etc deploy/certbot/lib deploy/certbot/log deploy/certbot/www deploy/certs

echo "Renewing Let's Encrypt certificates..."
docker run --rm \
  -v "${REPO_ROOT}/deploy/certbot/etc:/etc/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/lib:/var/lib/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/log:/var/log/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/www:/var/www/certbot" \
  certbot/certbot renew --webroot --webroot-path /var/www/certbot

bash scripts/deploy/sync-letsencrypt-certs.sh

if docker compose -f docker-compose.yml -f docker-compose.https.yml ps web >/dev/null 2>&1; then
  docker compose -f docker-compose.yml -f docker-compose.https.yml exec web nginx -s reload || true
fi

echo "Renewal finished."
