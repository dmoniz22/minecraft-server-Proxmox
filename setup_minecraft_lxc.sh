#!/bin/bash

# Minecraft Server Installer for LXC Containers on Proxmox
# Tested on Debian 11/12
# Author: TimInTech

# Update & Install Dependencies
apt update && apt upgrade -y
apt install -y openjdk-17-jre-headless screen wget curl

# Create Minecraft Server Directory
mkdir -p /opt/minecraft && cd /opt/minecraft

# Download Minecraft Server
wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/259/downloads/paper-1.20.4-259.jar

# Accept EULA
echo "eula=true" > eula.txt

# Create a Start Script
cat <<EOF > start.sh
#!/bin/bash
java -Xms2G -Xmx4G -jar server.jar nogui
EOF

chmod +x start.sh

# Start Server in Screen Session
screen -dmS minecraft ./start.sh

echo "✅ Minecraft Server setup completed! Use 'screen -r minecraft' to access the console."

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
