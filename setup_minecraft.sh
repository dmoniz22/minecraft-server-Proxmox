#!/bin/bash

# Minecraft Java Server Installer for Proxmox LXC/VM
# Tested on Debian 11/12 and Ubuntu 24.04
# Author: TimInTech

set -e  # Exit script on error

# Install required dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-17-jre-headless screen wget curl jq

# Set up server directory
sudo mkdir -p /opt/minecraft
sudo chown $(whoami):$(whoami) /opt/minecraft
cd /opt/minecraft

# Fetch the latest PaperMC version
LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions | last')
LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$LATEST_VERSION | jq -r '.builds | last')

# Validate if version and build numbers were retrieved
if [[ -z "$LATEST_VERSION" || -z "$LATEST_BUILD" ]]; then
  echo "ERROR: Unable to fetch the latest PaperMC version. Check https://papermc.io/downloads"
  exit 1
fi

echo "Downloading PaperMC - Version: $LATEST_VERSION, Build: $LATEST_BUILD"
wget -O server.jar "https://api.papermc.io/v2/projects/paper/versions/$LATEST_VERSION/builds/$LATEST_BUILD/downloads/paper-$LATEST_VERSION-$LATEST_BUILD.jar"

# Accept the Minecraft EULA
echo "eula=true" > eula.txt

# Create start script
cat <<EOF > start.sh
#!/bin/bash
java -Xms2G -Xmx4G -jar server.jar nogui
EOF

chmod +x start.sh

# Ensure screen is installed before starting the server
if ! command -v screen &> /dev/null; then
  echo "ERROR: 'screen' is not installed. Install it with 'sudo apt install screen'."
  exit 1
fi

# Start the server in a detached screen session
screen -dmS minecraft ./start.sh

echo "Setup complete! Use 'screen -r minecraft' to open the console."
