#!/bin/bash

# Minecraft Bedrock Server Installer for Proxmox (VM & LXC)
# Dynamically fetches the latest Bedrock server version
# Author: TimInTech

# Install Dependencies
apt update && apt install -y unzip wget screen curl

# Create Bedrock Server Directory
mkdir -p /opt/minecraft-bedrock && cd /opt/minecraft-bedrock

# Fetch the latest Bedrock Server download URL
LATEST_URL=$(curl -s https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://minecraft.azureedge.net/bin-linux/bedrock-server-[0-9.]*.zip' | head -1)

# Check if URL was found
if [[ -z "$LATEST_URL" ]]; then
    echo "❌ ERROR: Could not fetch the latest Bedrock server version. Check the official page: https://www.minecraft.net/en-us/download/server/bedrock"
    exit 1
fi

echo "🌍 Downloading latest Bedrock Server from: $LATEST_URL"
wget -O bedrock-server.zip "$LATEST_URL"

# Verify the download
if [[ $? -ne 0 ]]; then
    echo "❌ ERROR: Download failed. Please check your network or try manually downloading from:"
    echo "$LATEST_URL"
    exit 1
fi

# Unzip the downloaded server files
unzip -o bedrock-server.zip
rm -f bedrock-server.zip

# Create a start script
cat <<EOF > start.sh
#!/bin/bash
LD_LIBRARY_PATH=. ./bedrock_server
EOF

chmod +x start.sh

# Start the server in a screen session
screen -dmS bedrock ./start.sh

echo "✅ Minecraft Bedrock Server installation complete! Use 'screen -r bedrock' to access the console."
