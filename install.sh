#!/bin/bash

# Define the application directory
APP_DIR="/usr/local/share/hand-sensor"

# Repository URL
REPO_URL="https://github.com/sergioloppe/rasp-pi-hand-sensor.git"

# Path to the Python virtual environment within the app directory
VENV_PATH="$APP_DIR/venv"

# Ensure the application directory exists
echo "Creating the application directory..."
sudo mkdir -p "$APP_DIR"
sudo chown -R $(whoami) "$APP_DIR"  # Adjust permissions

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
Description=Hand Sensor Application
After=network.target

[Service]
ExecStart=$VENV_PATH/bin/python $APP_DIR/main.py
WorkingDirectory=$APP_DIR
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
"

# Create and configure the service file
echo "Creating systemd service file..."
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/hand-sensor.service > /dev/null

# Reload systemd, enable, and start the new service
sudo systemctl daemon-reload
sudo systemctl enable hand-sensor.service
sudo systemctl start hand-sensor.service

echo "Installation and service setup completed successfully."
