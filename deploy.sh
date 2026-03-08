#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
VPS_USER="debian"
VPS_HOST="vps-31bd15c5.vps.ovh.net"
VPS_PORT="57999"
IMAGE_NAME="discord-bot"
CONTAINER_NAME="discord-bot"
LOG_VOLUME="discord-bot-logs"
ENV_FILE="/opt/discord-bot.env"
# ─────────────────────────────────────────────────────────────────────────────

SSH="ssh -p $VPS_PORT $VPS_USER@$VPS_HOST"

echo "==> Building Docker image..."
podman build -t "$IMAGE_NAME" .

echo "==> Transferring image to VPS..."
podman save "$IMAGE_NAME" | gzip | $SSH "gunzip | docker load"

echo "==> Restarting container..."
$SSH "
  docker stop $CONTAINER_NAME 2>/dev/null || true
  docker rm   $CONTAINER_NAME 2>/dev/null || true
  docker run -d \
    --name $CONTAINER_NAME \
    --restart always \
    --env-file $ENV_FILE \
    -v $LOG_VOLUME:/app/logs \
    $IMAGE_NAME
"

echo "==> Done. Container status:"
$SSH "docker ps --filter name=$CONTAINER_NAME"
