#!/bin/bash
set -e

USER=ken
DOCKER_DIR="/docker"
UPDATE_SCRIPT="$DOCKER_DIR/update-docker.sh"
SERVICE_FILE="/etc/systemd/system/docker-auto-update.service"
TIMER_FILE="/etc/systemd/system/docker-auto-update.timer"

echo "📦 Creating Docker update script at $UPDATE_SCRIPT..."
mkdir -p "$DOCKER_DIR"
cat > "$UPDATE_SCRIPT" <<'EOF'
#!/bin/bash
set -e
cd /home/pi/docker

# Fetch remote changes
git fetch origin

# Check if anything actually changed
if ! git diff --quiet HEAD origin/main; then
  echo "$(date): Changes detected, pulling and redeploying..."
  git pull origin main
  docker compose pull
  docker compose up -d
else
  echo "$(date): No changes, skipping update."
fi
EOF

chmod +x "$UPDATE_SCRIPT"

echo "🛠️ Creating systemd service..."
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Update Docker Compose on Git Pull
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
User=$USER
WorkingDirectory=$DOCKER_DIR
ExecStart=$UPDATE_SCRIPT
EOF

echo "⏱️ Creating systemd timer..."
cat > "$TIMER_FILE" <<EOF
[Unit]
Description=Run Docker Auto-Update every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo "🔄 Reloading systemd and enabling timer..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now docker-auto-update.timer

echo "✅ Docker auto-update system is now active!"
systemctl list-timers | grep docker-auto-update
