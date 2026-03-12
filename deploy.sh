#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
VPS_USER=""
VPS_HOST=""
VPS_PORT=""
IMAGE_NAME="discord-bot"
CONTAINER_NAME="discord-bot"
ENV_FILE="/opt/discord-bot.env"
# ─────────────────────────────────────────────────────────────────────────────

SSH="ssh -p $VPS_PORT $VPS_USER@$VPS_HOST"

echo "==> Building Docker image..."
podman build -t "$IMAGE_NAME" .

echo "==> Transferring image to VPS..."
podman save "localhost/$IMAGE_NAME" | gzip | $SSH "gunzip | docker load && docker tag localhost/$IMAGE_NAME $IMAGE_NAME"

echo "==> Restarting container..."
$SSH "
  docker stop $CONTAINER_NAME 2>/dev/null || true
  docker rm   $CONTAINER_NAME 2>/dev/null || true
  docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    --env-file $ENV_FILE \
    $IMAGE_NAME
"

echo "==> Done. Container status:"
$SSH "docker ps --filter name=$CONTAINER_NAME"
