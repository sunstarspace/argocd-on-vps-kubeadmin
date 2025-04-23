#!/bin/bash

echo "=== Kubeconfig Fetch Script ==="

# Ask for remote VPS details
read -p "Enter the remote server IP address: " VPS_IP
read -p "Enter the SSH port (default 22): " VPS_PORT
VPS_PORT=${VPS_PORT:-22}

read -p "Enter the SSH username: " VPS_USER

# Ask for SSH key path
DEFAULT_SSH_KEY="$HOME/.ssh/id_rsa"
read -p "$DEFAULT_SSH_KEY" -p "Enter the path to your private SSH key [default: $HOME/.ssh/id_rsa]: " SSH_KEY
SSH_KEY=${SSH_KEY:-$DEFAULT_SSH_KEY}

# Ask for remote kubeconfig path, default based on username
read -p "Enter the remote kubeconfig path [default: /home/$VPS_USER/.kube/config]: " REMOTE_KUBECONFIG_PATH
REMOTE_KUBECONFIG_PATH=${REMOTE_KUBECONFIG_PATH:-/home/$VPS_USER/.kube/config}

# Verify ~/.kube directory on local machine
KUBE_DIR="$HOME/.kube"
if [ ! -d "$KUBE_DIR" ]; then
  echo "Directory $KUBE_DIR does not exist."
  read -p "Do you want to create it? (y/n): " CREATE_KUBE
  if [[ "$CREATE_KUBE" =~ ^[Yy]$ ]]; then
    echo "Creating $KUBE_DIR..."
    mkdir -p "$KUBE_DIR"
    echo "Directory created."
  else
    echo "Aborting: kubeconfig cannot be copied without ~/.kube directory."
    exit 1
  fi
else
  echo "Directory $KUBE_DIR exists."
fi

# Backup existing kubeconfig if present
echo "######### Checking if kubeconfig already exists... ######### "
if [ -f "$KUBE_DIR/config" ]; then
  echo "!!!!!!!!! A kubeconfig already exists at $KUBE_DIR/config !!!!!!!!!"
  sleep 3
  echo "######### The script will create a backup before overwriting it. #########"
  sleep 3
  BACKUP_NAME="config.backup.$(date +%s)"
  cp "$KUBE_DIR/config" "$KUBE_DIR/$BACKUP_NAME"
  echo "######### Existing config backed up as $KUBE_DIR/$BACKUP_NAME #########"
  sleep 3
else
  echo "######### No existing kubeconfig found — no backup needed. #########"
  sleep 3
fi

# Copy kubeconfig from remote
echo "--------- Attempting to copy kubeconfig from $VPS_USER@$VPS_IP:$REMOTE_KUBECONFIG_PATH... ---------"
sleep 3

scp -i "$SSH_KEY" -P "$VPS_PORT" "$VPS_USER@$VPS_IP:$REMOTE_KUBECONFIG_PATH" "$KUBE_DIR/config"

if [ $? -eq 0 ]; then
  echo "--------- Kubeconfig successfully copied to $KUBE_DIR/config ---------"
  echo "--------- You can now use kubectl with your new configuration. ---------"
else
  echo "!!!!! Failed to copy kubeconfig. Please check your connection, credentials, and remote file path. !!!!!"
  exit 1
fi
