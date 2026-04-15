#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

WEB_PORT="${HTTP_PORT:-80}"
SSL_PORT="${HTTPS_PORT:-443}"

echo "== docker compose ps =="
docker compose -f docker-compose.yml -f docker-compose.https.yml ps

echo
echo "== http redirect check =="
curl -I --max-time 10 "http://127.0.0.1:${WEB_PORT}/" || true

echo
echo "== https web check =="
curl -k -I --max-time 10 "https://127.0.0.1:${SSL_PORT}/" || true

echo
echo "== https api check =="
curl -k --max-time 10 "https://127.0.0.1:${SSL_PORT}/api/idle/find?page=1&nums=1" || true

echo
echo "== recent logs =="
docker compose -f docker-compose.yml -f docker-compose.https.yml logs --tail=30 web server mysql || true
