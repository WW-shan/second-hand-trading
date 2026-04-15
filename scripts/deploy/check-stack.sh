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

echo "== docker compose ps =="
docker compose ps

echo
echo "== web check =="
curl -I --max-time 10 "http://127.0.0.1:${WEB_PORT}/" || true

echo
echo "== api check =="
curl --max-time 10 "http://127.0.0.1:${WEB_PORT}/api/idle/find?page=1&nums=1" || true

echo
echo "== recent logs =="
docker compose logs --tail=30 web server mysql || true
