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

PRIMARY_DOMAIN="${DOMAIN_NAME:-}"
if [[ -z "${PRIMARY_DOMAIN}" ]]; then
  echo "DOMAIN_NAME is not set in .env"
  exit 1
fi

SRC_DIR="deploy/certbot/etc/live/${PRIMARY_DOMAIN}"
DEST_DIR="deploy/certs"

if [[ ! -f "${SRC_DIR}/fullchain.pem" || ! -f "${SRC_DIR}/privkey.pem" ]]; then
  echo "Certificate files not found under ${SRC_DIR}"
  exit 1
fi

mkdir -p "${DEST_DIR}"
cp "${SRC_DIR}/fullchain.pem" "${DEST_DIR}/fullchain.pem"
cp "${SRC_DIR}/privkey.pem" "${DEST_DIR}/privkey.pem"

echo "Synced certificate files into ${DEST_DIR}"
