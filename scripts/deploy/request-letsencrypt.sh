#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ ! -f .env ]]; then
  echo ".env not found. Copy .env.example to .env first."
  exit 1
fi

set -a
source .env
set +a

DOMAIN_NAME="${DOMAIN_NAME:-}"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-}"
CERTBOT_DOMAINS="${CERTBOT_DOMAINS:-}"

if [[ -z "${DOMAIN_NAME}" || -z "${CERTBOT_EMAIL}" ]]; then
  echo "DOMAIN_NAME and CERTBOT_EMAIL must be set in .env"
  exit 1
fi

mkdir -p deploy/certbot/etc deploy/certbot/lib deploy/certbot/log deploy/certbot/www deploy/certs

DOMAINS_CSV="${CERTBOT_DOMAINS:-${DOMAIN_NAME}}"
IFS=',' read -r -a DOMAIN_ARRAY <<< "${DOMAINS_CSV}"

DOMAIN_ARGS=()
for domain in "${DOMAIN_ARRAY[@]}"; do
  trimmed="$(echo "${domain}" | xargs)"
  if [[ -n "${trimmed}" ]]; then
    DOMAIN_ARGS+=("-d" "${trimmed}")
  fi
done

if [[ ${#DOMAIN_ARGS[@]} -eq 0 ]]; then
  echo "No valid domains found for certificate request."
  exit 1
fi

echo "Starting HTTP stack for ACME challenge..."
docker compose up -d mysql server web

echo "Requesting Let's Encrypt certificate for: ${DOMAINS_CSV}"
docker run --rm \
  -v "${REPO_ROOT}/deploy/certbot/etc:/etc/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/lib:/var/lib/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/log:/var/log/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/www:/var/www/certbot" \
  certbot/certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  --email "${CERTBOT_EMAIL}" \
  --agree-tos \
  --no-eff-email \
  "${DOMAIN_ARGS[@]}"

bash scripts/deploy/sync-letsencrypt-certs.sh

echo "Certificate request completed."
echo "Now switch to HTTPS with:"
echo "  bash scripts/deploy/deploy-https.sh"
