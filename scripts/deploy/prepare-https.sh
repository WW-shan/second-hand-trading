#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

mkdir -p deploy/certs deploy/certbot/www

cat <<'EOF'
HTTPS preparation directory created.

Place your certificate files here:
  deploy/certs/fullchain.pem
  deploy/certs/privkey.pem

If you already have Let's Encrypt certs on the server, you can copy them like this:
  sudo cp /etc/letsencrypt/live/<your-domain>/fullchain.pem deploy/certs/
  sudo cp /etc/letsencrypt/live/<your-domain>/privkey.pem deploy/certs/
  sudo chown $USER:$USER deploy/certs/fullchain.pem deploy/certs/privkey.pem

Then deploy with:
  bash scripts/deploy/deploy-https.sh
EOF
