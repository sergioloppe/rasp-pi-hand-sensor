#!/bin/bash

# Define the application directory
APP_DIR="/usr/local/share/hand-sensor"

# Repository URL
REPO_URL="https://github.com/username/your-repository.git"

# Create the application directory
echo "Creating the application directory..."
sudo mkdir -p "$APP_DIR"

# Clone the repository
echo "Cloning the app repository into $APP_DIR..."
sudo git clone "$REPO_URL" "$APP_DIR" || { echo "Failed to clone repository."; exit 1; }

# Change ownership to the current user to install dependencies without sudo
echo "Changing ownership of $APP_DIR..."
sudo chown -R $(whoami) "$APP_DIR"

# Install dependencies (if any)
echo "Installing dependencies..."
pip3 install -r "$APP_DIR/requirements.txt" || { echo "Failed to install dependencies."; exit 1; }

# Setup and enable the systemd service
echo "Setting up the systemd service..."
SERVICE_FILE="$APP_DIR/hand-sensor.service"
sudo cp "$SERVICE_FILE" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable hand-sensor.service
sudo systemctl start hand-sensor.service

echo "Installation completed successfully."
