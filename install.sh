#!/bin/bash

# Define the application directory
APP_DIR="/usr/local/share/hand-sensor"

# Repository URL
REPO_URL="https://github.com/sergioloppe/rasp-pi-hand-sensor.git"

# Path to the Python virtual environment within the app directory
VENV_PATH="$APP_DIR/venv"

# Create the application directory
echo "Creating the application directory..."
sudo mkdir -p "$APP_DIR"

# Adjust the permissions so the current user can install files
echo "Adjusting permissions..."
sudo chown -R $(whoami) "$APP_DIR"

# Clone the repository
echo "Cloning the app repository into $APP_DIR..."
git clone "$REPO_URL" "$APP_DIR" || { echo "Failed to clone repository."; exit 1; }

# Create a Python virtual environment
echo "Creating a Python virtual environment..."
python3 -m venv "$VENV_PATH"

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Install dependencies
echo "Installing dependencies..."
pip install -r "$APP_DIR/requirements.txt" || { echo "Failed to install dependencies."; exit 1; }

# Deactivate the virtual environment
deactivate

# Prepare the systemd service file to use the virtual environment's Python interpreter
SERVICE_CONTENT="[Unit]
Description=Your App Description
After=network.target

[Service]
ExecStart=/bin/python $APP_DIR/main.py
WorkingDirectory=$APP_DIR
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
"

# Create the service file
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/hand-sensor.service > /dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable hand-sensor.service

# Start the service
sudo systemctl start hand-sensor.service

echo "Installation and service setup completed successfully."
