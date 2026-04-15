#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

ensure_docker() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    return 0
  fi

  echo "Docker / Compose not found. Bootstrapping Ubuntu dependencies..."
  if [[ "${EUID}" -eq 0 ]]; then
    bash scripts/deploy/ubuntu-bootstrap.sh
  elif command -v sudo >/dev/null 2>&1; then
    sudo bash scripts/deploy/ubuntu-bootstrap.sh
  else
    echo "sudo is required to install Docker on Ubuntu."
    exit 1
  fi
}

ensure_env() {
  if [[ ! -f .env ]]; then
    cp .env.example .env
    echo ".env created from .env.example"
    echo "Please edit .env first, then rerun:"
    echo "  bash scripts/deploy/one-click-deploy.sh"
    exit 1
  fi
}

load_env() {
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
}

validate_passwords() {
  if grep -q "change-me-root-password" .env || grep -q "change-me-app-password" .env; then
    echo "Please replace default passwords in .env before deployment."
    exit 1
  fi
}

is_https_mode() {
  [[ "${PUBLIC_BASE_URL:-}" == https://* ]]
}

deploy_http() {
  echo "Deploy mode: HTTP"
  bash scripts/deploy/deploy.sh
  bash scripts/deploy/check-stack.sh
}

deploy_https() {
  echo "Deploy mode: HTTPS"

  if [[ -f deploy/certs/fullchain.pem && -f deploy/certs/privkey.pem ]]; then
    echo "Existing certificate files found under deploy/certs"
  else
    if [[ -z "${DOMAIN_NAME:-}" || -z "${CERTBOT_EMAIL:-}" ]]; then
      echo "HTTPS requested but DOMAIN_NAME / CERTBOT_EMAIL are missing in .env"
      exit 1
    fi
    echo "No local certificate files found. Requesting Let's Encrypt certificates..."
    bash scripts/deploy/request-letsencrypt.sh
  fi

  bash scripts/deploy/deploy-https.sh
  bash scripts/deploy/check-https.sh
}

main() {
  ensure_docker
  ensure_env
  load_env
  validate_passwords

  if is_https_mode; then
    deploy_https
  else
    deploy_http
  fi
}

main "$@"
