#!/bin/bash
# run_dev.sh
# Load secrets and start Docker Compose

# Ensure we run from the script's directory
cd "$(dirname "$0")"

# Path to secret manager
SECRET_MGR="../../greenbee_gateway/core/manage_secrets.py"

# Try to load DB Pass from the encrypted vault
if [ -f "$SECRET_MGR" ]; then
    echo ">>> Loading DB_PASS from encrypted vault..."
    # We must run from the directory where the key file exists
    FETCHED_PASS=$(cd ../../greenbee_gateway && python3 core/manage_secrets.py get DB_PASS)
    if [ ! -z "$FETCHED_PASS" ]; then
        export DB_PASS="$FETCHED_PASS"
        echo ">>> DB_PASS loaded successfully."
    else
        echo "⚠️  Failed to fetch DB_PASS from vault (Empty). Falling back to default."
        export DB_PASS=${DB_PASS:-"greenbee_pass"}
    fi
else
    export DB_PASS=${DB_PASS:-"greenbee_pass"}
fi

echo ">>> Starting GreenBee Beyond Space Services..."
if ! docker compose up -d --build; then
    echo "⚠️  Permission denied or command failed. Retrying with sudo..."
    sudo docker network create greenbee_net || true
    sudo -E docker compose up -d --build
fi

echo ">>> Docker Compose Status:"
sudo docker compose ps
