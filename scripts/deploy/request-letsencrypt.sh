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

if [[ "${DOMAIN_NAME}" == "example.com" || "${CERTBOT_EMAIL}" == "admin@example.com" ]]; then
  echo "Please replace DOMAIN_NAME and CERTBOT_EMAIL in .env with real values before requesting Let's Encrypt certificates."
  exit 1
fi

mkdir -p deploy/certbot/etc deploy/certbot/lib deploy/certbot/log deploy/certbot/www deploy/certs
mkdir -p deploy/certbot/www/.well-known/acme-challenge

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
docker compose up -d mysql server
docker compose up -d --force-recreate web

PROBE_TOKEN="acme-probe-$(date +%s)"
PROBE_FILE="deploy/certbot/www/.well-known/acme-challenge/${PROBE_TOKEN}"
printf '%s' "${PROBE_TOKEN}" > "${PROBE_FILE}"

echo "Checking ACME challenge path inside local nginx..."
LOCAL_PROBE_RESPONSE="$(curl -fsSL --max-time 15 -H "Host: ${DOMAIN_NAME}" "http://127.0.0.1/.well-known/acme-challenge/${PROBE_TOKEN}" || true)"
if [[ "${LOCAL_PROBE_RESPONSE}" != "${PROBE_TOKEN}" ]]; then
  echo "Local ACME nginx preflight failed."
  echo "Expected challenge response '${PROBE_TOKEN}', got:"
  printf '%s\n' "${LOCAL_PROBE_RESPONSE}"
  echo
  echo "Check:"
  echo "  1) nginx in the web container is serving /.well-known/acme-challenge/"
  echo "  2) deploy/certbot/www is mounted into the web container"
  rm -f "${PROBE_FILE}"
  exit 1
fi

echo "Checking ACME challenge path through public DNS (IPv4)..."
PUBLIC_PROBE_RESPONSE="$(curl -4 -fsSL --max-time 15 "http://${DOMAIN_NAME}/.well-known/acme-challenge/${PROBE_TOKEN}" || true)"
if [[ "${PUBLIC_PROBE_RESPONSE}" != "${PROBE_TOKEN}" ]]; then
  echo "Public ACME preflight failed."
  echo "Expected challenge response '${PROBE_TOKEN}', got:"
  printf '%s\n' "${PUBLIC_PROBE_RESPONSE}"
  echo
  echo "Check:"
  echo "  1) domain DNS points to this server"
  echo "  2) port 80 is open in your cloud firewall / security group"
  echo "  3) no broken AAAA record is forcing IPv6 traffic elsewhere"
  rm -f "${PROBE_FILE}"
  exit 1
fi

rm -f "${PROBE_FILE}"

echo "Requesting Let's Encrypt certificate for: ${DOMAINS_CSV}"
docker run --rm \
  -v "${REPO_ROOT}/deploy/certbot/etc:/etc/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/lib:/var/lib/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/log:/var/log/letsencrypt" \
  -v "${REPO_ROOT}/deploy/certbot/www:/var/www/certbot" \
  certbot/certbot certonly \
  --non-interactive \
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
