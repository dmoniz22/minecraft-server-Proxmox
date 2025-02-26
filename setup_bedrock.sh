#!/bin/bash

# Minecraft Bedrock Server Installer
# Works on Proxmox VM & LXC
# Author: TimInTech

# Install Dependencies
apt update && apt install -y unzip wget screen

# Create Bedrock Server Directory
mkdir -p /opt/minecraft-bedrock && cd /opt/minecraft-bedrock

# Download Bedrock Server
wget -O bedrock-server.zip https://minecraft.azureedge.net/bin-linux/bedrock-server-1.20.50.02.zip
unzip bedrock-server.zip

# Create a Start Script
cat <<EOF > start.sh
#!/bin/bash
LD_LIBRARY_PATH=. ./bedrock_server
EOF

chmod +x start.sh

# Start Server in Screen Session
screen -dmS bedrock ./start.sh

echo "✅ Minecraft Bedrock Server setup completed! Use 'screen -r bedrock' to access the console."
