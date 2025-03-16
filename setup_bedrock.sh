#!/bin/bash

# Minecraft Bedrock Server Installer for Proxmox LXC/VM
# Tested on Debian 11/12 and Ubuntu 24.04
# Author: TimInTech

# Update package lists and install required dependencies
apt update && apt upgrade -y
apt install -y unzip wget screen curl

# Create directory for the Minecraft Bedrock server
mkdir -p /opt/minecraft-bedrock && cd /opt/minecraft-bedrock

# Fetch the latest Bedrock Server download URL
LATEST_URL=$(curl -s https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://minecraft.azureedge.net/bin-linux/bedrock-server-[0-9.]*.zip' | head -1)

# Validate if the URL was retrieved
if [[ -z "$LATEST_URL" ]]; then
  echo "❌ ERROR: Unable to fetch the latest Bedrock Server version. Check https://www.minecraft.net/en-us/download/server/bedrock"
  exit 1
fi

echo "📥 Downloading Minecraft Bedrock Server from: $LATEST_URL"
wget -O bedrock-server.zip "$LATEST_URL"

# Validate download success
if [[ $? -ne 0 ]]; then
  echo "❌ ERROR: Download failed. Please check your network connection."
  exit 1
fi

# Extract server files
unzip -o bedrock-server.zip
rm -f bedrock-server.zip

# Create start script
cat <<EOF > start.sh
#!/bin/bash
LD_LIBRARY_PATH=. ./bedrock_server
EOF

chmod +x start.sh

# Start the server in a detached screen session
screen -dmS bedrock ./start.sh

echo "✅ Setup complete! Use 'screen -r bedrock' to access the console."
