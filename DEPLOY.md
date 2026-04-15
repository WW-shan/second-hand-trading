# Ubuntu Deployment Guide

## Recommended architecture

This repo should be deployed on Ubuntu as a **single-host Docker Compose stack**:

- `web`: Nginx + built Vue frontend
- `server`: Spring Boot backend
- `mysql`: MySQL 8.4

`eureka-server` and `zuul` are **not used** in the deployment path. For a single Ubuntu host, they add complexity without useful value.

## Prerequisites

Install Docker Engine and the Compose plugin on Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## First deployment

```bash
git clone <your-repo-url> second-hand-trading
cd second-hand-trading
cp .env.example .env
```

Edit `.env`:

- set `MYSQL_ROOT_PASSWORD`
- set `MYSQL_PASSWORD`
- set `PUBLIC_BASE_URL`

Then start:

```bash
docker compose build
docker compose up -d
```

## One-command path on Ubuntu

If you want the shortest path:

```bash
sudo bash scripts/deploy/ubuntu-bootstrap.sh
nano .env
bash scripts/deploy/deploy.sh
```

## Real one-click deployment

If you want one entrypoint that handles:

- Docker bootstrap
- HTTP deployment
- HTTPS deployment
- Let's Encrypt request
- post-deploy checks

use:

```bash
bash scripts/deploy/one-click-deploy.sh
```

Behavior:

- if Docker is missing, it installs Docker first
- if `.env` is missing, it creates one from `.env.example`
- if `PUBLIC_BASE_URL` starts with `https://`, it deploys HTTPS
- if HTTPS is requested and no local cert files exist, it tries Let's Encrypt automatically
- otherwise it deploys plain HTTP

## Access

- Frontend: `http://<server-ip-or-domain>`
- Backend (through reverse proxy): `http://<server-ip-or-domain>/api`

Default demo login:

- user: `17322611234 / 123456`
- admin: `root / 123456`

## Data persistence

Persistent data is stored in:

- `./deploy-data/mysql`
- `./userFile`

`./userFile` is also used for seeded demo images and future uploads.

## Common operations

### View logs

```bash
docker compose logs -f web
docker compose logs -f server
docker compose logs -f mysql
```

### Restart

```bash
docker compose restart
```

### Rebuild after code changes

```bash
docker compose down
docker compose build
docker compose up -d
```

### Reset database to demo seed

This deletes MySQL data and recreates it from `second_hand_trading.sql`:

```bash
bash scripts/deploy/reset-demo-data.sh
```

### Backup database

```bash
bash scripts/deploy/backup-db.sh
```

### Verify deployment

```bash
bash scripts/deploy/check-stack.sh
```

## Notes

- Uploaded file URLs are generated from `PUBLIC_BASE_URL + /api`.
- Nginx proxies `/api/*` to the backend and serves the Vue app at `/`.
- If you later add HTTPS, keep the public domain the same and update `PUBLIC_BASE_URL` accordingly.

## HTTPS later

An HTTPS-ready Nginx example is included:

- `docker-compose.https.yml`
- `deploy/nginx/default.ssl.conf`
- `deploy/nginx/default.ssl.conf.example`
- `scripts/deploy/prepare-https.sh`
- `scripts/deploy/deploy-https.sh`
- `scripts/deploy/check-https.sh`
- `scripts/deploy/request-letsencrypt.sh`
- `scripts/deploy/renew-letsencrypt.sh`
- `scripts/deploy/sync-letsencrypt-certs.sh`

Typical path:

1. prepare certificate directories:

```bash
bash scripts/deploy/prepare-https.sh
```

2. place your certificate files:

```text
deploy/certs/fullchain.pem
deploy/certs/privkey.pem
```

3. set the public URL in `.env`:

```env
PUBLIC_BASE_URL=https://your-domain
HTTPS_PORT=443
```

4. deploy HTTPS:

```bash
bash scripts/deploy/deploy-https.sh
```

5. verify HTTPS:

```bash
bash scripts/deploy/check-https.sh
```

### If you already use Let's Encrypt on the host

Copy:

```text
/etc/letsencrypt/live/<your-domain>/fullchain.pem
/etc/letsencrypt/live/<your-domain>/privkey.pem
```

into:

```text
deploy/certs/
```

## Let's Encrypt automation

If your domain already points to this Ubuntu server on port 80, you can request a certificate automatically.

Add these values to `.env`:

```env
DOMAIN_NAME=example.com
CERTBOT_EMAIL=admin@example.com
CERTBOT_DOMAINS=example.com,www.example.com
PUBLIC_BASE_URL=https://example.com
```

Then request the certificate:

```bash
bash scripts/deploy/request-letsencrypt.sh
```

After the certificate is issued:

```bash
bash scripts/deploy/deploy-https.sh
bash scripts/deploy/check-https.sh
```

### Renew later

Manual renewal:

```bash
bash scripts/deploy/renew-letsencrypt.sh
```

Example cron entry:

```bash
0 3 * * * cd /opt/second-hand-trading && bash scripts/deploy/renew-letsencrypt.sh >> /var/log/second-hand-renew.log 2>&1
```
