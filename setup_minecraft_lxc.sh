#!/bin/bash

# Minecraft Server Installer für LXC-Container auf Proxmox
# Getestet auf Debian 11/12
# Autor: TimInTech

# Update & Installation der Abhängigkeiten
apt update && apt upgrade -y
apt install -y openjdk-17-jre-headless screen wget curl

# Erstellen des Minecraft Server Verzeichnisses
mkdir -p /opt/minecraft && cd /opt/minecraft

# Herunterladen des Minecraft Servers
LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$LATEST_VERSION | jq -r '.builds[-1]')
wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/$LATEST_VERSION/builds/$LATEST_BUILD/downloads/paper-$LATEST_VERSION-$LATEST_BUILD.jar

# Akzeptieren der EULA
echo "eula=true" > eula.txt

# Erstellen eines Start-Skripts
cat <<EOF > start.sh
#!/bin/bash
java -Xms2G -Xmx4G -jar server.jar nogui
EOF

chmod +x start.sh

# Starten des Servers in einer Screen-Session
screen -dmS minecraft ./start.sh

echo "✅ Minecraft Server Einrichtung abgeschlossen! Verwende 'screen -r minecraft', um auf die Konsole zuzugreifen."
