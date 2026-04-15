#!/usr/bin/env sh
set -eu

USER_FILE_PATH="${USER_FILE_PATH:-/app/userFile}"
SEED_DIR="/opt/seed-userFile"

mkdir -p "${USER_FILE_PATH}"

if [ -d "${SEED_DIR}" ] && [ -z "$(ls -A "${USER_FILE_PATH}" 2>/dev/null || true)" ]; then
  cp -R "${SEED_DIR}/." "${USER_FILE_PATH}/"
fi

exec java ${JAVA_OPTS:-} -jar /app/server.jar
